import Foundation
import Smart1SDK_iOS

class StartSDKUtils {
    func startSDK() {
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
    }
}
