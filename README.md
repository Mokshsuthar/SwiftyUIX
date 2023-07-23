# SwiftyUIX

SwiftyUIX is a powerful and versatile library for iOS and macOS developers that provides a collection of useful extensions and pre-defined views. With SwiftyUIX, you can enhance your development workflow, improve code readability, and accelerate app development by leveraging its handy utilities.
[Click here to scroll down](#frame)
## Installation
### CocoaPods
To integrate SwiftyUIX into your Xcode project using CocoaPods, add the following line to your Podfile:
```sh
pod 'SwiftyUIX'
```
Then, run the following command:

```sh
$ pod install
```
### Swift Package Manager (SPM)
You can also use Swift Package Manager to add SwiftyUIX to your project. In Xcode, go to File -> Swift Packages -> Add Package Dependency... and enter the URL of this repository:
```sh
https://github.com/Mokshsuthar/SwiftyUIX.git
```
Follow the prompts to complete the installation.

## Usage
<details>
      
<summary>swiftui Views Extensions</summary>

      1. **Device Dimensions**
   - `screenWidth`: Retrieves the width of the device screen in `CGFloat`.
   - `screenHeight`: Retrieves the height of the device screen in `CGFloat`.
   - `topSafeAreaHeight`: Retrieves the height of the top safe area (notch, if applicable) in `CGFloat`.
   - `bottomSafeAreaHeight`: Retrieves the height of the bottom safe area in `CGFloat`.

2. **Screen Corner Radius**
   - `screenCornerRadius(minimum:)`: Calculates and returns the corner radius of the device's display. Optional minimum value can be set.

3. **Home Indicator**
   - `hideHomeIndicator()`: Hides the home indicator on devices running iOS 16.0 or later. Compatibility handled for earlier iOS versions.

4. **Haptic Feedback**
   - `playHapticFeedback(_:)`: Plays haptic feedback using the specified `feedbackType`.

5. **View Frame Manipulation**
   - `fullframe(alignment:)`: Makes a view occupy the full parent's space with optional alignment.
   - `fullWidth(height:alignment:)`: Sets the frame with full available width and optional height.
   - `fullHeight(width:alignment:)`: Sets the frame with full available height and optional width.
   - `squareFrame(size:alignment:)`: Creates a square frame for views with a specified size and alignment.

6. **Safe Area Ignoring**
   - `ignoreSafeArea_C()`: Ignores the safe area insets of the device on iOS 14 and above.

7. **View Masking**
   - `cornerRadius(_:)`: Adds a continuous corner radius to the view.

8. **Scroll Position Detection**
   - `getScrollPosition(key:handler:)`: Detects the scroll position of a view and calls the handler with the offset.

9. **System Icon Image View**
   - `systemImage(_:)`: Creates an image view with a system icon.

10. **View Border**
    - `border(lineWidth:cornerRadius:color:)`: Adds a border to the view with specified line width, corner radius, and color.

</details>





