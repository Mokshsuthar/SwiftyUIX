# SwiftyUIX

SwiftyUIX is a powerful and versatile library for iOS and macOS developers that provides a collection of useful extensions and pre-defined views. With SwiftyUIX, you can enhance your development workflow, improve code readability, and accelerate app development by leveraging its handy utilities.
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
###### 1. full frame (.fullframe())

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
###### 2. full width (.fullwidth())
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
