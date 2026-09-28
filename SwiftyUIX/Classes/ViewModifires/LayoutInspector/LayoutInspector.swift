//
//  LayOutInspector.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 9/22/26.
//

// `DeviceHinge` and `ReservedRegion` ship in the iOS SDK only, so the whole inspector is
// iOS-only. macOS gets the rest of SwiftyUIX as before.
#if os(iOS)
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Supporting types

public enum DeviceType: String, Sendable {
    case phone, foldablePhone, pad, mac, tv, carPlay, vision, unknown

    /// True for every iPhone, including the foldable iPhone Duo.
    public var isPhoneFamily: Bool { self == .phone || self == .foldablePhone }

    @MainActor
    static var current: DeviceType {
        #if os(macOS)
        return .mac
        #elseif canImport(UIKit)
        if ProcessInfo.processInfo.isiOSAppOnMac { return .mac }
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:   return .phone
        case .pad:     return .pad
        case .mac:     return .mac
        case .tv:      return .tv
        case .carPlay: return .carPlay
        case .vision:  return .vision
        default:       return .unknown
        }
        #else
        return .unknown
        #endif
    }
}

/// Orientation derived from the actual layout bounds.
/// Correct for Split View, Slide Over, Stage Manager and resizable windows.
public enum LayoutOrientation: Sendable {
    case portrait, landscape
}

/// Fold posture of a foldable device (iPhone Duo).
/// Kept as our own type so the stored property needs no availability gate.
public enum FoldPosture: Sendable {
    case closed         // folded shut, app is on the outer display
    case partiallyOpen  // tabletop / book pose
    case fullyOpen      // flat, inner display
}

// MARK: - LayoutInspector

@MainActor
@Observable
public final class LayoutInspector {
    public static let shared = LayoutInspector()

    // MARK: Layout state

    public private(set) var currentLayoutBounds: CGRect = .zero
    public internal(set) var safeAreaInsets = EdgeInsets()

    /// Use this for UI decisions (layout-based, not sensor-based).
    public private(set) var orientation: LayoutOrientation = .portrait
    public var isLandscape: Bool { orientation == .landscape }
    public var isPortrait: Bool { orientation == .portrait }

    /// Starts from the UI idiom, then becomes `.foldablePhone` the first time
    /// a hinge is reported. Observed, because that upgrade happens after launch.
    public internal(set) var deviceType: DeviceType
    public var isPhone: Bool { deviceType.isPhoneFamily }
    public var isIPad: Bool { deviceType == .pad }

    // MARK: Foldable (iPhone Duo)

    /// True once the system reports a hinge.
    public var isFoldable: Bool { deviceType == .foldablePhone }
    public var isIPhoneDuo: Bool { isFoldable }

    /// `nil` on devices without a hinge.
    public private(set) var foldPosture: FoldPosture?
    public private(set) var hingeAngle: Angle?
    public var isFolded: Bool { foldPosture == .closed }
    public var isPartiallyFolded: Bool { foldPosture == .partiallyOpen }
  

    #if os(iOS)
    /// Raw physical orientation from the sensor (includes faceUp/faceDown/unknown).
    public private(set) var deviceOrientation: UIDeviceOrientation = .unknown
    @ObservationIgnored private var orientationObserver: NSObjectProtocol?
    #endif

    public private(set) var hasActiveDivision = false

    /// Active regions flattened to plain rects, each already grown by its `margins`, in the
    /// same space as `currentLayoutBounds`. Kept as `[CGRect]` so `TabBarPlacement` can do
    /// its geometry without an availability gate on every read.
    public internal(set) var activeDivisionFrames: [CGRect] = []
    public internal(set) var activeOcclusionFrames: [CGRect] = []

    // MARK: Reserved regions
    // Stored as a single `Any?` (not `[Any]`) so the class layout has no
    // availability gate, and reads are a cheap unbox instead of an O(n)
    // element-by-element `[Any] -> [ReservedRegion]` cast on every access.
    private var _divisions: Any?
    private var _occlusions: Any?

    @available(anyAppleOS 27.1, *)
    public var divisions: [ReservedRegion] {
        get { _divisions as? [ReservedRegion] ?? [] }
        set {
            _divisions = newValue
            let active = newValue.contains { $0.isActive }
            if active != hasActiveDivision { hasActiveDivision = active }
            let frames = Self.blockingFrames(newValue)
            if frames != activeDivisionFrames { activeDivisionFrames = frames }
        }
    }

    @available(anyAppleOS 27.1, *)
    public var occlusions: [ReservedRegion] {
        get { _occlusions as? [ReservedRegion] ?? [] }
        set {
            _occlusions = newValue
            let frames = Self.blockingFrames(newValue)
            if frames != activeOcclusionFrames { activeOcclusionFrames = frames }
        }
    }

    /// Active regions only — an inactive one reserves nothing — grown by the margins the
    /// system asks content to keep around them.
    @available(anyAppleOS 27.1, *)
    private static func blockingFrames(_ regions: [ReservedRegion]) -> [CGRect] {
        regions.compactMap { region in
            guard region.isActive else { return nil }
            let margins = region.margins
            return CGRect(x: region.frame.minX - margins.leading,
                          y: region.frame.minY - margins.top,
                          width: region.frame.width + margins.leading + margins.trailing,
                          height: region.frame.height + margins.top + margins.bottom)
        }
    }

    // MARK: Init

    public init() {
        deviceType = .current
        #if os(iOS)
        startDeviceOrientationUpdates()
        #endif
    }

    // MARK: Safe area accessors

    public var leadingSafeArea: CGFloat  { safeAreaInsets.leading }
    public var trailingSafeArea: CGFloat { safeAreaInsets.trailing }
    public var topSafeArea: CGFloat      { safeAreaInsets.top }
    public var bottomSafeArea: CGFloat   { safeAreaInsets.bottom }

    public var horizontalSafeAreaInsets: (edge: Edge.Set, value: CGFloat) {
        if safeAreaInsets.leading > 0  { return (.leading, safeAreaInsets.leading) }
        if safeAreaInsets.trailing > 0 { return (.trailing, safeAreaInsets.trailing) }
        return (.leading, .zero)
    }

    func safeArea(of edge: Edge, ifZero fallback: CGFloat = 0, plus extra: CGFloat = 0) -> CGFloat {
        let value = inset(for: edge)
        return (value == 0 ? fallback : value) + extra
    }

    private func inset(for edge: Edge) -> CGFloat {
        switch edge {
        case .top:      safeAreaInsets.top
        case .leading:  safeAreaInsets.leading
        case .bottom:   safeAreaInsets.bottom
        case .trailing: safeAreaInsets.trailing
        }
    }

    // MARK: Updates from geometry
    // Every write to an @Observable property notifies observers, even when the
    // value is identical, so each setter is guarded to avoid needless redraws.

    public func configWithSafeArea(proxy: GeometryProxy) {
        let insets = proxy.safeAreaInsets
        guard insets != safeAreaInsets else { return }
        withAnimation(.snappy) { safeAreaInsets = insets }
    }

    public func configWithOutSafeArea(proxy: GeometryProxy) {
        updateBounds(proxy.frame(in: .global))
        // mapOcclusionsAndDivisions(proxy: proxy)
    }

    public func updateBounds(_ rect: CGRect) {
        guard rect != currentLayoutBounds else { return }
        currentLayoutBounds = rect

        let newOrientation: LayoutOrientation = rect.width > rect.height ? .landscape : .portrait
        if newOrientation != orientation { orientation = newOrientation }
    }

    func mapOcclusionsAndDivisions(proxy: GeometryProxy) {
        if #available(anyAppleOS 27.1, *) {
            divisions  = Array(proxy.reservedRegions(kind: .division,  options: .includeInactive))
            occlusions = Array(proxy.reservedRegions(kind: .occlusion, options: .includeInactive))
        }
    }

    @available(anyAppleOS 27.1, *)
    func mapOcclusionsAndDivisions(divisions: [ReservedRegion], occlusions: [ReservedRegion]) {
        self.divisions = divisions
        self.occlusions = occlusions
    }

    @available(anyAppleOS 27.1, *)
    func updateOcclusions(occlusions: [ReservedRegion]) {
        self.occlusions = occlusions
    }

    @available(anyAppleOS 27.1, *)
    func updateDivisions(divisions: [ReservedRegion]) {
        self.divisions = divisions   // hasActiveDivision is updated by the setter
    }

    // MARK: Hinge

    #if os(iOS)
    @available(iOS 27.1, *)
    func updateHinge(_ hinge: DeviceHinge?) {
        // `nil` means no hinge in this hierarchy, so keep whatever we already know.
        guard let hinge else { return }

        if deviceType != .foldablePhone { deviceType = .foldablePhone }
        if hinge.angle != hingeAngle { hingeAngle = hinge.angle }
        let posture: FoldPosture? = switch hinge.status {
        case .closed:        .closed
        case .partiallyOpen: .partiallyOpen
        case .fullyOpen:     .fullyOpen
        default:    nil
        }
        if posture != foldPosture { foldPosture = posture }
    }
    #endif

    // MARK: Physical orientation

    #if os(iOS)
    private func startDeviceOrientationUpdates() {
        let device = UIDevice.current
        device.beginGeneratingDeviceOrientationNotifications()
        deviceOrientation = device.orientation

        orientationObserver = NotificationCenter.default.addObserver(
            forName: UIDevice.orientationDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            MainActor.assumeIsolated {
                guard let self else { return }
                let new = UIDevice.current.orientation
                if new != self.deviceOrientation { self.deviceOrientation = new }
            }
        }
    }
    #endif
}

// MARK: - Hinge tracking modifier

@MainActor
public extension View {
    /// Attach once near the root (e.g. on your WindowGroup's root view).
    /// No-op on older OS versions and on devices without a hinge.
    func trackDeviceHinge() -> some View {
        trackDeviceHinge(.shared)
    }

    @ViewBuilder
    func trackDeviceHinge(_ inspector: LayoutInspector) -> some View {
        #if os(iOS)
        if #available(iOS 27.1, *) {
            onHingeChange { _, newContext in
                inspector.updateHinge(newContext.hinge)
            }
        } else {
            self
        }
        #else
        self
        #endif
    }
}

public struct LayoutInspectionView: View {
    public init(){}
    
    public var body: some View {
        ZStack{
            GeometryReader { reader in
                Color.clear.onAppear {
                    LayoutInspector.shared.configWithSafeArea(proxy: reader)
                }
                .onChange(of: reader.frame(in: .global)) { _, newValue in
                    LayoutInspector.shared.configWithSafeArea(proxy: reader)
                }
            }
            
            GeometryReader { reader in
                Color.clear.onAppear {
                    LayoutInspector.shared.configWithOutSafeArea(proxy: reader)
                }
                .onChange(of: reader.frame(in: .global)) { _, newValue in
                    LayoutInspector.shared.configWithOutSafeArea(proxy: reader)
                }
            }
            .ignoresSafeArea()
            if #available(anyAppleOS 27.1, *) {
                GeometryReader { proxy in
                    let drawDivisions = proxy.reservedRegions(kind: .division, options: .includeInactive)
                    let drawOcclusions = proxy.reservedRegions(kind: .occlusion,  options: .includeInactive)
                    EmptyView()
                        .task {
                            LayoutInspector.shared.mapOcclusionsAndDivisions(divisions: drawDivisions, occlusions: drawOcclusions)
                        }
                        .onChange(of: drawOcclusions, { oldValue, newValue in
                            LayoutInspector.shared.updateOcclusions(occlusions: drawOcclusions)
                        })
                        .onChange(of: drawDivisions, { oldValue, newValue in
                            LayoutInspector.shared.updateDivisions(divisions: drawDivisions)
                        })
                        
                    }
                // Same space as `currentLayoutBounds`: without this the region frames are
                // offset by the safe area and no placement math lines up.
                .ignoresSafeArea()
            }
        }
        .allowsHitTesting(false)
        // Without this the hinge is never observed: nothing else calls `updateHinge`.
        .trackDeviceHinge()
    }
}


// MARK: - Display labels
 
public extension LayoutOrientation {
    var label: String {
        switch self {
        case .portrait: "Portrait"
        case .landscape: "Landscape"
        }
    }
}
 
public extension FoldPosture {
    var label: String {
        switch self {
        case .closed: "Closed (outer display)"
        case .partiallyOpen: "Partially open"
        case .fullyOpen: "Fully open"
        }
    }
}
 
public extension DeviceType {
    var label: String {
        switch self {
        case .phone: "iPhone"
        case .foldablePhone: "iPhone (foldable)"
        case .pad: "iPad"
        case .mac: "Mac"
        case .tv: "Apple TV"
        case .carPlay: "CarPlay"
        case .vision: "Vision Pro"
        case .unknown: "Unknown"
        }
    }
}
 
#if os(iOS)
public extension UIDeviceOrientation {
    var label: String {
        switch self {
        case .portrait: "Portrait"
        case .portraitUpsideDown: "Upside down"
        case .landscapeLeft: "Landscape left"
        case .landscapeRight: "Landscape right"
        case .faceUp: "Face up"
        case .faceDown: "Face down"
        case .unknown: "Unknown"
        @unknown default: "Unknown"
        }
    }
}
#endif
#endif
