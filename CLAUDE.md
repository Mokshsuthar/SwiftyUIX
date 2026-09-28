# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

SwiftyUIX is a SwiftUI/UIKit/AppKit utility library (extensions, views, view modifiers) shipped to consumers through **both** Swift Package Manager and CocoaPods, whose manifests declare iOS 13+ / macOS 12+ though the code now requires iOS 17 (see below). `swiftyUIXExamples/` is an in-repo iOS demo app that links the framework target and doubles as the manual test bed.

## Build, test, lint

```sh
# Whole-library typecheck for iOS — fastest feedback loop, covers every #if os(iOS) branch
xcrun swiftc -typecheck -target arm64-apple-ios17.0-simulator \
  -sdk "$(xcrun --sdk iphonesimulator --show-sdk-path)" -module-name SwiftyUIX \
  $(find SwiftyUIX/Classes -name "*.swift")

# Framework and demo app via Xcode project
xcodebuild build -scheme SwiftyUIX -destination 'generic/platform=iOS'
xcodebuild build -scheme swiftyUIXExamples -destination 'platform=iOS Simulator,name=iPhone Duo'

# macOS slice, and CocoaPods validation before tagging a release
swift build
pod lib lint --allow-warnings
```

As of 2.0 the manifests and the code agree: `Package.swift` declares `.iOS(.v17)/.macOS(.v12)`
(tools 5.9, since `.v17` needs it) and the podspec `17.0/12.0` with `swift_version 5.9`. iOS 17
is forced by `@Observable` in `LayoutInspector` and iOS 16 API in `ViewExtensions`; macOS stays
at 12 because `LayoutInspector.swift` and `TabBarArea.swift` are wrapped in `#if os(iOS)` —
`DeviceHinge`, `ReservedRegion` and `GeometryProxy.reservedRegions` are absent from the macOS
SDK entirely, so no deployment target can make them compile there. `pod lib lint
--allow-warnings` passes both platforms; drop that flag and the pre-existing redundant-`public`
and deprecated-`windows` warnings fail it.

Foldable work needs the **iPhone Duo** simulator on the iOS 27.1 runtime — `DeviceHinge`, `onHingeChange` and `GeometryProxy.reservedRegions` are all `anyAppleOS 27.1`, and every other device reports no hinge at all. `ContentView` renders `DuoTestView()` directly, so a launch lands straight on the panel that displays hinge, division and occlusion state.

**There is effectively no test suite.** `SwiftyUIXTests/SwiftyUIXTests.swift` holds only Xcode's generated stubs, neither auto-created scheme is configured for the test action (`xcodebuild test` errors out on both), and `swift test` fails because `Package.swift` declares no test target. Adding real tests means wiring a test target into `Package.swift` or sharing a scheme with a test action — verify changes by building both platform slices and exercising them in the demo app.

## The three build systems over one source tree

All library code lives in `SwiftyUIX/Classes/`. Each packaging system picks it up differently:

- **SwiftPM** — `Package.swift` declares `path: "SwiftyUIX", sources: ["Classes"]`. Anything outside `Classes/` (the `SwiftyUIX.h` umbrella header, the `.docc` catalog) is invisible to SPM. New files under `Classes/` are picked up with no manifest edit.
- **CocoaPods** — root `SwiftyUIX.podspec` globs `SwiftyUIX/**/*.swift`. `SwiftyUIX.xcodeproj/SwiftyUIX.podspec` is a **stale duplicate pinned at 1.0.5**; the root one is authoritative — never edit the copy.
- **Xcode project** — `project.pbxproj` lists files explicitly, so a new file needs target membership set manually or it silently misses only this build. (Known existing defect: `SKStoreReviewControllerExtension.swift` sits in Copy Bundle Resources and warns on every build.)

## Platform gating is the central constraint

Nearly every file is wrapped in `#if os(iOS)`, `#if os(macOS)`, `#if canImport(UIKit)`, or `#if canImport(AppKit)`; files serving both platforms (`ViewExtensions.swift`, `ColorsExtensions.swift`, `HapticFeedbackManager.swift`, `HTMLWebView.swift`) split per declaration rather than per file. Consequences when adding API:

- Unguarded UIKit references break the macOS build, and vice versa. A macOS counterpart is a deliberate decision, not automatic — most iOS API here has none.
- `swift build` compiles only the macOS slice, so iOS-only additions are unverified until you run the iOS typecheck or `xcodebuild`.
- OS-version gating is done in-body with `if #available`, exposing one symbol that degrades gracefully (`safe_glassEffect` falls back to `Material` below iOS 26, `hideHomeIndicator()` no-ops below iOS 16). The `safe_` prefix marks this pattern.

## Subsystem map

- `Classes/Extensions/` — the bulk of the public API: `View`, `Image`, `Color`/`UIColor`/`NSColor`, `Date`, `Data`, `Thread`, `UIDevice`, `UIScreen`, `UIApplication`, `UIViewController`, `ObservableObject`, `PHAsset`, plus `KeyboardMonitor` (Combine singleton publishing keyboard height).
- `Classes/Extensions/ExtraExtensions/firebaseExtensions.swift` — gated on `#if canImport(FirebaseAnalytics)`. Firebase is **not** a declared dependency of either manifest; the code simply materializes for consumers who already link it. Optional third-party integrations belong here under the same pattern.
- `Classes/Views/` — `UIViewRepresentable`/`NSViewRepresentable` wrappers (`BlurView`, `VariableBlurView`, `HTMLWebView`, `TransprantBackgroud`, `windowNavigationButtons`).
- `Classes/ViewModifires/` (spelling is load-bearing — it's the on-disk path) — `Drops/` is a vendored copy of [omaralbeik/Drops](https://github.com/omaralbeik/Drops) (MIT, keep the license headers, iOS/visionOS only); `ForceUpdate/` polls the iTunes lookup API and presents a blocking update screen on the top view controller; `HapticFeedbackManager.swift` funnels all haptics.
- `Classes/Logs/Logs.swift` + `Classes/AppConfigure.swift` — `Log.*` routes to `os_log` but returns early unless `Config.appConfiguration == .Debug` (Debug via `#if DEBUG`, TestFlight via a `sandboxReceipt` receipt path, else AppStore). Nothing this library logs reaches production builds.
- `Classes/Userdefaults.swift` — library-owned `UserDefaults` statics keyed by `#function`. `isHapticEnabled` is the global haptics kill switch read by `HapticFeedbackManager`; `topSafeArea`/`bottomSafeArea` are one-shot caches using `-1` as "unset" and populated by the `UIDevice` extensions. The file's comment forbids adding app-level keys here — they'd be wiped on pod update.

## Conventions

- Public surface is exposed via `public extension` on stdlib/framework types, so any new symbol is globally visible to consumers after `import SwiftyUIX`. Keep additions namespaced by naming, not by module structure.
- Shared state is singleton-based: `Drops.shared`, `HapticFeedbackManager.shared`, `KeyboardMonitor.shared`, `forceUpdateModel.shared`.
- Reuse `UIApplication.topViewController()` / `UIApplication.findKeyWindow()` for anything needing the current window or presenter; they already handle the iOS 13/15 scene transitions.
- Misspelled or superseded API is deprecated, never removed — `@available(*, deprecated, renamed:)` shims exist for `isPad`, `OnBackGroudThread`, `squareFrameWithApectRatio`. Follow that when renaming.
- `UIScreen.displayCornerRadius` reads the private `_displayCornerRadius` KVC key, assembled at runtime from reversed string components to avoid static string detection. Preserve that construction if you touch it.

## Releasing

Versions are bumped in the root `SwiftyUIX.podspec` and tagged as the bare version (`1.2.5`, no `v` prefix) because `spec.source` resolves `:tag => "#{spec.version}"`. README.md documents every public API in collapsible `<details>` sections — new public API is expected to land there in the same change.
