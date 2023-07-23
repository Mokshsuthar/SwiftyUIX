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
### Views
<details>
  <summary>BlurView</summary>

The `BlurView` is a SwiftUI view that creates a visual blur effect, primarily designed for iOS.

### Features

- **Visual Blur Effect**: `BlurView` is a `UIViewRepresentable` that wraps a `UIVisualEffectView` to apply a blur effect to its content based on the specified `UIBlurEffect.Style`.
- **Customizable Style**: You can customize the blur effect by providing a different `UIBlurEffect.Style` during initialization. The default style is `.systemChromeMaterial`, representing the standard system blur appearance.

### Usage Example

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // Your content here...
            
            // Apply a blur effect to the content
            BlurView(style: .systemUltraThinMaterial)
        }
    }
}

```
### Requirements

- iOS 13.0 or later 
</details>

<details>
  <summary>HTMLWebView</summary>
  
The `HTMLWebView` is a SwiftUI view that displays a `WKWebView` with HTML content from a specified file path.

### Features

- **Load HTML Content**: `HTMLWebView` is a `UIViewRepresentable` that loads and displays HTML content from a given file path in a `WKWebView`.
- **Transparent Background**: The `WKWebView` and its scroll view have a transparent background, allowing seamless integration with other SwiftUI views.
- **Optional Scroll Event Handling**: You can optionally receive scroll events from the web view's scroll view through the `scrollViewDidScroll` closure parameter.

### Usage Example

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            // Your other SwiftUI views here...
            
            // Display the HTML content from a specified file path
            HTMLWebView(filePath: Bundle.main.path(forResource: "sample", ofType: "html"))
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
}
```

### Requirements

- iOS 13.0 or later for `HTMLWebView` on iOS.
- macOS 11.0 or later for `HTMLWebView` on macOS.

### Extensions
<details>
      
<summary>swiftui Views Extensions</summary>

1. **Device Dimensions**
   - `screenWidth`: Retrieves the width of the device screen in `CGFloat`.
   - `screenHeight`: Retrieves the height of the device screen in `CGFloat`.
   - `topSafeAreaHeight`: Retrieves the height of the top safe area (notch, if applicable) in `CGFloat`.
   - `bottomSafeAreaHeight`: Retrieves the height of the bottom safe area in `CGFloat`.

3. **Screen Corner Radius**
   - `screenCornerRadius(minimum:)`: Calculates and returns the corner radius of the device's display. Optional minimum value can be set.

4. **Home Indicator**
   - `hideHomeIndicator()`: Hides the home indicator on devices running iOS 16.0 or later. Compatibility handled for earlier iOS versions.

5. **Haptic Feedback**
   - `playHapticFeedback(_:)`: Plays haptic feedback using the specified `feedbackType`.

6. **View Frame Manipulation**
   - `fullframe(alignment:)`: Makes a view occupy the full parent's space with optional alignment.
   - `fullWidth(height:alignment:)`: Sets the frame with full available width and optional height.
   - `fullHeight(width:alignment:)`: Sets the frame with full available height and optional width.
   - `squareFrame(size:alignment:)`: Creates a square frame for views with a specified size and alignment.

7. **Safe Area Ignoring**
   - `ignoreSafeArea_C()`: Ignores the safe area insets of the device on iOS 14 and above.

8. **View Masking**
   - `cornerRadius(_:)`: Adds a continuous corner radius to the view.

9. **Scroll Position Detection**
   - `getScrollPosition(key:handler:)`: Detects the scroll position of a view and calls the handler with the offset.

10. **System Icon Image View**
   - `systemImage(_:)`: Creates an image view with a system icon.

11. **View Border**
    - `border(lineWidth:cornerRadius:color:)`: Adds a border to the view with specified line width, corner radius, and color.

</details>

<details>
  <summary>SwiftUI Image Extensions</summary>

A set of helpful SwiftUI extensions to manipulate image views easily.

### Features

1. **Square Frame with Aspect Ratio**
   - `squareFrameWithApectRatio(value:contentMode:)`: Resizes the image to a square frame with a specified size while maintaining its aspect ratio. The `contentMode` parameter allows you to control how the image fills the frame.

2. **Resize with Aspect Ratio**
   - `resizeWithApectRatio(contentMode:)`: Resizes the image while maintaining its aspect ratio. The `contentMode` parameter lets you control how the image fits within its new frame.

### Usage Example

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        Image("exampleImage")
            .squareFrameWithApectRatio(value: 100, contentMode: .fill)
            .border(lineWidth: 2, cornerRadius: 10, color: .blue)
    }
}
```
      
</details>

<details>
  <summary>Thread Extensions</summary>
      
A collection of useful extensions for managing threads in Swift.

### Features

1. **On Main Thread Execution**
   - `OnMainThread(_:)`: Executes the given closure on the main thread if the current thread is already the main thread. Otherwise, dispatches it asynchronously to the main thread for execution.

2. **On Background Thread Execution**
   - `OnBackGroudThread(_:)`: Executes the given closure on a background thread using a global background queue.

3. **Delayed Execution on Main Thread**
   - `runAfter(_:completion:)`: Schedules the given closure to run after a specified delay (in seconds) on the main thread using `DispatchQueue.main.asyncAfter`.

4. **Custom Thread Creation**
   - `startNewThread(name:qos:execute:)`: Creates and manages custom threads with specific configurations. This extension allows you to start a new thread with a custom name and Quality of Service (QoS).

### Usage Example

```swift
import Foundation

// Execute a closure on the main thread after a delay of 2 seconds
Thread.runAfter(2) {
    print("This will be executed after 2 seconds on the main thread.")
}

// Execute a closure on the main thread
Thread.OnMainThread {
    print("This will be executed on the main thread.")
}

// Execute a closure on a background thread
Thread.OnBackGroudThread {
    print("This will be executed on a background thread.")
}

// Create and start a custom thread
Thread.startNewThread(name: "CustomThread", qos: .userInitiated) {
    print("This is a custom thread with name 'CustomThread' and QoS 'userInitiated'.")
}
```

</details>

<details>
  <summary>Date Extensions</summary> 

A set of useful extensions for working with Date objects in Swift.

### Features

1. **Readable Time**
   - `getReadableTime()`: Formats a Date object into a human-readable time string in a 12-hour format with AM/PM indicator. Example output: "03:30 PM" or "11:45 AM".

2. **Readable Date**
   - `getReadableDate()`: Formats a Date object into a human-readable date string in the format "MM/DD/YYYY". Example output: "07/22/2023" or "01/05/2024".

3. **Readable Date and Time**
   - `getReadableDateTime()`: Formats a Date object into a human-readable date and time string. Example output: "07/22/2023 03:30 PM" or "01/05/2024 11:45 AM".

4. **Timestamp Generation**
   - `TimeStemp(format:)`: Provides a unique timestamp according to the given format. The default format is "yyyyMMdd'T'HHmmssSSS".

5. **Month and Day Names**
   - `getMonthName()`: Gets the full month name from the date, like "January," "February," etc.
   - `getShortMonthName()`: Gets the short month name from the date, like "Jan," "Feb," etc.
   - `getDayName()`: Gets the full day name from the date, like "Sunday," "Monday," etc.
   - `getShortDayName()`: Gets the short day name from the date, like "Sun," "Mon," etc.

6. **Date Component Retrieval**
   - `getDateComponent(_:calendar:)`: Returns the value of a specific component (e.g., day, month, year, hour, minute) from the Date object using the provided Calendar. If no Calendar is provided, it defaults to the current calendar.

### Usage Example

```swift
import Foundation

let currentDate = Date()

let readableTime = currentDate.getReadableTime()
print("Readable Time: \(readableTime)")

let readableDate = currentDate.getReadableDate()
print("Readable Date: \(readableDate)")

let readableDateTime = currentDate.getReadableDateTime()
print("Readable Date and Time: \(readableDateTime)")

let timestamp = currentDate.TimeStemp()
print("Timestamp: \(timestamp)")

let monthName = currentDate.getMonthName()
print("Month Name: \(monthName)")

let shortMonthName = currentDate.getShortMonthName()
print("Short Month Name: \(shortMonthName)")

let dayName = currentDate.getDayName()
print("Day Name: \(dayName)")

let shortDayName = currentDate.getShortDayName()
print("Short Day Name: \(shortDayName)")

let day = currentDate.getDateComponent(.day)
print("Day: \(day)")

let month = currentDate.getDateComponent(.month)
print("Month: \(month)")

let year = currentDate.getDateComponent(.year)
print("Year: \(year)")
```

</details>

<details>
       <summary> Data Extension</summary> 

A convenient extension for working with Data objects in Swift.

### Features

1. **Readable Data Size**
   - `getReadableDataSize()`: Converts the size of a Data object into a human-readable format, displaying units like KB, MB, GB, etc.

### Usage Example

```swift
import Foundation

let testData = Data(repeating: 0, count: 1024) // 1 KB
let readableSize = testData.getReadableDataSize()
print("Readable Size: \(readableSize)") // Output: "1 KB"
```

</details>

<details>
       <summary> Color Extensions</summary> 

### Features

1. **Initialization from Hex String**
   - `init(hexString:)`: Initializes a Color object from a valid hex color string (e.g., "#RRGGBB" or "#AARRGGBB").

2. **Conversion to Hex String**
   - `toHex()`: Converts the Color object to its hex representation. For macOS, this function is only available on macOS 11.0 and later, and for iOS, it requires iOS 14.0 and later.

3. **Conversion from `UIColor` (iOS) or `NSColor` (macOS) to Hex Code**
   - `toHexCode()`: Converts a `UIColor` object (iOS) or `NSColor` object (macOS) to its hex representation.

### Usage Example

```swift
import SwiftUI

let redColor = Color(hexString: "#FF0000")
let hexCode = redColor.toHex()
print("Hex Code: \(hexCode ?? "Unknown")") // Output: "Hex Code: #FF0000"

#if os(iOS)
if let uiColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).toHexCode() {
    print("UI Color Hex Code: \(uiColor)") // Output: "UI Color Hex Code: #7F7F7F"
}
#elseif os(macOS)
if let nsColor = NSColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).toHexCode() {
    print("NS Color Hex Code: \(nsColor)") // Output: "NS Color Hex Code: #7F7F7F"
}
#endif
```
      
</details>
