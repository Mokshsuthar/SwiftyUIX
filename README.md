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
##### Frame Extensions : -
full frame (.fullframe())
```sh
Text("Hello World")
      .fullframe()
```
or
```sh
ZStack{
    Text("Hello")
}
.fullframe(alignment : .leading)
```
