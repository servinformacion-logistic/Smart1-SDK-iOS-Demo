//
//  ErrorUtils.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 25/11/25.
//

import Smart1SDK_iOS

class ErrorUtils {
    
    /// This function returns general and ambiguous string message based on the error type.
    ///
    /// Note: We highly recommend to modify this function to return more specific messages based on the
    /// error type and the context where this error comes from. Or even create an specific function
    /// for each context where some error could be returned.
    ///
    /// Example:
    /// Is no the same getting an ApiError.notFound when
    /// - Requesting some data (like orders, ports, etc) - In this case it means that the requested
    /// data was not found.
    /// - Requesting an update of the state of an order - In this case it means that the order that
    /// we are trying to update does not exist or wasn't found by the api.
    ///
    /// So, based on this example, we remind you that it is important to understand that
    /// the same error type can have different meanings depending on the context where it comes from.
    static func toMsg(
        error : ErrorS1SDK
    ) -> String {
        switch error {
        case let error as SdkInitConfigError:
            return mappingSingleErrorMessages(error: error)
            
        case let error as CommonError:
            return mappingSingleErrorMessages(error: error)
            
        case let error as ApiError:
            return mappingSingleErrorMessages(error: error)
            
        case let listError as ApiListError<Any>:
            switch listError {
            case .allErrors(let errors):
                var errorMessages: [String] = []
                for (key, error) in errors {
                    errorMessages.append("\(mappingSingleErrorMessages(error: error)) [\(key)]")
                }
                return """
                (Api List Error)
                
                \(errorMessages.joined(separator: "\n - "))
                """
            }
            
        default:
            return "Unknown error"
        }
    }
    
    private static func mappingSingleErrorMessages(error: ErrorS1SDK) -> String {
        switch error {
        case let sdkError as SdkInitConfigError:
            switch sdkError {
            case .notFound:
                StartSDKUtils().startSDK()
                return "There is no SDK configuration found"
            case .sdkApiKeyNotFound:
                StartSDKUtils().startSDK()
                return "There is no SDK API key found"
            case .unknown(let cause):
                return "Unknown error when initializing SDK - \(cause)"
            }
            
        case let commonError as CommonError:
            switch commonError {
            case .invalidInputData(let cause):
                return "The input data is invalid (\(cause)) (Common Error)"
            case .invalidInputDataList(let cause):
                return "The input data list is invalid (\(cause)) (Common Error)"
            case .notFound:
                return "No data found (Common Error)"
            case .unknown(let cause):
                return "Unknown Common Error - \(cause)"
            }
            
        case let apiError as ApiError:
            switch apiError {
            case .noInternet:
                return "The device is not connected to the internet (Api Error)"
            case .timeout:
                return "The request timed out (Api Error)"
            case .expiredToken:
                return "The token has expired (Api Error)"
            case .notFound:
                return "The requested data or resource was not found (Api Error)"
            case .unauthorized:
                return "The user is not authorized to make this request (Api Error)"
            case .missingDataOnResponse(let message):
                return "Missing data on response - (\(message)) (Api Error)"
            case .serialization:
                return "Serialization Api Error when parsing response"
            case .serverError(let code, let message, let messages):
                return "Server Api Error - Details \n\n  - code: \(code)\n\n  - message: \(message)\n\n  - messages: \(messages)"
            case .unknown(let cause):
                return "Unknown Api Call Error - \(cause)"
            }
            
        default:
            return "Unknown error"
        }
    }
}
