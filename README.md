# Smart1 SDK iOS Demo

Smart1 SDK integration demo for iOS. Shows how to initialize the SDK, use the tracker, download data, and visualize information on a map.

## About Smart1

Smart1 is a comprehensive logistics management solution for first-mile operations, from intelligent vehicle assignment to real-time trip tracking. It provides visibility and intelligent automation to reduce costs and improve efficiency in logistics centers.

The platform offers:
- **Operations Dashboard** - Real-time view of orders (assigned, in progress, completed)
- **Intelligent Route Management** - Automatic optimization based on location, dock schedules, and traffic
- **Fleet Management** - Monitoring of trucks/trailers, capacities, and predictive maintenance
- **Dynamic URLs** - Customized links to share operation status with clients

This SDK is designed for the **driver/operator side** of the logistics operation, enabling mobile applications for truck drivers who transport cargo between ports and docks, providing real-time tracking, route guidance, and order management capabilities.

## Features

- 🔑 Smart1 SDK initialization and configuration
- 📍 Real-time location tracking service
- 📦 Data retrieval (Orders, Routes, Ports, Schedules, Docks)
- 🗺️ Route and port visualization on Google Maps
- 📱 Modern UI with SwiftUI
- 🏗️ MVI architecture with Combine

## Prerequisites

Before running this project, you need:

1. **Smart1 SDK CocoaPods Access** - Repository URL and credentials to download the SDK (provided by Smart1 administration upon SDK acquisition)
2. **Smart1 SDK API Key** - API key for SDK initialization (provided by Smart1 administration upon SDK acquisition)
3. **Smart1 User Operator Email** - Your registered operator email
4. **Google Maps API Key** - Get it from [Google Cloud Console](https://console.cloud.google.com/)

**Note:** Contact Smart1 administration to obtain the repository credentials and SDK API key.

For complete SDK documentation, visit: [Smart1 SDK iOS Documentation](https://smart1-sdk-ios-docs-dot-servi-smart1-logistica-dev.uc.r.appspot.com/)

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/servinformacion-logistic/Smart1SDK-iOS-Demo.git
cd Smart1SDK-iOS-Demo/Smart1SDKDemo
```

### 2. Configure Secrets

Create a `Secrets.swift` file in the `Smart1SDKDemo/Smart1SDKDemo` directory (or update the existing one) with your credentials:

```swift
import Foundation

struct Secrets {
    static let googleMapsApiKey           = "your_google_maps_api_key_here"
    static let smart1SDKApiKey            = "your_smart1_sdk_api_key_here"
    static let smart1SDKUserOperatorEmail = "your_operator_email@example.com"
}
```

**Important:** 
- Replace the placeholder values with your actual API keys and email
- The `Secrets.swift` file is gitignored for security reasons
- Never commit your API keys to version control

### 3. Configure Pod SDK Credentials

Create or edit the `~/.netrc` file on your Mac to store your Git credentials:

```bash
nano ~/.netrc
```

Add the following content (replace `YOUR_USERNAME` and `YOUR_PRIVATE_TOKEN` with the username and private token provided by Servinformación):

```
machine git.sitimapa.co
login YOUR_USERNAME
password YOUR_PRIVATE_TOKEN
```

Protect the file:

```bash
chmod 600 ~/.netrc
```

If the repository requires authentication, you may need to add credentials to your git configuration or use a personal access token.

### 4. Install Dependencies

```bash
cd Smart1SDKDemo
pod install
```

### 5. Open and Run

1. Open `Smart1SDKDemo.xcworkspace` in Xcode (not the `.xcodeproj` file)
2. Select your development team in the project settings
3. Build and run the project on your device or simulator

**Note:** Location tracking features work best on a physical device.

## Permissions

The app requires the following permissions configured in `Info.plist`:

- `NSLocationWhenInUseUsageDescription` - For location tracking while app is in use
- `NSLocationAlwaysAndWhenInUseUsageDescription` - For continuous background location tracking
- `UIBackgroundModes` (location) - For background location updates

All permissions are requested at runtime when the app starts.

## Usage

### Initialize the SDK

The SDK is automatically initialized in the `AppDelegate` class when the app starts:

```swift
let initSDKConfig = InitSDKConfig()
if (!initSDKConfig.isInitialized()) {
    initSDKConfig.initialize(
        sdkApiKey : Secrets.smart1SDKApiKey,
        email     : Secrets.smart1SDKUserOperatorEmail
    )
}
```

### Start Location Tracker

Tap the **"Turn On Tracker"** button in the toolbar to start the background location tracking service.

### View Orders and Routes

1. Tap the refresh button (↻) to load orders from the SDK
2. Tap **"Select a order"** to choose an order
3. The route and ports will be displayed on the map
4. Tap on markers to see port details
5. Tap the info icon (ⓘ) to see order details

## Tech Stack

- **Language:** Swift
- **UI:** SwiftUI
- **Architecture:** MVI
- **Async:** Combine
- **Maps:** Google Maps SDK for iOS
- **Dependency Management:** CocoaPods
- **SDK:** Smart1 SDK for iOS

## Project Structure

```
Smart1SDKDemo/
├── Smart1SDKDemo/
│   ├── core/                    # Core utilities and components
│   │   ├── model/               # Data models
│   │   └── utils/               # Utility classes
│   ├── home/                    # Home screen (main feature)
│   │   ├── components/          # UI components
│   │   ├── HomeScreen.swift
│   │   ├── HomeViewModel.swift
│   │   ├── HomeState.swift
│   │   ├── HomeAction.swift
│   │   └── HomeEvent.swift
│   ├── tracker/                 # Location tracking service
│   │   ├── TrackerDemo.swift
│   │   └── TrackerDemoSt.swift
│   ├── Smart1SDKDemoApp.swift   # App entry point
│   ├── ContentView.swift
│   ├── Secrets.swift            # API keys and configuration
│   └── Info.plist
├── Podfile                      # CocoaPods dependencies
└── Smart1SDKDemo.xcworkspace
```

## Troubleshooting

### SDK initialization error

If you see an error about empty API keys:
- Check that your `Secrets.swift` file exists in `Smart1SDKDemo/Smart1SDKDemo/`
- Verify that all three required properties are set correctly
- Clean the build folder (Product > Clean Build Folder) and rebuild

### Pod install fails

- Ensure you have access to the Smart1 private CocoaPods repository
- Verify your git credentials are configured correctly
- Try removing the Podfile.lock and Pods folder, then run `pod install` again
- Check that you're using a compatible version of CocoaPods

### Map not showing

- Verify your Google Maps API Key is valid
- Enable the Maps SDK for iOS in Google Cloud Console
- Check that the API key has no restrictions preventing its use
- Ensure you opened the `.xcworkspace` file, not the `.xcodeproj`

### Location tracking not working

- Ensure all location permissions are granted in iOS Settings
- Check that location services are enabled on your device
- For background tracking, make sure "Always" location permission is granted
- Test on a physical device for best results (simulator has limitations)

### Build errors after pod install

- Make sure you're opening `Smart1SDKDemo.xcworkspace` and not `Smart1SDKDemo.xcodeproj`
- Clean the build folder and derived data
- Verify that all pods were installed successfully

## License

This is a demo project for educational purposes.

**Important:** This is not a complete, production-ready application. It serves as a starting point and reference to help understand how to use the Smart1 SDK in an iOS application. The final, complete implementation depends on the specific requirements of each developer or organization integrating the SDK.
