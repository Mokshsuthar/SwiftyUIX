![Static Badge](https://img.shields.io/badge/iOS-17.0%2B-red)
![Static Badge](https://img.shields.io/badge/macOS-12.0%2B-red)
![Static Badge](https://img.shields.io/badge/swift_package_manager-compatible-green)
![Static Badge](https://img.shields.io/badge/swift_version-5.9%2B-blue)
![Static Badge](https://img.shields.io/badge/License-MIT-yellow)

# SwiftyUIX

SwiftyUIX is a SwiftUI/UIKit/AppKit utility library for iOS and macOS: extensions on the types you already use, drop-in views, and a foldable-aware layout system for placing your own UI around whatever the system reserves — a camera housing, a fold, the home indicator.

This document covers every public API the library ships, grouped by what you're trying to do, with a runnable example for each. Jump to a section with the table of contents below, or read top to bottom.

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
  - [Swift Package Manager](#swift-package-manager)
  - [CocoaPods](#cocoapods)
- [Foldable & Adaptive Layout](#foldable--adaptive-layout)
  - [Setup](#setup)
  - [Reading the layout](#reading-the-layout)
  - [Placing a tab bar](#placing-a-tab-bar)
- [Layout & Frame Helpers](#layout--frame-helpers)
  - [Filling available space](#filling-available-space)
  - [Screen dimensions & safe area (legacy)](#screen-dimensions--safe-area-legacy)
  - [Corners & borders](#corners--borders)
  - [Masking](#masking)
  - [Scroll position](#scroll-position)
  - [System images & buttons](#system-images--buttons)
- [Glass & Blur Effects](#glass--blur-effects)
  - [Liquid Glass, with a fallback](#liquid-glass-with-a-fallback)
  - [Blur views](#blur-views)
  - [Variable blur](#variable-blur)
  - [Transparent sheet background](#transparent-sheet-background)
- [Alerts, Share Sheets & Drops](#alerts-share-sheets--drops)
- [Haptics](#haptics)
- [Keyboard Handling](#keyboard-handling)
- [Force-Update Prompt](#force-update-prompt)
- [App & Bundle Info](#app--bundle-info)
- [Logging](#logging)
- [Color Utilities](#color-utilities)
- [Date Utilities](#date-utilities)
- [Data & Number Formatting](#data--number-formatting)
- [Threading Helpers](#threading-helpers)
- [Notifications](#notifications)
- [Photos (PHAsset)](#photos-phasset)
- [Device, Screen & App Store Helpers](#device-screen--app-store-helpers)
- [Embedding SwiftUI in UIKit](#embedding-swiftui-in-uikit)
- [macOS Window Chrome](#macos-window-chrome)
- [Optional Firebase Analytics Bridge](#optional-firebase-analytics-bridge)
- [Platform & Availability Matrix](#platform--availability-matrix)
- [Example App](#example-app)
- [License](#license)

## Requirements

| | |
|---|---|
| iOS | 17.0+ |
| macOS | 12.0+ |
| Swift | 5.9+ |
| Xcode | 15+ |

The foldable layout system (`LayoutInspector`, `TabBarArea`) is **iOS-only** — the hinge and reserved-region APIs it builds on don't exist in the macOS SDK. Everything else in this document works on both platforms unless a section says otherwise.

## Installation

### Swift Package Manager

In Xcode: **File → Add Package Dependencies…** and enter:

```
https://github.com/Mokshsuthar/SwiftyUIX.git
```

Or add it to `Package.swift` directly:

```swift
dependencies: [
    .package(url: "https://github.com/Mokshsuthar/SwiftyUIX.git", from: "2.0.0")
]
```

### CocoaPods

Add to your `Podfile`:

```ruby
pod 'SwiftyUIX', '~> 2.0'
```

Then:

```sh
pod install
```

Every example below assumes `import SwiftyUIX`.

## Foldable & Adaptive Layout

The flagship feature of 2.0. `LayoutInspector` tracks the live layout — window bounds, safe area, orientation, device type and, on a foldable, the hinge angle, fold posture and the regions the system reserves (a camera housing, the fold itself). `TabBarArea` turns that state into a concrete rect: where a custom tab bar or side rail belongs right now, solved around whatever is in the way.

### Setup

Install `LayoutInspectionView` once, at the root of your app. It reads the geometry, observes the hinge, and writes into `LayoutInspector.shared` — nothing else is needed.

```swift
import SwiftUI
import SwiftyUIX

@main
struct MyApp: App {
    @State private var inspector = LayoutInspector.shared

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environment(inspector)
                LayoutInspectionView()
            }
        }
    }
}
```

`LayoutInspector` is `@Observable`, so any view reading `inspector.orientation` (or any other property) redraws automatically when it changes — no `@Published`, no manual notifications.

### Reading the layout

```swift
struct ContentView: View {
    @Environment(LayoutInspector.self) private var inspector

    var body: some View {
        VStack {
            Text("Window: \(inspector.currentLayoutBounds.width) × \(inspector.currentLayoutBounds.height)")
            Text("Orientation: \(inspector.orientation.label)")     // "Portrait" / "Landscape"
            Text("Device: \(inspector.deviceType.label)")           // "iPhone", "iPad", "iPhone (foldable)"...

            if inspector.isIPhoneDuo {
                Text("Fold: \(inspector.foldPosture?.label ?? "—")") // "Closed (outer display)" etc.
                if let angle = inspector.hingeAngle {
                    Text("Hinge angle: \(angle.degrees, specifier: "%.0f")°")
                }
                if inspector.hasActiveDivision {
                    Text("The crease is currently splitting the window")
                }
            }
        }
    }
}
```

Full property list:

| Property | Type | Notes |
|---|---|---|
| `currentLayoutBounds` | `CGRect` | The window, ignoring the safe area |
| `safeAreaInsets` | `EdgeInsets` | Also exposed individually as `topSafeArea`, `bottomSafeArea`, `leadingSafeArea`, `trailingSafeArea` |
| `orientation` | `LayoutOrientation` | `.portrait` / `.landscape`, derived from the bounds — correct in Split View, Slide Over and Stage Manager, unlike `UIDevice.orientation` |
| `isLandscape` / `isPortrait` | `Bool` | Convenience over `orientation` |
| `deviceType` | `DeviceType` | `.phone`, `.foldablePhone`, `.pad`, `.mac`, `.tv`, `.carPlay`, `.vision`, `.unknown` |
| `isPhone` / `isIPad` | `Bool` | Convenience over `deviceType` |
| `isFoldable` / `isIPhoneDuo` | `Bool` | `true` once the system has reported a hinge |
| `foldPosture` | `FoldPosture?` | `.closed`, `.partiallyOpen`, `.fullyOpen`; `nil` on devices without a hinge |
| `isFolded` / `isPartiallyFolded` | `Bool` | Convenience over `foldPosture` |
| `hingeAngle` | `Angle?` | `nil` on devices without a hinge |
| `hasActiveDivision` | `Bool` | The fold is currently splitting the window into two panels |
| `deviceOrientation` | `UIDeviceOrientation` | Raw sensor orientation (includes face up/down) — iOS only |
| `divisions` / `occlusions` | `[ReservedRegion]` | Raw system data, iOS 27.1+ only (`@available`-gated) |
| `activeDivisionFrames` / `activeOcclusionFrames` | `[CGRect]` | The active regions above, flattened to plain rects with no availability gate — what `TabBarArea` solves around |

To attach the hinge observer to a specific view instead of the shared singleton:

```swift
MyRootView()
    .trackDeviceHinge(myInspector)
```

### Placing a tab bar

`inspector.tabBarArea` answers "where does my custom tab bar go right now?" — a bottom bar on ordinary devices, or a rail inside the camera column when a foldable reserves one — solved around every active occlusion and division so it never overlaps something the system is protecting.

```swift
struct RootView: View {
    @Environment(LayoutInspector.self) private var inspector

    var body: some View {
        ContentView()
            .overlay {
                MyTabBar()
                    .placeInTabBarArea(inspector.tabBarArea)
            }
    }
}
```

`placeInTabBarArea(_:thickness:)` sizes and positions the view for you; pass your own `thickness` or omit it to use `recommendedThickness` (49pt of controls plus whatever safe area the bar has to cover — 83pt over a home indicator, matching `UITabBar`).

Everything `TabBarArea` exposes:

```swift
let bar = inspector.tabBarArea

bar.edge                 // .bottom, .leading or .trailing
bar.axis                 // .horizontal for a bar, .vertical for a rail
bar.isRail                // axis == .vertical
bar.alignment             // matching Alignment, for a ZStack/overlay
bar.availableArea         // CGRect of free space, in full-bleed window coordinates
bar.edgeInsets            // insets from the window to that rect
bar.recommendedThickness  // 49pt of controls plus the safe area it covers, or the column width
bar.maxThickness          // ceiling before the bar would hit a reserved region
bar.maxLength             // how far it can run along the edge
bar.coverage              // 0...1 — how much of the edge survived
bar.isReservedColumn      // true when the bar is in a foldable's camera column
bar.isShortenedByOcclusion
bar.isSplitByFold
bar.safeContentInsets     // how far the safe area reaches into the band (pad your content by this)
bar.summary               // "Trailing column rail · 84 × 515 · 81% of edge"
```

The band runs to the screen edge rather than stopping at the home indicator — the way `UITabBar` does — so its background fills the corner. Pad the bar's *contents*, not its background, by `safeContentInsets`:

```swift
MyTabBar()
    .padding(bar.safeContentInsets)
    .background(.bar)
    .placeInTabBarArea(bar)
```

Trim to a size you already know, or compute a content inset for whatever is scrolling behind the bar:

```swift
let rect = bar.area(thickness: 64)                 // the band, hugging its edge
let inset = bar.contentInset(thickness: 64)        // padding to keep content clear of it

MyScrollingContent()
    .safeAreaPadding(inset.edge, inset.value)
```

Pin a specific edge when the design already dictates one — the geometry is still solved around whatever's reserved there:

```swift
let rail = inspector.tabBarArea(on: .leading)
```

## Layout & Frame Helpers

### Filling available space

```swift
Text("Hi")
    .fullFrame()                       // fills the parent, both axes
    .fullFrame(alignment: .topLeading)

Text("Hi").fullWidth()                 // full width, natural height
Text("Hi").fullWidth(height: 44)       // full width, fixed height

Text("Hi").fullHeight()                // full height, natural width
Text("Hi").fullHeight(width: 200)      // full height, fixed width

Text("Hi").squareFrame(size: 44)       // equal width and height

myView.sizeToFrame(size: someSize)     // frame(width:height:) from a CGSize

Text("Hi").horizontalPadding(16)       // .padding(.horizontal, 16)
Text("Hi").verticalPadding(8)          // .padding(.vertical, 8)
```

### Screen dimensions & safe area (legacy)

Kept for existing call sites; `LayoutInspector` above is the recommended way to read layout going forward, since it's correct under Split View, Slide Over and Stage Manager. These read straight from `UIScreen`/`UIDevice` (iOS only):

```swift
myView.screenWidth       // UIScreen.main.bounds.width
myView.screenHeight
myView.isSmallScreen     // true when the screen is under 815pt tall

myView.topSafeAreaHeight            // via LayoutInspector.shared under the hood
myView.topSafeAreaHeight(ifZero: 16, plus: 4)
myView.bottomSafeAreaHeight(ifZero: 16, plus: 4)

myView.safeArea(of: .leading, ifZero: 0, plus: 0)

Spacer().topSafeArea()                          // a spacer sized to the top inset
Spacer().bottomSafeArea(plus: 30, ifZero: 16)   // ...with extra room, and a floor when the inset is 0

myView.screenCornerRadius(minimum: 20)  // the device's real display corner radius, or `minimum`
```

`hideHomeIndicator` hides the home indicator entirely while the view is visible:

```swift
MyView().hideHomeIndicator(visibility: .hidden)
```

### Corners & borders

```swift
myView.cornerRadius(12)                              // continuous corner radius (all corners)
myView.cornerRadius(12, corners: [.topLeft, .topRight]) // iOS: specific corners via UIRectCorner

myView.border(lineWidth: 2, cornerRadius: 10, color: .blue)
```

On macOS, rounding specific corners uses its own `RectCorner` option set (there's no `UIRectCorner`):

```swift
#if os(macOS)
myView.roundedCorners(radius: 12, corners: [.topLeft, .topRight])
#endif
```

### Masking

```swift
myView.reverseMask {
    Circle()   // punches this shape *out* of myView
}
```

### Scroll position

`getScrollPosition(key:handler:)` reports how far a view has scrolled inside a named coordinate space — pair it with a matching `.coordinateSpace(name:)` on the scroll view itself. Combined with [`LayoutInspector`](#foldable--adaptive-layout), the offset can drive a live readout parked wherever `tabBarArea` says a bar belongs:

```swift
struct ScrollOffsetExample: View {
    @Environment(LayoutInspector.self) private var inspector
    @State private var scrollOffsetY: CGFloat = .zero

    private var offsetReadout: some View {
        let bar = inspector.tabBarArea
        return Text("Scroll offset Y: \(String(format: "%.2f", scrollOffsetY))")
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(.white)
            .rotationEffect(.degrees(bar.isRail ? -90 : 0))
            .placeInTabBarArea(bar)
            .allowsHitTesting(false)
    }

    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    ForEach(0...100, id: \.self) { index in
                        Text("\(index)")
                            .fullFrame()
                            .fullWidth(height: 60)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding()
                .getScrollPosition(key: "ScrollKey") { scrollOffsetY = $0 }
            }
            .coordinateSpace(name: "ScrollKey")   // must match the key above
            .safeAreaPadding(inspector.horizontalSafeAreaInsets.edge, inspector.horizontalSafeAreaInsets.value)
            .safeAreaPadding(.top, inspector.topSafeArea)
            .safeAreaPadding(.bottom, inspector.bottomSafeArea)
            .fullFrame()

            offsetReadout
        }
        .ignoresSafeArea()
    }
}
```

### System images & buttons

`systemImage` is a `View` extension, so call it with `self` inside a view's body — it hands back a pre-configured, resizable `Image(systemName:)`, ignoring whatever view it was called on:

```swift
var body: some View {
    self.systemImage("star.fill")
}

Image("photo").squareFrameWithAspectRatio(value: 100, contentMode: .fill)
Image("photo").resizeWithAspectRatio(contentMode: .fit)

Button("Cancel") { }.borderless()   // .buttonStyle(BorderlessButtonStyle())

Button("Tap me") { }
    .buttonStyle(BounceButtonStyle())   // scales down on press, springs back
```

## Glass & Blur Effects

### Liquid Glass, with a fallback

`safeGlassEffect` uses the real Liquid Glass material on iOS/macOS 26+, and falls back to whatever `ShapeStyle` (a `Material`, a `Color`, a gradient…) you give it below that:

```swift
Text("Expand")
    .padding(12)
    .safeGlassEffect(
        .clear,                     // or .regular
        fallback: Color.white,      // used pre-26
        isInteractive: true,
        clipShape: .capsule,
        tintColor: .accentColor,
        glassEffectID: "ExpandButton",
        nameSpace: glassNamespace   // for a morphing transition between two glass elements
    )
```

Group multiple glass elements so they can morph into and combine with one another, the same way `GlassEffectContainer` does on 26 — this is a no-op wrapper below that:

```swift
SafeGlassContainer(spacing: 16) {
    HStack {
        Text("A").safeGlassEffect(.clear, fallback: Color.white, glassEffectID: "a", nameSpace: ns)
        Text("B").safeGlassEffect(.clear, fallback: Color.white, glassEffectID: "b", nameSpace: ns)
    }
}
```

### Blur views

```swift
#if os(iOS)
BlurView(style: .systemChromeMaterial)   // wraps UIVisualEffectView / UIBlurEffect
#endif

#if os(macOS)
BlurView(material: .hudWindow, blendingMode: .behindWindow, overlayColor: .white.opacity(0.2))
#endif
```

### Variable blur

A blur whose radius fades across the view — for a bar that blurs content scrolling underneath it without a hard edge (iOS/UIKit only):

```swift
ZStack(alignment: .top) {
    content

    VariableBlurView(maxBlurRadius: 20, direction: .blurredTopClearBottom)
        .frame(height: 120)
        .ignoresSafeArea()
}
```

`direction` is one of `.blurredTopClearBottom`, `.blurredBottomClearTop`, `.blurredLeftClearRight`, `.blurredRightClearLeft`.

### Transparent sheet background

Removes the default dimmed background behind a presented sheet or full-screen cover (iOS only — test carefully, it reaches into the view hierarchy above its superview):

```swift
YourView()
    .background(TransprentBackground())
```

## Alerts, Share Sheets & Drops

Available on any `View`, any `ObservableObject` (so a view model can call these directly), and any `UIViewController` — the same three calls, everywhere (iOS only):

```swift
// A native UIAlertController
self.showAlert(
    title: "Delete item?",
    message: "This can't be undone.",
    actions: [
        UIAlertAction(title: "Cancel", style: .cancel),
        UIAlertAction(title: "Delete", style: .destructive) { _ in delete() }
    ]
)

// UIActivityViewController
self.ShareSheet(activityItems: ["Check this out!", url])

// A small, Apple-style banner that drops from the top — like the mute-switch toggle indicator
self.showDrop(
    title: "Saved",
    subtitle: "Your changes were saved",
    icon: UIImage(systemName: "checkmark.circle.fill"),
    position: .top,           // or .bottom
    duration: .seconds(2),    // or .recommended, .enteredByUser, .short, .long
    haptic: .success          // plays a haptic alongside the drop
)
```

`Drop` (the underlying type, from a vendored copy of [omaralbeik/Drops](https://github.com/omaralbeik/Drops)) also supports a tap `action` and custom `accessibility` text — see its doc comments for the full initializer.

## Haptics

```swift
#if os(iOS)
self.playHapticFeedback(.success)   // .error, .success, .warning, .light, .medium, .heavy
#endif

#if os(macOS)
self.generateFeedback(.alignment, performTime: .now)   // NSHapticFeedbackManager.FeedbackPattern
// or, from a View:
myView.playHapticFeedback(.alignment, performTime: .now)
#endif
```

Every haptic call — on both platforms — checks a single kill switch first:

```swift
UserDefaults.isHapticEnabled = false   // globally silences playHapticFeedback everywhere, default true
```

## Keyboard Handling

Dismiss the keyboard from anywhere — a `View`, an `ObservableObject`, or `UIApplication.shared` directly (iOS only):

```swift
self.hideKeyboard()
```

`KeyboardMonitor` publishes the live keyboard height (already net of the bottom safe area), so you can slide content up as the keyboard appears (iOS only):

```swift
struct ContentView: View {
    @StateObject private var keyboard = KeyboardMonitor.shared

    var body: some View {
        VStack {
            TextField("Message", text: $text)
        }
        .padding(.bottom, keyboard.height)
        .animation(.easeOut(duration: 0.25), value: keyboard.height)
    }
}
```

Or subscribe from a view model with Combine:

```swift
final class MyViewModel: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    private var cancellables = Set<AnyCancellable>()

    init() {
        KeyboardMonitor.shared.heightPublisher
            .removeDuplicates()
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)
    }
}
```

## Force-Update Prompt

One call checks the App Store for a newer version and, if the user is behind, presents a full-screen prompt over your app (iOS only):

```swift
forceUpdateModel.shared.checkVersion(appID: "1234567890", showCloseButton: false)
```

`showCloseButton: false` makes the update mandatory (no way to dismiss); `true` adds a close button so the user can continue on the current version. To build your own UI instead of the bundled screen:

```swift
forceUpdateModel.shared.showDefaultDisplay = false
forceUpdateModel.shared.doesAppNeedUpdate = { needsUpdate in
    if needsUpdate {
        // present your own update screen
    }
}
forceUpdateModel.shared.checkVersion(appID: "1234567890")
```

## App & Bundle Info

Cross-platform, straight off `Bundle`:

```swift
Bundle.main.displayName    // "MyApp" — respects InfoPlist.strings localization
Bundle.main.appVersion     // "1.4.2"  (CFBundleShortVersionString)
Bundle.main.buildNumber    // "87"     (CFBundleVersion)
Bundle.main.fullVersion    // "1.4.2 (87)"
Bundle.main.appIcon        // PlatformImage? — UIImage on iOS, NSImage on macOS
```

On iOS, the same five properties are also available as shorthand straight off `UIApplication.shared`:

```swift
UIApplication.shared.displayName
UIApplication.shared.appVersion
UIApplication.shared.fullVersion
```

Debug / TestFlight / App Store detection, and a matching debug-only logger — see [Logging](#logging):

```swift
switch myView.appEnvironment {     // Config.appConfiguration, exposed on any View
case .Debug:      break
case .TestFlight:  break
case .AppStore:    break
}
```

## Logging

Routes to `os_log`, and — regardless of build configuration — only prints anything at all while `appEnvironment == .Debug`. Nothing this library logs reaches a TestFlight or App Store build:

```swift
Log.debug("Fetching page \(page)")
Log.info("User logged in")
Log.defaultLog("Cache warmed")
Log.error("Request failed: \(error)")
Log.fault("Unexpected nil where a value was required")
```

## Color Utilities

```swift
let brand = Color(hexString: "#FF5733")   // also accepts "F53", "FF5733", or "AAFF5733" (alpha-first)

let hex = brand.toHex()          // "FF5733" or "AAFF5733" if not fully opaque — iOS 14+ / macOS 11+

#if os(iOS)
let hex2 = UIColor.red.toHexCode()   // "#FF0000"
#elseif os(macOS)
let hex2 = NSColor.red.toHexCode()   // "#FF0000"
#endif
```

## Date Utilities

```swift
let now = Date()

now.getReadableTime()       // "03:30 PM"
now.getReadableDate()       // "07/22/2023"      (MM/DD/YYYY)
now.getReadableDateTime()   // "07/22/2023 03:30 PM"

now.getMonthName()          // "July"
now.getShortMonthName()     // "Jul"
now.getDayName()            // "Saturday"
now.getShortDayName()       // "Sat"

now.getDateComponent(.year)              // 2023
now.getDateComponent(.day, calendar: myCalendar)

now.TimeStemp()                          // "20230722T153000123" — unique, sortable
now.TimeStemp(format: "yyyy-MM-dd")      // any DateFormatter pattern
```

## Data & Number Formatting

```swift
someData.getReadableDataSize()      // "1.2 MB" — via ByteCountFormatter

let bytes: Int64 = 3_400_000
bytes.toReadableSize()              // "3.24 MB" — a lightweight, formatter-free alternative
```

## Threading Helpers

```swift
Thread.OnMainThread {
    // runs immediately if already on main, otherwise dispatched async
}

Thread.OnBackgroundThread {
    // DispatchQueue.global(qos: .background).async
}

Thread.runAfter(2.0) {
    // main thread, after a 2 second delay
}

Thread.startNewThread(name: "com.myapp.worker", qos: .userInitiated) {
    // a dedicated, named Thread
}
```

## Notifications

```swift
extension Notification.Name {
    static let didUpdateProfile = Notification.Name("didUpdateProfile")
}

Notification.Name.didUpdateProfile.fire()
Notification.Name.didUpdateProfile.fire(value: ["userID": 42])
```

## Photos (PHAsset)

Async/await image loading straight off a `PHAsset` — no completion-handler boilerplate (iOS only):

```swift
if let image = await asset.loadImage(targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill) {
    // a resized thumbnail
}

if let original = await asset.loadOriginalImage() {
    // the exact original bytes, via requestImageDataAndOrientation
}
```

## Device, Screen & App Store Helpers

```swift
UIDevice.current.hasNotch          // true on notched/Dynamic Island devices
UIDevice.current.isIPad
UIDevice.current.topSafeArea       // cached after first read
UIDevice.current.bottomSafeArea
UIDevice.current.leadingSafeArea
UIDevice.current.trailingSafeArea

UIScreen.main.displayCornerRadius             // the device's real corner radius (private API, safely wrapped)
UIScreen.main.displayCorner(minimum: 20)

UIApplication.shared.findKeyWindow()          // the active scene's key window, across iOS versions
UIApplication.shared.topViewController()      // the top-most presented/visible view controller

SKStoreReviewController().requestReviewInCS() // requests an App Store review on the active scene (iOS 14+)

// Every font family and its face names on the device — handy for a font-picker screen
let fonts: [String: [String]] = self.getAllFonts()   // on any View or ObservableObject
```

## Embedding SwiftUI in UIKit

Drop a SwiftUI view into a `UIViewController` without wiring up a `UIHostingController` yourself:

```swift
class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwiftUIChildView(MySwiftUIView())                  // fills self.view
        addSwiftUIChildView(AnotherView(), to: someContainer)  // fills a specific UIView
    }
}
```

## macOS Window Chrome

Custom traffic-light-style window controls, for a borderless or otherwise customized window:

```swift
#if os(macOS)
windowButtons(
    closeHandler: { NSApp.terminate(nil) },
    miniaturizeHandler: { NSApp.keyWindow?.miniaturize(nil) },
    resizeHandler: { NSApp.keyWindow?.toggleFullScreen(nil) }
)
#endif
```

Pass only `closeHandler` for a close-only button; the minimize/resize buttons render disabled (gray) when their handlers are `nil`.

```swift
#if os(macOS)
someWindow.transparentWindow(level: .screenSaver)   // borderless, clear, no shadow
#endif
```

## Optional Firebase Analytics Bridge

If your app already links `FirebaseAnalytics`, SwiftyUIX adds a one-line event logger on top of it — this code only compiles in if that framework is present, and SwiftyUIX does **not** depend on it otherwise:

```swift
myView.setEvent("screen_viewed")
myViewModel.setEvent("button_tapped")     // any ObservableObject
myViewController.setEvent("screen_viewed") // iOS UIViewController
"screen_viewed".asFirebaseEvent()
```

## Platform & Availability Matrix

| Feature | iOS | macOS | Minimum |
|---|:---:|:---:|---|
| `LayoutInspector` / `TabBarArea` | ✅ | — | iOS 17 (hinge & reserved regions need iOS 27.1) |
| Frame & layout helpers | ✅ | partial | — |
| `safeGlassEffect` / `SafeGlassContainer` | ✅ | ✅ | iOS 15 / macOS 12 (real glass on 26+) |
| `BlurView` | ✅ | ✅ | separate iOS/macOS implementations |
| `VariableBlurView` | ✅ | — | UIKit only |
| `TransprentBackground` | ✅ | — | — |
| Alerts / Share Sheet / Drops | ✅ | — | — |
| Haptics | ✅ | ✅ | different APIs per platform |
| `KeyboardMonitor` | ✅ | — | — |
| `forceUpdateModel` | ✅ | — | — |
| Bundle & app info | ✅ | ✅ | — |
| `Log` | ✅ | ✅ | — |
| Color hex utilities | ✅ | ✅ | `toHex()` needs iOS 14 / macOS 11 |
| Date / Data / Thread / Notification helpers | ✅ | ✅ | — |
| `PHAsset` loaders | ✅ | — | — |
| `SKStoreReviewController.requestReviewInCS()` | ✅ | — | iOS 14 |
| `addSwiftUIChildView` | ✅ | — | — |
| `windowButtons` / `NSWindow.transparentWindow` | — | ✅ | — |
| Firebase bridge | ✅ | ✅ | only compiles if `FirebaseAnalytics` is linked |

## Example App

`swiftyUIXExamples/` in this repository is a working demo of most of the above — including a bento-grid `LayoutInspector` dashboard and a fold-aware book reader that lays its gutter on the real crease of a foldable device. Open `SwiftyUIX.xcodeproj`, select the `swiftyUIXExamples` scheme, and run.

## License

This project is licensed under the [MIT License](LICENSE). Feel free to use and modify it as per your requirements.
