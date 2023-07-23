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
### Extensions
<details>
      
<summary>Frame Extensions</summary>
      
##### 1. full frame (.fullframe())

`fullframe()` is a concise SwiftUI extension that enables seamless full-frame viewing with customizable alignment options. Enjoy immersive content without distractions.
```sh
Text("Hello World")
      .fullframe()
```
or
```sh
ZStack{
    Text("Hello")
}.fullframe(alignment : .leading)
```
##### 2. full width (.fullwidth())
The `fullWidth()` function is a concise SwiftUI extension that allows for full-width viewing with optional height and customizable alignment.

If no height is provided, the function sets the width to fill the entire screen width without any constraints on the height, resulting in a full-width view with dynamic height based on its content.

With "fullWidth()", you can easily achieve immersive, distraction-free full-width layouts in SwiftUI.
```sh
Text("Hello World")
      .fullWidth()
// or
Text("Hello World")
      .fullWidth(alignment : .leading)
// or
Text("Hello World")
      .fullWidth(height : 50,alignment : .leading)
```
##### 3. full hight (.fullHeight())
The `fullHeight()` function is a concise SwiftUI extension designed to effortlessly achieve full-height views with customizable alignment options. You can easily set a specific width, and the view will adjust accordingly, maintaining a fixed width. Alternatively, when no width is specified, the view will expand to fill the entire available width while occupying the entire screen height. This simplifies the process of creating immersive, distraction-free layouts in SwiftUI.

```sh
Text("Hello World")
      .fullHight()
// or
Text("Hello World")
      .fullHight(alignment : .leading)
// or
Text("Hello World")
      .fullHight(width : 150,alignment : .leading)
```
##### 4. Square Frame (.squareFrame(size : CGFloat))
`squareFrame(size : CGFloat)` is a SwiftUI extension that instantly creates perfect square frames for views. Customize the size and alignment effortlessly. Simplify your SwiftUI development with this convenient function.

```sh
Text("Hello World")
      squareFrame(size : 100)
// or
Text("Hello World")
       squareFrame(size : 100, alignment : .leading)
```
</details>


</details>

<details>
<summary>Device Utils (iOS only)</summary>

1. `self.screenWidth` - screen width in CGFloat
2. `self.screenHeight` - screen Height in CGFloat
3. `self.topSafeAreaHeight` - top safe area (notch, if applicable)
4. `self.bottomSafeAreaHeight` - bottom safe area

Or you can use it is directly as frame 
```sh
  VStack{
    Spacer()
        .topSafeArea()
         
    Rectangle()
        .fill(.red)
         
    Spacer()
        .bottomSafeArea()
  }
```
5. `screenCornerRadius()` - function calculates and returns the corner radius of the device's display

</details>





