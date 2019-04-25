
# Welcome to StreemVision demo app for iOS!

### Minimum Requirements

* Xcode 10.2 with Swift 5
* Cocoapods 1.6 or later
* ARKit compatible device with IOS 12 or later

### Getting started

- Clone this repo

- `pod install` from the root directory. Cocoapods needs to be installed for this.

- Open the project in xcode by clicking on `StreemVisionSample.xcworkspace`

- Contact us at support@streem.pro to get an API Key.

- Modify `streemAPIKey` inside `ViewController.swift` with your own API Key.

- Build the project and run it on an ARKit compatible iOS device (iPhone7 and above)

### Occlusion & Physics

Occlusion and Physics are automatically enabled for free, for mapped areas. No need for extra setup.

### Troubleshooting

##### Could not find module 'StreemVision'

This is usually because you are attempting to run the project in Simulator.  Switch to a compatible IOS device and try again.

##### Error when building: "unable to open file" .../Pods/Pods/Target Support Files/...

You may be using Cocoapods 1.5.  Upgrade to Cocoapods 1.6, and run the following commands:
```
pod deintegrate
pod install
```
Open the workspace and try again.

### Additional Documentation**

[Documentation](https://github.com/streem/streemvisionsample/tree/master/docs)
