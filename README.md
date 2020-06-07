# MaterialForm

Material UI Text Field component for UIKit, iOS and tvOS (iOS 10+, tvOS 10+).

TvOS is still in beta, but would be tweaked wherever required soon.

For SwiftUI support, please look into [MaterialFormSwiftUI][MaterialSwiftUI] pod (iOS 13+).

## Look and UI:

Default look and feel for light and dark theme style:

![Light][example-light]

![Dark][example-dark]

## Installation:

### 1. Swift Package Manager

Add to your `Package.swift`, or setup within XCode 11+:

```swift
.package(url: "https://github.com/GirAppe/MaterialForm.git", from: "0.9.7"),
```

### 2. Cocoapods

Add to your `Podfile`:

```ruby
pod 'MaterialForm'
```

### 3. Carthage

Add to your `Cartfile`:

```bash
github "GirAppe/MaterialForm"
```

## Main features:

1. KVO Observable text/event/state properties. In most cases you won't need to set it's delegate.
1. Easy usage of left/right accessories, allows to easiuly add clickable action icons
1. Built in error state handling, by setting `errorMessage` value
1. Support for specifying max characters count
1. Can define next text field, that the focus would pass to after return was tapped
1. Built in characters counter

## Usage:

### 1. Storyboard / nib:

Place a UITextField in your IB file, and change it's class to 'MaterialUITextField'. Voila ;)

> There are plenty of additional properties that are accessible through IB. For a different styles,
> set `borderStyle` property from IB.

### 2. From the code:

MaterialUITextField is a UITextField subclass. There is no additional setup required unless you want to.

<!-- Images -->

[example-light]: https://raw.githubusercontent.com/GirAppe/MaterialForm/0.9.7/material-form-light.gif  "Default light theme styling"
[example-dark]: https://raw.githubusercontent.com/GirAppe/MaterialForm/0.9.7/material-form-dark.gif  "Default dark theme styling"

<!-- Links -->

[MaterialSwiftUI]: https://github.com/GirAppe/MaterialFormSwiftUI  "MaterialForm SwiftUI"
