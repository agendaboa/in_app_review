import Flutter
import UIKit
import StoreKit

public class InAppReviewPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "dev.britannio.in_app_review", binaryMessenger: registrar.messenger())
        let instance = InAppReviewPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        log("handle", details: call.method)
        
        switch call.method {
        case "requestReview":
            requestReview(result)
        case "isAvailable":
            isAvailable(result)
        case "openStoreListing":
            openStoreListing(storeId: call.arguments as? String, result: result)
        default:
            log("method not implemented")
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func requestReview(_ result: @escaping FlutterResult) {
        if #available(iOS 16.0, *) {
            log("iOS 16+")
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                DispatchQueue.main.async {
                    AppStore.requestReview(in: scene)
                }
            }
            result(nil)
        } else {
            log("iOS 15")
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
            result(nil)
        }
    }
    
    
    private func isAvailable(_ result: @escaping FlutterResult) {
        log("available")
        result(true)
    }
    
    private func openStoreListing(storeId: String?, result: @escaping FlutterResult) {
        guard let storeId = storeId else {
            result(FlutterError(code: "no-store-id",
                              message: "Your store id must be passed as the method channel's argument",
                              details: nil))
            return
        }
        
        let urlString = "https://apps.apple.com/app/id\(storeId)?action=write-review"
        guard let url = URL(string: urlString) else {
            result(FlutterError(code: "url-construct-fail",
                              message: "Failed to construct url",
                              details: nil))
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        result(nil)
    }
    
    private func log(_ message: String, details: String? = nil) {
        if let details = details {
            NSLog("InAppReviewPlugin: \(message) \(details)")
        } else {
            NSLog("InAppReviewPlugin: \(message)")
        }
    }
}
