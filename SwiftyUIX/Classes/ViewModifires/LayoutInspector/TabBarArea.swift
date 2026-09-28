//
//  TabBarArea.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 9/23/26.
//

// Extends `LayoutInspector`, which is iOS-only.
#if os(iOS)
import SwiftUI

// MARK: - TabBarArea

/// Where a custom tab bar fits in the current layout.
///
/// Every rect is expressed in the layout-bounds space reported by ``LayoutInspector``:
/// origin `.zero`, size `LayoutInspector.currentLayoutBounds.size`. That is the space of a
/// `GeometryReader` that ignores the safe area, which is what `LayoutInspectionView` reads
/// its geometry from, so an overlay placed with these numbers lines up with the window.
///
/// `leading`/`trailing` are already resolved to left/right for the current layout direction,
/// because the reserved regions are queried with SwiftUI's default `.mirrors` behaviour.
public struct TabBarArea: Equatable, Sendable {

    /// The edge the bar hugs.
    public let edge: Edge

    /// How the items run: `.horizontal` for a bar, `.vertical` for a side rail.
    public let axis: Axis

    /// The largest rect hugging ``edge`` that clears the safe area, every active occlusion
    /// and every active division. Trim it with ``area(thickness:)`` once you know how thick
    /// your bar is.
    public let availableArea: CGRect

    /// Distance from each side of the layout bounds to ``availableArea``, so
    /// `Color.clear.ignoresSafeArea().padding(placement.edgeInsets)` reproduces that rect.
    public let edgeInsets: EdgeInsets

    /// How deep the bar may grow from ``edge`` before it meets a reserved region — the far
    /// side of the safe content when nothing is in the way.
    public let maxThickness: CGFloat

    /// How far the bar may run along ``edge``.
    public let maxLength: CGFloat

    /// Fraction of that edge the bar can span, `0...1`. Below `1` something reserved is in
    /// the way; see ``isShortenedByOcclusion`` and ``isSplitByFold``.
    public let coverage: CGFloat

    /// An active occlusion (camera housing, home indicator) costs part of the edge.
    public let isShortenedByOcclusion: Bool

    /// An active division (the fold) crosses this edge, so the run stops at the crease.
    public let isSplitByFold: Bool

    /// How far the system safe area reaches into ``availableArea``. The bar's background runs
    /// all the way to the screen edge — the way `UITabBar` sits under the home indicator — so
    /// pad its *contents* by this to keep them clear of the indicator.
    public let safeContentInsets: EdgeInsets

    /// The bar sits in the column a foldable reserves beside its camera housing — the strip
    /// the system reports as a side safe-area inset, and the one its own tab rail uses.
    /// `false` means an ordinary bar inside the safe content.
    public let isReservedColumn: Bool

    /// The layout bounds the placement was solved against.
    public let layoutBounds: CGRect

    // MARK: Derived

    /// `true` for a vertical side rail, `false` for a horizontal bar.
    public var isRail: Bool { axis == .vertical }

    public var maxWidth: CGFloat { availableArea.width }
    public var maxHeight: CGFloat { availableArea.height }

    /// Alignment for the `ZStack`/`overlay` that hosts the bar.
    public var alignment: Alignment {
        switch edge {
        case .top: .top
        case .bottom: .bottom
        case .leading: .leading
        case .trailing: .trailing
        }
    }

    /// A sensible size for the bar, since nothing but the window limits a bottom bar.
    ///
    /// A reserved column is as wide as the column the system set aside. A bar takes the
    /// standard 49pt of controls plus the safe area it has to cover — 83pt above a home
    /// indicator, matching `UITabBar` — and never more than ``maxThickness``.
    public var recommendedThickness: CGFloat {
        guard !isReservedColumn else { return maxThickness }
        let controls: CGFloat = 49
        let safeArea = axis == .horizontal
            ? safeContentInsets.top + safeContentInsets.bottom
            : safeContentInsets.leading + safeContentInsets.trailing
        return min(maxThickness, controls + safeArea)
    }

    /// ``availableArea`` trimmed to `thickness`, still hugging ``edge``.
    public func area(thickness: CGFloat) -> CGRect {
        let depth = min(max(thickness, 0), maxThickness)
        switch edge {
        case .top:
            return CGRect(x: availableArea.minX, y: availableArea.minY,
                          width: availableArea.width, height: depth)
        case .bottom:
            return CGRect(x: availableArea.minX, y: availableArea.maxY - depth,
                          width: availableArea.width, height: depth)
        case .leading:
            return CGRect(x: availableArea.minX, y: availableArea.minY,
                          width: depth, height: availableArea.height)
        case .trailing:
            return CGRect(x: availableArea.maxX - depth, y: availableArea.minY,
                          width: depth, height: availableArea.height)
        }
    }

    /// Insets from the layout bounds to ``area(thickness:)``.
    public func edgeInsets(thickness: CGFloat) -> EdgeInsets {
        Self.insets(from: layoutBounds, to: area(thickness: thickness))
    }

    /// Padding to keep scrolling content clear of a bar of `thickness`.
    public func contentInset(thickness: CGFloat) -> (edge: Edge.Set, value: CGFloat) {
        let depth = min(max(thickness, 0), maxThickness)
        switch edge {
        case .top:      return (.top, depth + availableArea.minY - layoutBounds.minY)
        case .bottom:   return (.bottom, depth + layoutBounds.maxY - availableArea.maxY)
        case .leading:  return (.leading, depth + availableArea.minX - layoutBounds.minX)
        case .trailing: return (.trailing, depth + layoutBounds.maxX - availableArea.maxX)
        }
    }

    static func insets(from bounds: CGRect, to rect: CGRect) -> EdgeInsets {
        EdgeInsets(top: rect.minY - bounds.minY,
                   leading: rect.minX - bounds.minX,
                   bottom: bounds.maxY - rect.maxY,
                   trailing: bounds.maxX - rect.maxX)
    }

    static func empty(edge: Edge, bounds: CGRect) -> TabBarArea {
        TabBarArea(edge: edge,
                        axis: (edge == .top || edge == .bottom) ? .horizontal : .vertical,
                        availableArea: .zero,
                        edgeInsets: EdgeInsets(),
                        maxThickness: 0,
                        maxLength: 0,
                        coverage: 0,
                        isShortenedByOcclusion: false,
                        isSplitByFold: false,
                        safeContentInsets: EdgeInsets(),
                        isReservedColumn: false,
                        layoutBounds: bounds)
    }
}

// MARK: - Solver

enum TabBarAreaSolver {

    struct Blocker {
        let rect: CGRect
        let isDivision: Bool
    }

    /// Largest rect hugging `edge` that misses every blocker.
    ///
    /// Blocker edges are the only places the answer can change, so the candidates are the
    /// intervals between them: for each one, grow inward until the first blocker overlapping
    /// it, and keep whichever rect covers the most ground. A handful of regions means a
    /// handful of candidates, so the brute force stays cheap and never approximates.
    static func solve(edge: Edge,
                      bounds: CGRect,
                      content: CGRect,
                      safeArea: EdgeInsets,
                      isReservedColumn: Bool,
                      blockers: [Blocker]) -> TabBarArea {

        guard content.width > 0, content.height > 0 else { return .empty(edge: edge, bounds: bounds) }

        let alongX = (edge == .top || edge == .bottom)
        let clipped: [Blocker] = blockers.compactMap {
            let rect = $0.rect.intersection(content)
            guard !rect.isNull, rect.width > 0, rect.height > 0 else { return nil }
            return Blocker(rect: rect, isDivision: $0.isDivision)
        }

        // Candidate cut lines along the run axis.
        let runMin = alongX ? content.minX : content.minY
        let runMax = alongX ? content.maxX : content.maxY
        var cuts: Set<CGFloat> = [runMin, runMax]
        for blocker in clipped {
            cuts.insert(alongX ? blocker.rect.minX : blocker.rect.minY)
            cuts.insert(alongX ? blocker.rect.maxX : blocker.rect.maxY)
        }
        let sorted = cuts.sorted()

        var best = CGRect.zero
        for (i, start) in sorted.enumerated() {
            for end in sorted[(i + 1)...] where end > start {
                let depth = depthLimit(edge: edge,
                                       content: content,
                                       blockers: clipped,
                                       runStart: start,
                                       runEnd: end,
                                       alongX: alongX)
                guard depth > 0 else { continue }
                let candidate = rect(edge: edge, content: content, start: start, end: end, depth: depth)
                // Ties go to the longer run: a bar that spans the edge beats a stubby one
                // of equal area.
                let better = candidate.width * candidate.height > best.width * best.height
                let sameArea = candidate.width * candidate.height == best.width * best.height
                let longer = (alongX ? candidate.width > best.width : candidate.height > best.height)
                if better || (sameArea && longer) { best = candidate }
            }
        }
        guard best.width > 0, best.height > 0 else { return .empty(edge: edge, bounds: bounds) }

        let maxLength = alongX ? best.width : best.height
        let maxThickness = alongX ? best.height : best.width
        let contentLength = alongX ? content.width : content.height

        // Anything reaching the full-length strip at this depth is what cost us the rest of
        // the edge — `best` itself is clear by construction.
        let fullStrip = rect(edge: edge, content: content, start: runMin, end: runMax, depth: maxThickness)
        let intersecting = clipped.filter { $0.rect.intersects(fullStrip) }

        return TabBarArea(
            edge: edge,
            axis: alongX ? .horizontal : .vertical,
            availableArea: best,
            edgeInsets: TabBarArea.insets(from: bounds, to: best),
            maxThickness: maxThickness,
            maxLength: maxLength,
            coverage: contentLength > 0 ? maxLength / contentLength : 0,
            isShortenedByOcclusion: intersecting.contains { !$0.isDivision },
            isSplitByFold: intersecting.contains { $0.isDivision },
            safeContentInsets: safeContentInsets(for: best,
                                                 edge: edge,
                                                 bounds: bounds,
                                                 safeArea: safeArea,
                                                 isReservedColumn: isReservedColumn),
            isReservedColumn: isReservedColumn,
            layoutBounds: bounds
        )
    }

    /// The part of `rect` the safe area covers.
    ///
    /// A reserved column lives inside its own side inset by design, so that edge is not
    /// counted — otherwise an 84pt column would report 84pt of padding and leave nothing.
    private static func safeContentInsets(for rect: CGRect,
                                          edge: Edge,
                                          bounds: CGRect,
                                          safeArea: EdgeInsets,
                                          isReservedColumn: Bool) -> EdgeInsets {
        var insets = EdgeInsets(
            top: max(0, (bounds.minY + safeArea.top) - rect.minY),
            leading: max(0, (bounds.minX + safeArea.leading) - rect.minX),
            bottom: max(0, rect.maxY - (bounds.maxY - safeArea.bottom)),
            trailing: max(0, rect.maxX - (bounds.maxX - safeArea.trailing))
        )
        if isReservedColumn {
            switch edge {
            case .leading: insets.leading = 0
            case .trailing: insets.trailing = 0
            case .top, .bottom: break
            }
        }
        return insets
    }

    /// How far a run of `runStart...runEnd` can grow inward from `edge`.
    private static func depthLimit(edge: Edge,
                                   content: CGRect,
                                   blockers: [Blocker],
                                   runStart: CGFloat,
                                   runEnd: CGFloat,
                                   alongX: Bool) -> CGFloat {

        var depth = alongX ? content.height : content.width

        for blocker in blockers {
            let rect = blocker.rect
            let overlaps = alongX
                ? (rect.maxX > runStart && rect.minX < runEnd)
                : (rect.maxY > runStart && rect.minY < runEnd)
            guard overlaps else { continue }

            let allowed: CGFloat = switch edge {
            case .top:      rect.minY - content.minY
            case .bottom:   content.maxY - rect.maxY
            case .leading:  rect.minX - content.minX
            case .trailing: content.maxX - rect.maxX
            }
            depth = min(depth, max(0, allowed))
        }
        return depth
    }

    private static func rect(edge: Edge,
                             content: CGRect,
                             start: CGFloat,
                             end: CGFloat,
                             depth: CGFloat) -> CGRect {
        switch edge {
        case .top:
            return CGRect(x: start, y: content.minY, width: end - start, height: depth)
        case .bottom:
            return CGRect(x: start, y: content.maxY - depth, width: end - start, height: depth)
        case .leading:
            return CGRect(x: content.minX, y: start, width: depth, height: end - start)
        case .trailing:
            return CGRect(x: content.maxX - depth, y: start, width: depth, height: end - start)
        }
    }
}

// MARK: - LayoutInspector

@MainActor
public extension LayoutInspector {

    /// The edge a tab bar belongs on.
    ///
    /// A foldable reserves a column beside its camera housing and reports it as a side
    /// safe-area inset — that strip is where the system renders its own tab rail, so a custom
    /// bar belongs there too, not squeezed in next to it. A panel with no such column, and
    /// every non-foldable device in either orientation, gets a bar along the bottom.
    var preferredTabBarEdge: Edge {
        guard isFoldable else { return .bottom }
        let leading = safeAreaInsets.leading
        let trailing = safeAreaInsets.trailing
        guard max(leading, trailing) > 0 else { return .bottom }
        return trailing >= leading ? .trailing : .leading
    }

    /// Recommended placement. Falls back to another edge only when the preferred one leaves no
    /// room at all — a crease or a camera housing eating into it is expected, and reported
    /// through ``TabBarArea/coverage`` rather than silently moving the bar somewhere else.
    var tabBarArea: TabBarArea {
        let preferred = tabBarArea(on: preferredTabBarEdge)
        guard preferred.maxLength <= 0 || preferred.maxThickness <= 0 else { return preferred }

        let alternatives = [Edge.bottom, .trailing, .leading]
            .filter { $0 != preferred.edge }
            .map { tabBarArea(on: $0) }

        return ([preferred] + alternatives).max { $0.coverage < $1.coverage } ?? preferred
    }

    /// Placement on a specific edge, for when the design already dictates one.
    ///
    /// Asking for a side edge that has a reserved column gets the column; asking for one that
    /// does not gets a rail hugging that edge inside the safe content.
    func tabBarArea(on edge: Edge) -> TabBarArea {
        let bounds = CGRect(origin: .zero, size: currentLayoutBounds.size)
        guard bounds.width > 0, bounds.height > 0 else {
            return .empty(edge: edge, bounds: bounds)
        }

        let blockers = activeOcclusionFrames.map { TabBarAreaSolver.Blocker(rect: $0, isDivision: false) }
            + activeDivisionFrames.map { TabBarAreaSolver.Blocker(rect: $0, isDivision: true) }

        let column = reservedColumn(on: edge, in: bounds)
        return TabBarAreaSolver.solve(edge: edge,
                                      bounds: bounds,
                                      content: column ?? safeContent(in: bounds),
                                      safeArea: safeAreaInsets,
                                      isReservedColumn: column != nil,
                                      blockers: blockers)
    }

    /// The strip a foldable reserves on this edge, or `nil` when it reserves none.
    ///
    /// It spans the side inset's full width and runs the height of the window between the top
    /// and bottom insets — the housing and any other reserved region inside it are avoided by
    /// the solver, not by shrinking the column up front.
    private func reservedColumn(on edge: Edge, in bounds: CGRect) -> CGRect? {
        guard isFoldable else { return nil }

        let width: CGFloat = switch edge {
        case .leading: safeAreaInsets.leading
        case .trailing: safeAreaInsets.trailing
        case .top, .bottom: 0
        }
        guard width > 0 else { return nil }

        let top = bounds.minY + safeAreaInsets.top
        let height = bounds.maxY - top
        guard height > 0 else { return nil }

        return CGRect(x: edge == .leading ? bounds.minX : bounds.maxX - width,
                      y: top,
                      width: width,
                      height: height)
    }

    /// The window inset by the safe area, except at the bottom: a tab bar's background belongs
    /// under the home indicator, so that strip stays part of the band and comes back as
    /// ``TabBarArea/safeContentInsets`` for padding the bar's contents.
    private func safeContent(in bounds: CGRect) -> CGRect {
        let top = bounds.minY + safeAreaInsets.top
        return CGRect(x: bounds.minX + safeAreaInsets.leading,
                      y: top,
                      width: bounds.width - safeAreaInsets.leading - safeAreaInsets.trailing,
                      height: bounds.maxY - top)
    }
}

// MARK: - Placing a view

public extension View {

    /// Sizes and positions the view in `placement`, in the coordinate space
    /// ``TabBarArea`` documents.
    ///
    /// Apply it to an overlay on a root view that ignores the safe area:
    ///
    ///     .overlay { MyTabBar().placeInTabBarArea(inspector.tabBarArea, thickness: 64) }
    ///
    /// Passing no `thickness` uses ``TabBarArea/recommendedThickness``.
    func placeInTabBarArea(_ area: TabBarArea, thickness: CGFloat? = nil) -> some View {
        let rect = area.area(thickness: thickness ?? area.recommendedThickness)
        return self
            .frame(width: rect.width, height: rect.height)
            .position(x: rect.midX, y: rect.midY)
            .ignoresSafeArea()
    }
}

// MARK: - Display labels

public extension TabBarArea {
    /// One-line summary for debug panels.
    var summary: String {
        let kind = isReservedColumn ? "column rail" : (isRail ? "rail" : "bar")
        return String(format: "%@ %@ · %.0f × %.0f · %.0f%% of edge",
                      edgeLabel, kind, availableArea.width, availableArea.height, coverage * 100)
    }

    var edgeLabel: String {
        switch edge {
        case .top: "Top"
        case .bottom: "Bottom"
        case .leading: "Leading"
        case .trailing: "Trailing"
        }
    }

    var axisLabel: String { axis == .horizontal ? "Horizontal" : "Vertical" }
}
#endif
