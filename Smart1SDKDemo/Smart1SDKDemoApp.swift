//
//  Smart1SDKDemoApp.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 19/11/25.
//

import SwiftUI
import GoogleMaps
import Smart1SDK_iOS

@main
struct Smart1SDKDemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        Smart1SDK.initialize()
        if (
            Secrets.googleMapsApiKey.isEmpty
        ) {
            fatalError(
                """
                    The Google Maps Api Key is empty.
                    
                    - Google Maps API Key: \(Secrets.googleMapsApiKey)
                    
                    Please check the values in the Secrets file.
                """
            )
        }
        GMSServices.provideAPIKey(Secrets.googleMapsApiKey)
        EM().i(a: 0)
        if (
            Secrets.smart1SDKApiKey.isEmpty ||
            Secrets.smart1SDKUserOperatorEmail.isEmpty
        ) {
            fatalError(
                """
                    The SDK API Key or/and the User Operator Email is empty.
                    
                    - SDK API Key: \(Secrets.smart1SDKApiKey)
                    - User Operator Email: \(Secrets.smart1SDKUserOperatorEmail)
                    
                    Please check the values in the Secrets file.
                """
            )
        }
        let initSDKConfig = InitSDKConfig()
        if (!initSDKConfig.isInitialized()) {
            initSDKConfig.initialize(
                sdkApiKey : Secrets.smart1SDKApiKey,
                email     : Secrets.smart1SDKUserOperatorEmail
            )
        }
        return true
    }
}
