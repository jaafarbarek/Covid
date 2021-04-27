# Covid App

iOS University Project about tracking corona virus cases world wide, and allowing the users to activate quarantine mode.

[![Swift Version][swift-image]][swift-url]  [![codecov.io](https://coveralls.io/repos/github/saeed3e/Build-status-and-code-coverage-badge/badge.svg?branch=master)](https://codecov.io/gh/codecov/example-swift/branch/master)

# Requirements
* Xcode 12.x
* iOS 14 and above

# Setup

## Install iOS project dependencies and third parties

Project uses ruby gems cocoapods in order to install dependencies.

So first we need to run in our terminal:
Sudo gem install cocoapods

Then navigate to project directory:

```
pod install
```

Open `Covid.xcworkspace` (don't open `Covid.xcodeproj` as the app won't compile)
Then the project is ready to use within Xcode IDE.

# Main Dependencies

## IQKeyboardManagerSwift

Used to manage keyboard.

## lottie-ios

Used for the loader and launch screen animations.

## Charts

Core features:

8 different chart types
Scaling on both axes (with touch-gesture, axes separately or pinch-zoom)
Dragging / Panning (with touch-gesture)
Combined-Charts (line-, bar-, scatter-, candle-stick-, bubble-)
Dual (separate) Axes
Customizable Axes (both x- and y-axis)
Highlighting values (with customizable popup-views)
Save chart to camera-roll / export to PNG/JPEG


# App architecture

The app uses MVC architecture (Model View Controller)

MVC – short for Model-View-Controller – is Apple's preferred way of architecting apps for its platforms, and so it's the default approach used by most developers on Apple platforms. In MVC each piece of your code is one of three things: Models store your data, such as the names of products in a store.

![Architecture](https://i.ibb.co/4mRb1J1/01-MVC-Diagram.png)

# Folder structure

* *Models* - models of the app
* *Controllers* - contains the main controller of the app "HomeViewController"
* *ThirdPartySDK* - classes related to charts used by 3rd party charts sdk.
* *Views* - custom views and extensions.
* *Networking* - classes related to networking. It contains general classes.
* *Storyboards* - it contains all storyboards of the app.
* *Constants* - contains the contants file.
* *Authentication* - Contains classes responsible for authentication flow
* *Resources* - asset file + animations.json


# Coding Style guidelines

* There should not be any force unwrapping in code. We're using optional unwrapping in order to prevent crashes of production app and to not disturb user experience.
* There should be empty line after *imports* and before *class, struct, enum* definition.
* There should not be empty line before method name and first line of method body
* There should not be any spaces before opening or closing brackets
* There should not be any trailing white spaces in new lines

[swift-image]:https://img.shields.io/badge/swift-5.1-orange.svg
[swift-url]: https://swift.org/
