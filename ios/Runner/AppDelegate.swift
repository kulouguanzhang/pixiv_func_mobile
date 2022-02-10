import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        SwiftPixivApiPlugin.register(with: registrar(forPlugin: "PixivApiPlugin")!, window: window)
        
        PlatformWebViewFactory.register(with: registrar(forPlugin: "PlatformWebViewPlugin")!)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
