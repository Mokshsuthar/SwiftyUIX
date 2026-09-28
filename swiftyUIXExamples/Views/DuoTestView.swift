//
//  DuoTestView.swift
//  swiftyUIXExamples
//
//  Created by John kim on 9/22/26.
//

import SwiftUI
import SwiftyUIX
import Foundation

struct DuoTestView: View {

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(LayoutInspector.self) private var Inspector

    @Namespace private var glassNamespace

    @State var statusbarHidden: Visibility = .visible

    /// Two columns once there is room for them; one on a compact panel.
    private var isWide: Bool { horizontalSizeClass == .regular }

    private var placement: TabBarArea { Inspector.tabBarArea }

    /// Room to leave under the cards for the bar. A rail sits in the safe area the scroll view
    /// already avoids, so only a bottom bar needs anything — and only the part of it that
    /// stands above the home indicator, since that strip is inset for us as well.
    private var scrollBottomInset: CGFloat {
        guard !placement.isRail else { return 0 }
        return max(0, placement.recommendedThickness - placement.safeContentInsets.bottom)
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Bento.background.ignoresSafeArea()

            ScrollView(.vertical) {
                bento
                    .padding(16)
                    .padding(.bottom, scrollBottomInset)
            }
            .scrollIndicators(.hidden)

            if #available(anyAppleOS 27.1, *) {
                deadSpotMapping()
                    // Region frames are reported in full-bleed window space.
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }

            tabBarPlacementOverlay
        }
    }

    // MARK: - Bento

    @ViewBuilder
    private var bento: some View {
        Grid(alignment: .topLeading, horizontalSpacing: 12, verticalSpacing: 12) {
            GridRow {
                screenCard.gridCellColumns(isWide ? 2 : 1)
            }

            if isWide {
                GridRow {
                    safeAreaCard
                    deviceCard
                }
            } else {
                GridRow { safeAreaCard }
                GridRow { deviceCard }
            }

            if Inspector.isIPhoneDuo {
                GridRow {
                    foldableCard.gridCellColumns(isWide ? 2 : 1)
                }
            }

            GridRow {
                tabBarCard.gridCellColumns(isWide ? 2 : 1)
            }

            if isWide {
                GridRow {
                    regionsCard
                    coverageCard
                }
            } else {
                GridRow { regionsCard }
                GridRow { coverageCard }
            }
        }
    }

    // MARK: - Cards

    private var screenCard: some View {
        BentoCard(title: "Layout", icon: "rectangle.dashed", accent: .teal) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Metric(String(format: "%.0f", Inspector.currentLayoutBounds.width), accent: .teal)
                    Text("×")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Bento.label)
                    Metric(String(format: "%.0f", Inspector.currentLayoutBounds.height), unit: "pt")
                }
                .lineLimit(1)
                .minimumScaleFactor(0.6)

                HStack(spacing: 8) {
                    Pill(sizeClassLabel(horizontalSizeClass) + " × " + sizeClassLabel(verticalSizeClass),
                         icon: "square.resize")
                    Pill(Inspector.orientation.label,
                         icon: Inspector.isLandscape ? "rectangle" : "rectangle.portrait")
                }
            }
        }
    }

    private var safeAreaCard: some View {
        BentoCard(title: "Safe area", icon: "square.inset.filled", accent: .mint) {
            SafeAreaBox(insets: Inspector.safeAreaInsets,
                        window: Inspector.currentLayoutBounds.size)
        }
    }

    private var deviceCard: some View {
        BentoCard(title: "Device", icon: "iphone.gen3", accent: .cyan) {
            VStack(alignment: .leading, spacing: 12) {
                Text(Inspector.deviceType.label)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Bento.value)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)

                VStack(alignment: .leading, spacing: 9) {
                    StatRow("Layout", text: Inspector.orientation.label)
                    #if os(iOS)
                    StatRow("Physical", text: Inspector.deviceOrientation.label)
                    #endif
                }
            }
        }
    }

    private var foldableCard: some View {
        BentoCard(title: "Foldable", icon: "macbook.and.iphone", accent: .green) {
            HStack(alignment: .center, spacing: 18) {
                hingeGauge
                    .frame(width: 96, height: 96)

                VStack(alignment: .leading, spacing: 12) {
                    Text(Inspector.foldPosture?.label ?? "—")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Bento.value)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)

                    SegmentBar(filled: postureStep, total: 3, color: .green)

                    VStack(alignment: .leading, spacing: 9) {
                        StatRow("iPhone Duo", text: "Yes", highlight: true)
                        StatRow("Active division",
                                text: Inspector.hasActiveDivision ? "Yes" : "No",
                                highlight: Inspector.hasActiveDivision)
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }

    /// Closed, part-way, or flat — the same three states the segment bar fills.
    private var postureStep: Int {
        switch Inspector.foldPosture {
        case .closed: 1
        case .partiallyOpen: 2
        case .fullyOpen: 3
        case nil: 0
        }
    }

    /// The hinge drawn as the fold itself: two leaves separated by the reported angle, so 0°
    /// shuts them together and 180° lays them flat.
    private var hingeGauge: some View {
        let degrees = Inspector.hingeAngle?.degrees ?? 0
        return ZStack {
            Circle().fill(Bento.well)

            ForEach([-1.0, 1.0], id: \.self) { side in
                Capsule()
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 5, height: 32)
                    .offset(y: -16)
                    .rotationEffect(.degrees(side * degrees / 2))
            }

            Circle()
                .fill(Color.green)
                .frame(width: 9, height: 9)

            VStack {
                Spacer()
                Text(String(format: "%.0f°", degrees))
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(Bento.value)
            }
            .padding(.bottom, 9)
        }
        .animation(.snappy, value: degrees)
    }

    private var tabBarCard: some View {
        BentoCard(title: "Tab bar placement", icon: "rectangle.bottomthird.inset.filled", accent: .yellow) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Pill(placement.edgeLabel, icon: placement.isRail ? "arrow.right.to.line" : "arrow.down.to.line")
                    Pill(placement.axisLabel, icon: placement.isRail ? "arrow.up.and.down" : "arrow.left.and.right")
                    if placement.isReservedColumn {
                        Pill("Camera column", icon: "camera.aperture", accent: .green)
                    }
                }

                HStack(alignment: .center, spacing: 16) {
                    placementDiagram
                        .frame(width: 84, height: 104)

                    VStack(alignment: .leading, spacing: 9) {
                        StatRow("Recommended", value: placement.recommendedThickness, highlight: true)
                        StatRow("Max thickness", value: placement.maxThickness)
                        StatRow("Max length", value: placement.maxLength)
                        StatRow("Shortened by", text: blockedLabel)
                    }
                }

                VStack(alignment: .leading, spacing: 9) {
                    StatRow("Area", text: String(format: "%.0f, %.0f · %.0f × %.0f",
                                                 placement.availableArea.minX,
                                                 placement.availableArea.minY,
                                                 placement.availableArea.width,
                                                 placement.availableArea.height))
                    StatRow("Edge insets", text: insetList(placement.edgeInsets))
                    StatRow("Content padding", text: insetList(placement.safeContentInsets))
                }
            }
        }
    }

    /// Where the bar lands, drawn to scale inside a miniature of the window.
    private var placementDiagram: some View {
        let bounds = placement.layoutBounds
        let bar = placement.area(thickness: placement.recommendedThickness)

        return GeometryReader { geo in
            let scale = min(geo.size.width / max(bounds.width, 1),
                            geo.size.height / max(bounds.height, 1))
            let size = CGSize(width: bounds.width * scale, height: bounds.height * scale)
            let origin = CGPoint(x: (geo.size.width - size.width) / 2,
                                 y: (geo.size.height - size.height) / 2)

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(Bento.well)
                    .frame(width: size.width, height: size.height)
                    .offset(x: origin.x, y: origin.y)

                ForEach(Array(Inspector.activeOcclusionFrames.enumerated()), id: \.offset) { _, frame in
                    miniRect(frame, scale: scale, origin: origin, color: .blue)
                }
                ForEach(Array(Inspector.activeDivisionFrames.enumerated()), id: \.offset) { _, frame in
                    miniRect(frame, scale: scale, origin: origin, color: .orange)
                }

                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(Color.green)
                    .frame(width: max(bar.width * scale, 3), height: max(bar.height * scale, 3))
                    .offset(x: origin.x + bar.minX * scale, y: origin.y + bar.minY * scale)
            }
        }
        .animation(.snappy, value: bounds)
    }

    private func miniRect(_ frame: CGRect, scale: CGFloat, origin: CGPoint, color: Color) -> some View {
        Rectangle()
            .fill(color.opacity(0.7))
            .frame(width: max(frame.width * scale, 2), height: max(frame.height * scale, 2))
            .offset(x: origin.x + frame.minX * scale, y: origin.y + frame.minY * scale)
    }

    private var regionsCard: some View {
        BentoCard(title: "Reserved regions", icon: "square.on.square.dashed", accent: .blue) {
            VStack(alignment: .leading, spacing: 14) {
                if #available(anyAppleOS 27.1, *) {
                    RegionRow(name: "Divisions",
                              total: Inspector.divisions.count,
                              active: Inspector.activeDivisionFrames.count,
                              color: .orange)
                    RegionRow(name: "Occlusions",
                              total: Inspector.occlusions.count,
                              active: Inspector.activeOcclusionFrames.count,
                              color: .blue)
                } else {
                    Text("Needs iOS 27.1")
                        .font(.system(size: 13))
                        .foregroundStyle(Bento.label)
                }
            }
        }
    }

    private var coverageCard: some View {
        BentoCard(title: "Edge coverage", icon: "ruler", accent: .orange) {
            VStack(alignment: .leading, spacing: 14) {
                Metric(String(format: "%.0f", placement.coverage * 100),
                       unit: "%",
                       accent: placement.coverage > 0.99 ? .green : .orange)

                MeterBar(fraction: placement.coverage,
                         colors: placement.coverage > 0.99
                             ? [Color.teal, Color.green]
                             : [Color.orange, Color.yellow],
                         leading: "0",
                         trailing: "100")

                Text(placement.summary)
                    .font(.system(size: 12))
                    .foregroundStyle(Bento.label)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .animation(.snappy, value: placement.coverage)
        }
    }

    // MARK: - Overlays

    @available(anyAppleOS 27.1, *)
    @ViewBuilder
    func deadSpotMapping() -> some View {
        ZStack(alignment: .topLeading) {
            // Division regions (the fold) in green when active
            ForEach(Inspector.divisions) { region in
                Rectangle()
                    .fill(region.isActive ? Color.green.opacity(0.35) : Color.white.opacity(0.05))
                    .sizeToFrame(size: region.frame.size)
                    .position(x: region.frame.midX, y: region.frame.midY)
            }

            ForEach(Inspector.occlusions) { region in
                Rectangle()
                    .fill(region.isActive ? Color.blue.opacity(0.35) : Color.white.opacity(0.05))
                    .sizeToFrame(size: region.frame.size)
                    .position(x: region.frame.midX, y: region.frame.midY)
            }
        }
    }

    /// Where `LayoutInspector` says a custom tab bar fits right now.
    private var tabBarPlacementOverlay: some View {
        let bar = placement
        return RoundedRectangle(cornerRadius: 22, style: .continuous)
            .fill(Bento.card.opacity(0.9))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.9), style: StrokeStyle(lineWidth: 2, dash: [8, 6]))
            )
            .overlay(
                Text("TAB BAR")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1)
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(bar.isRail ? -90 : 0))
            )
            .placeInTabBarArea(bar)
            .allowsHitTesting(false)
    }

    // MARK: - Labels

    private var blockedLabel: String {
        switch (placement.isShortenedByOcclusion, placement.isSplitByFold) {
        case (true, true):   "Occlusion + fold"
        case (true, false):  "Occlusion"
        case (false, true):  "Fold"
        case (false, false): "Nothing"
        }
    }

    private func insetList(_ insets: EdgeInsets) -> String {
        String(format: "%.0f / %.0f / %.0f / %.0f",
               insets.top, insets.leading, insets.bottom, insets.trailing)
    }

    private func sizeClassLabel(_ sizeClass: UserInterfaceSizeClass?) -> String {
        switch sizeClass {
        case .compact: "Compact"
        case .regular: "Regular"
        default: "—"
        }
    }
}

// MARK: - Bento pieces

private enum Bento {
    static let background = Color(red: 0.035, green: 0.035, blue: 0.043)
    static let card = Color(red: 0.105, green: 0.105, blue: 0.122)
    static let well = Color.white.opacity(0.06)
    static let label = Color.white.opacity(0.45)
    static let value = Color.white
}

private struct BentoCard<Content: View>: View {
    let title: String
    let icon: String
    var accent: Color = .white
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(accent)
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Bento.value)
                Spacer(minLength: 0)
            }

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Bento.card)
        }
    }
}

/// A headline number with an optional unit and a colour dot, like the reference dashboard.
private struct Metric: View {
    let value: String
    var unit: String?
    var accent: Color?

    init(_ value: String, unit: String? = nil, accent: Color? = nil) {
        self.value = value
        self.unit = unit
        self.accent = accent
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 7) {
            if let accent {
                Circle()
                    .fill(accent)
                    .frame(width: 9, height: 9)
                    .alignmentGuide(.firstTextBaseline) { $0.height - 1 }
            }
            Text(value)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(Bento.value)
            if let unit {
                Text(unit)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Bento.label)
            }
        }
    }
}

private struct StatRow: View {
    let label: String
    let value: String
    var highlight: Bool = false

    init(_ label: String, text: String, highlight: Bool = false) {
        self.label = label
        self.value = text
        self.highlight = highlight
    }

    init(_ label: String, value: CGFloat, highlight: Bool = false) {
        self.label = label
        self.value = String(format: "%.0f", value)
        self.highlight = highlight
    }

    var body: some View {
        HStack(spacing: 10) {
            Text(label)
                .font(.system(size: 13))
                .foregroundStyle(Bento.label)
                .lineLimit(1)
                .layoutPriority(1)
            Spacer(minLength: 4)
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .monospacedDigit()
                .foregroundStyle(highlight ? Color.green : Bento.value)
                .lineLimit(1)
                .minimumScaleFactor(0.65)
        }
    }
}

/// The safe area drawn the way a browser draws its box model: the window on the outside, the
/// inset on each edge called out where that inset actually is, and the space left over for
/// content measured in the middle.
private struct SafeAreaBox: View {
    let insets: EdgeInsets
    let window: CGSize

    private var content: CGSize {
        CGSize(width: max(0, window.width - insets.leading - insets.trailing),
               height: max(0, window.height - insets.top - insets.bottom))
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(red: 0.27, green: 0.30, blue: 0.46))

            VStack(spacing: 4) {
                edge(insets.top)

                HStack(spacing: 6) {
                    edge(insets.leading)

                    ZStack {
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .fill(Color.black.opacity(0.28))
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.65),
                                          style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
                        Text(String(format: "%.0f × %.0f", content.width, content.height))
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                            .padding(.horizontal, 4)
                    }
                    .frame(height: 46)

                    edge(insets.trailing)
                }

                edge(insets.bottom)
            }
            .padding(10)
        }
        .frame(height: 118)
        .overlay(alignment: .bottomTrailing) {
            Text(String(format: "%.0f × %.0f", window.width, window.height))
                .font(.system(size: 10, weight: .medium))
                .monospacedDigit()
                .foregroundStyle(.white.opacity(0.45))
                .padding(7)
        }
        .animation(.snappy, value: insets.leading)
        .animation(.snappy, value: insets.top)
    }

    /// One inset value, sitting on the edge it belongs to. A zero reads as a dash, the way
    /// devtools shows an edge that contributes nothing.
    private func edge(_ value: CGFloat) -> some View {
        Text(value > 0 ? String(format: "%.0f", value) : "–")
            .font(.system(size: 12, weight: .semibold))
            .monospacedDigit()
            .foregroundStyle(value > 0 ? .white : .white.opacity(0.4))
            .frame(minWidth: 18)
    }
}

private struct RegionRow: View {
    let name: String
    let total: Int
    let active: Int
    let color: Color

    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(active > 0 ? color : Color.white.opacity(0.18))
                .frame(width: 9, height: 9)
            Text(name)
                .font(.system(size: 13))
                .foregroundStyle(Bento.label)
            Spacer(minLength: 4)
            Text("\(active)")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(active > 0 ? color : Bento.value.opacity(0.4))
            Text("of \(total)")
                .font(.system(size: 12))
                .foregroundStyle(Bento.label)
        }
    }
}

private struct MeterBar: View {
    let fraction: Double
    let colors: [Color]
    var leading: String?
    var trailing: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.08))
                    Capsule()
                        .fill(LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * max(0, min(1, fraction)))
                }
            }
            .frame(height: 8)

            if leading != nil || trailing != nil {
                HStack {
                    Text(leading ?? "")
                    Spacer()
                    Text(trailing ?? "")
                }
                .font(.system(size: 11))
                .foregroundStyle(Bento.label)
            }
        }
    }
}

/// Three slots — closed, part-way, flat — filled up to the current posture.
private struct SegmentBar: View {
    let filled: Int
    let total: Int
    let color: Color

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index < filled
                          ? AnyShapeStyle(LinearGradient(colors: [color.opacity(0.7), color],
                                                         startPoint: .leading, endPoint: .trailing))
                          : AnyShapeStyle(Color.white.opacity(0.08)))
                    .frame(height: 7)
            }
        }
        .animation(.snappy, value: filled)
    }
}

private struct Pill: View {
    let text: String
    let icon: String
    var accent: Color = .white

    init(_ text: String, icon: String, accent: Color = .white) {
        self.text = text
        self.icon = icon
        self.accent = accent
    }

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
            Text(text)
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundStyle(accent == .white ? Bento.value.opacity(0.85) : accent)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background {
            Capsule().fill(accent == .white ? Color.white.opacity(0.07) : accent.opacity(0.16))
        }
        .lineLimit(1)
        .minimumScaleFactor(0.8)
    }
}

#Preview {
    DuoTestView()
        .environment(LayoutInspector.shared)
}
