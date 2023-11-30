import UIKit
import Flutter
import MessageUI



@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate {
    var flutterMethodChannel: FlutterMethodChannel?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController

        let METHOD_CHANNEL_NAME = "yechielvogel.com/sendmessage"
        let messageChannel = FlutterMethodChannel(
            name: METHOD_CHANNEL_NAME,
            binaryMessenger: controller.binaryMessenger
        )
        
        flutterMethodChannel = messageChannel

        messageChannel.setMethodCallHandler({ [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard call.method == "messageComposeViewController" else {
                result(FlutterMethodNotImplemented)
                return
            }
            
            guard let args = call.arguments as? [String: Any],
                  let name = args["name"] as? String,
                  let message = args["message"] as? String // Extract the message parameter
            else {
                result(nil)
                return
            }

            // Call the method to trigger the sending of the message
            self?.sendMessageButtonTapped(recipient: name, message: message) // Pass the message parameter
            
            result(nil)
        })


        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    @objc func sendMessageButtonTapped(recipient: String, message: String) { // Add message parameter
        let messageVC = MFMessageComposeViewController()

        if MFMessageComposeViewController.canSendText() {
            messageVC.delegate = self
            messageVC.messageComposeDelegate = self
            messageVC.body = message // Set the message body
            messageVC.recipients = [recipient]

            guard let rootViewController = window?.rootViewController else {
                return
            }

            rootViewController.present(messageVC, animated: true, completion: nil)
        }
    }

    
    @objc func messageComposeViewController(
        _ controller: MFMessageComposeViewController,
        didFinishWith result: MessageComposeResult
    ) {
        var resultCode: String
        switch result {
        case .cancelled:
            print("Message cancelled")
            resultCode = "3"
        case .failed:
            print("Message failed")
            resultCode = "2"
        case .sent:
            print("Message was sent")
            resultCode = "1"
        }

        controller.dismiss(animated: true, completion: nil)
        flutterMethodChannel?.invokeMethod("messageComposeResult", arguments: resultCode)
    }
    
}
