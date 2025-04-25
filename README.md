Quick start examples for integrating [Banuba SDK on iOS](https://docs.banuba.com/face-ar-sdk-v1/ios/ios_getting_started) into Swift apps.  
  
# Getting Started

1. Get the Banuba SDK client token. Please fill in our form on [form on banuba.com](https://www.banuba.com/face-filters-sdk) website, or contact us via [info@banuba.com](mailto:info@banuba.com).
2. Install [CocoaPods](https://guides.cocoapods.org/using/getting-started.html) if you don't have it.
3. Install required project dependencies by running `pod install`.
4. Copy and Paste your client token into appropriate section of `arcloud-ios-swift/arcloud-ios-swift/BanubaClientToken.swift`
5. Open generated workspace (not a project!) in Xcode and run the example.

# AR Cloud

 1. Get the latest BanubaARCloud SDK archive for iOS and the AR cloud URL. Please fill in our form on [form on banuba.com](https://www.banuba.com/face-filters-sdk) website, or contact us via [info@banuba.com](mailto:info@banuba.com).
 2. Copy `BanubaARCloudSDK.xcframework` [from here](https://github.com/Banuba/BanubaARCloudSDK-IOS) into `arcloud-ios-swift/Frameworks/`
 3. Copy `BanubaUtilities.xcframework` [from here](https://github.com/Banuba/BanubaUtilities-iOS) into `arcloud-ios-swift/Frameworks/`
 4. Copy and Paste your AR cloud URL into [banubaArCloudURL](/arcloud-ios-swift/BanubaClientToken.swift#L4) property or use predefined Demo bucket

# Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

# Testing

The project contains XCUITest in `arcloud-ios-swiftUITests`. For correct tests work `UItest` album should be created on device and should contain at least one photo and one video inside.

