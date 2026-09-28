//
//  BookReaderExample.swift
//  swiftyUIXExamples
//
//  Created by John kim on 9/24/26.
//

import SwiftUI
import SwiftyUIX

/// A reader that behaves like a physical book.
///
/// Compact width shows one page. Regular width opens into a two-page spread — and when the
/// device reports an active division, the gutter is laid out around the real crease instead of
/// the middle of the window, so no line of type ever falls into the fold.
struct BookReaderExample: View {

    @Environment(LayoutInspector.self) private var inspector
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var leaf = 0
    @State private var showsChrome = true

    /// Two pages once there is room for them.
    private var isSpread: Bool { horizontalSizeClass == .regular }

    /// The crease, when the system says one is cutting through the window.
    private var crease: CGRect? { inspector.activeDivisionFrames.first }

    private var pagesPerLeaf: Int { isSpread ? 2 : 1 }
    private var lastLeaf: Int { max(0, (Book.pages.count - 1) / pagesPerLeaf) }

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                desk

                if isSpread {
                    spread(in: geo.size)
                } else {
                    page(at: leaf, side: .single)
                        .padding(.horizontal, 18)
                        .padding(.leading, inspector.safeAreaInsets.leading)
                        .padding(.trailing, inspector.safeAreaInsets.trailing)
                        .padding(.top, inspector.safeAreaInsets.top + 12)
                        .padding(.bottom, inspector.safeAreaInsets.bottom + 12)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .contentShape(.rect)
        .onTapGesture {
            withAnimation(.snappy) { showsChrome.toggle() }
        }
        .gesture(
            DragGesture(minimumDistance: 24)
                .onEnded { value in
                    if value.translation.width < 0 { turn(1) } else if value.translation.width > 0 { turn(-1) }
                }
        )
        .overlay(alignment: .top) { banner }
        .overlay { controls }
        .navigationTitle("Book")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        #endif
        .animation(.snappy(duration: 0.28), value: leaf)
        .animation(.snappy, value: isSpread)
    }

    // MARK: - Surfaces

    private var desk: some View {
        LinearGradient(colors: [Color(red: 0.13, green: 0.10, blue: 0.09),
                                Color(red: 0.07, green: 0.06, blue: 0.06)],
                       startPoint: .top, endPoint: .bottom)
            .overlay {
                RadialGradient(colors: [.white.opacity(0.06), .clear],
                               center: .center, startRadius: 40, endRadius: 520)
            }
    }

    /// Left and right pages laid out around the crease — or around the middle when there is none.
    private func spread(in size: CGSize) -> some View {
        let defaultGutter: CGFloat = 26
        let gapStart = crease?.minX ?? (size.width - defaultGutter) / 2
        let gapEnd = crease?.maxX ?? (size.width + defaultGutter) / 2

        return HStack(spacing: 0) {
            page(at: leaf * 2, side: .left)
                .frame(width: max(gapStart, 0))
                .padding(.leading, inspector.safeAreaInsets.leading + 18)
                .padding(.vertical, 18)
                .padding(.top, inspector.safeAreaInsets.top)
                .padding(.bottom, inspector.safeAreaInsets.bottom)

            gutter
                .frame(width: max(gapEnd - gapStart, 0))

            page(at: leaf * 2 + 1, side: .right)
                .frame(width: max(size.width - gapEnd, 0))
                .padding(.trailing, inspector.safeAreaInsets.trailing + 18)
                .padding(.vertical, 18)
                .padding(.top, inspector.safeAreaInsets.top)
                .padding(.bottom, inspector.safeAreaInsets.bottom)
        }
    }

    /// The fold itself: dark where the paper dips into the crease.
    private var gutter: some View {
        LinearGradient(colors: [.black.opacity(0.0), .black.opacity(0.55), .black.opacity(0.0)],
                       startPoint: .leading, endPoint: .trailing)
            .overlay {
                Rectangle()
                    .fill(.white.opacity(crease == nil ? 0.05 : 0.12))
                    .frame(width: 1)
            }
    }

    // MARK: - A page

    private enum PageSide { case left, right, single }

    @ViewBuilder
    private func page(at index: Int, side: PageSide) -> some View {
        let content = Book.pages.indices.contains(index) ? Book.pages[index] : nil

        ZStack {
            paper(side: side)

            if let content {
                VStack(alignment: .leading, spacing: 0) {
                    Text((content.chapter ?? Book.title).uppercased())
                        .font(.system(size: 10, weight: .semibold, design: .serif))
                        .tracking(2)
                        .foregroundStyle(Book.ink.opacity(0.45))
                        .frame(maxWidth: .infinity, alignment: side == .right ? .trailing : .leading)
                        .padding(.bottom, 18)

                    if let chapter = content.chapter {
                        Text(chapter)
                            .font(.system(size: 26, weight: .bold, design: .serif))
                            .foregroundStyle(Book.ink)
                            .padding(.bottom, 14)
                    }

                    ForEach(Array(content.paragraphs.enumerated()), id: \.offset) { offset, text in
                        if offset == 0, content.chapter != nil {
                            dropCapParagraph(text)
                        } else {
                            Text(text)
                                .font(.system(size: 15, design: .serif))
                                .foregroundStyle(Book.ink.opacity(0.88))
                                .lineSpacing(7)
                                .padding(.bottom, 12)
                        }
                    }

                    Spacer(minLength: 0)

                    Text("\(index + 1)")
                        .font(.system(size: 12, weight: .medium, design: .serif))
                        .foregroundStyle(Book.ink.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.horizontal, 26)
                .padding(.vertical, 28)
                .id(index)
                .transition(.opacity.combined(with: .move(edge: .trailing)))
            }
        }
        .clipShape(pageShape(side: side))
        .shadow(color: .black.opacity(0.45), radius: 18, x: 0, y: 10)
    }

    /// An oversized first letter, with the rest of the opening line flowing beside it.
    private func dropCapParagraph(_ text: String) -> some View {
        let first = String(text.prefix(1))
        let rest = String(text.dropFirst())

        return HStack(alignment: .top, spacing: 4) {
            Text(first)
                .font(.system(size: 52, weight: .bold, design: .serif))
                .foregroundStyle(Book.accent)
                .padding(.top, -8)

            Text(rest)
                .font(.system(size: 15, design: .serif))
                .foregroundStyle(Book.ink.opacity(0.88))
                .lineSpacing(7)
        }
        .padding(.bottom, 12)
    }

    private func paper(side: PageSide) -> some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.98, green: 0.96, blue: 0.91),
                                    Color(red: 0.94, green: 0.91, blue: 0.84)],
                           startPoint: .top, endPoint: .bottom)

            // The page darkens as it curves towards the spine.
            if side != .single {
                LinearGradient(colors: [.black.opacity(0.16), .clear],
                               startPoint: side == .left ? .trailing : .leading,
                               endPoint: side == .left ? .center : .center)
            }
        }
    }

    /// Square corners where the paper meets the spine, rounded on the outer edges.
    private func pageShape(side: PageSide) -> UnevenRoundedRectangle {
        let outer: CGFloat = 14
        let inner: CGFloat = 2
        switch side {
        case .single:
            return UnevenRoundedRectangle(topLeadingRadius: outer, bottomLeadingRadius: outer,
                                          bottomTrailingRadius: outer, topTrailingRadius: outer,
                                          style: .continuous)
        case .left:
            return UnevenRoundedRectangle(topLeadingRadius: outer, bottomLeadingRadius: outer,
                                          bottomTrailingRadius: inner, topTrailingRadius: inner,
                                          style: .continuous)
        case .right:
            return UnevenRoundedRectangle(topLeadingRadius: inner, bottomLeadingRadius: inner,
                                          bottomTrailingRadius: outer, topTrailingRadius: outer,
                                          style: .continuous)
        }
    }

    // MARK: - Chrome

    /// Says which layout is in play and why, so the fold handling is visible.
    private var banner: some View {
        HStack(spacing: 6) {
            Image(systemName: isSpread ? "book.pages" : "doc.plaintext")
            Text(isSpread
                 ? (crease == nil ? "Two-page spread" : "Spread · gutter on the crease")
                 : "Single page")
        }
        .font(.caption2.weight(.semibold))
        .foregroundStyle(.white.opacity(0.9))
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(Capsule().fill(.black.opacity(0.45)))
        .padding(.top, inspector.safeAreaInsets.top + 8)
        .opacity(showsChrome ? 1 : 0)
    }

    /// Reader controls, parked in whatever space `LayoutInspector` reserves for a tab bar —
    /// a bottom bar on most windows, a rail in the camera column on a closed foldable.
    private var controls: some View {
        let bar = inspector.tabBarArea

        return Group {
            if bar.isRail {
                VStack(spacing: 18) {
                    turnButton(-1, icon: "chevron.up")
                    progress
                    turnButton(1, icon: "chevron.down")
                }
            } else {
                HStack(spacing: 22) {
                    turnButton(-1, icon: "chevron.left")
                    progress
                    turnButton(1, icon: "chevron.right")
                }
            }
        }
        .padding(bar.safeContentInsets)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.45))
        .clipShape(Capsule())
        .placeInTabBarArea(bar)
        .opacity(showsChrome ? 1 : 0)
    }

    private func turnButton(_ direction: Int, icon: String) -> some View {
        Button {
            turn(direction)
        } label: {
            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(.white)
                .padding(10)
        }
        .disabled(direction < 0 ? leaf == 0 : leaf >= lastLeaf)
        .opacity((direction < 0 ? leaf == 0 : leaf >= lastLeaf) ? 0.3 : 1)
    }

    private var progress: some View {
        Text("\(leaf + 1) / \(lastLeaf + 1)")
            .font(.caption.weight(.bold))
            .monospacedDigit()
            .foregroundStyle(.white.opacity(0.75))
    }

    private func turn(_ direction: Int) {
        leaf = max(0, min(lastLeaf, leaf + direction))
    }
}

// MARK: - The book

private enum Book {
    static let title = "The Cartographer of Small Rooms"
    static let ink = Color(red: 0.16, green: 0.13, blue: 0.10)
    static let accent = Color(red: 0.55, green: 0.24, blue: 0.13)

    struct Page {
        var chapter: String?
        var paragraphs: [String]
    }

    static let pages: [Page] = [
        Page(chapter: "I · The Fold", paragraphs: [
            "Mira measured rooms for a living, which is a stranger profession than it sounds. Anyone can hold a tape against a wall. Her work began after that, in the part nobody wrote down: where the light landed at four in the afternoon, which floorboard announced you, how far a person could stand from the window before the street stopped being interesting.",
            "The commission came by letter, on paper folded so many times the creases had gone soft as cloth. A house on the coast. Seven rooms. No photographs enclosed, and no explanation for why a house that small required a cartographer at all."
        ]),
        Page(paragraphs: [
            "She took the early train and watched the country flatten into salt marsh. Somewhere past the third station the fields gave up entirely and let the sky have everything.",
            "The house, when she found it, was not seven rooms. It was one room that had been folded, over and over, until it pretended to be seven. Walls met at angles no builder would choose. A door opened onto the same hallway it had left.",
            "Mira set down her bag and laughed, once, with the particular delight of a person handed a genuinely difficult problem."
        ]),
        Page(chapter: "II · Measurements", paragraphs: [
            "Her method was simple and slow. She walked each room in a spiral, from the doorway inward, counting paces and noting where the count betrayed her — where eleven steps out became nine steps back.",
            "By the second afternoon she had filled forty pages and understood nothing. By the fourth she had stopped trying to understand and simply drew what the house insisted was true."
        ]),
        Page(paragraphs: [
            "The drawings were beautiful and impossible. Corridors that met themselves. A staircase whose landing was also its first step. She pinned them to the wall of the largest room and stood back, and for a moment — for exactly as long as she did not look directly at them — they made perfect sense.",
            "That was the trick of the place, she decided. It was not built to be seen head-on. It was built to be seen the way you see a thing at the edge of your vision, whole and unexamined."
        ]),
        Page(chapter: "III · The Hinge", paragraphs: [
            "On the sixth day she found the hinge. Not a door hinge — the hinge, a seam running floor to ceiling in the back bedroom, so fine she had walked past it eleven times.",
            "She pressed it. The house opened."
        ]),
        Page(paragraphs: [
            "Not violently, and not all at once. It opened the way a book opens: two halves swinging apart around a spine, each half complete, each half meaningless alone. The seven false rooms resolved into two true ones, facing each other across a fold of ordinary afternoon light.",
            "Mira stood in the crease and understood the commission at last. Nobody had asked her to map a house. They had asked her to find out where it bent."
        ]),
        Page(chapter: "IV · What She Wrote", paragraphs: [
            "Her report ran to a single page, which the client found insulting until they read it.",
            "A room is not its walls, she wrote. A room is the argument between two walls, and the fold is where the argument is settled. Draw the fold and the walls will place themselves."
        ]),
        Page(paragraphs: [
            "She was paid in full and never called back, which is the highest compliment the profession offers.",
            "Years later, students would ask what the house had been for. Mira would shrug and say it had been a house for two people who needed to look at each other, and could not manage it in a straight line.",
            "Then she would hand them a tape measure and send them out to count paces until the count betrayed them."
        ])
    ]
}

#Preview {
    BookReaderExample()
        .environment(LayoutInspector.shared)
}
