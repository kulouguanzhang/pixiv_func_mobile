import Flutter
import UIKit
import image_picker

public class SwiftPixivApiPlugin: NSObject, FlutterPlugin {
    private static let pluginName = "xiaocao/platform/api"
    private unowned let window: UIWindow

    public init(window: UIWindow) {
        self.window = window
    }

    /// Abandoned method
    /// - Parameter registrar: registrar...
    public static func register(with registrar: FlutterPluginRegistrar) {
        //won't do anything...
    }

    /// trans [window] to plugin so it can show something on screen..
    /// - Parameters:
    ///   - registrar: FlutterPluginRegistrar
    ///   - window: UIWindow
    public static func register(with registrar: FlutterPluginRegistrar, window: UIWindow) {
        let channel = FlutterMethodChannel(name: pluginName, binaryMessenger: registrar.messenger())
        let instance = SwiftPixivApiPlugin(window: window)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    /// method channel handler
    /// - Parameters:
    ///   - call: FlutterMethodCall
    ///   - result: FlutterResult
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        print("handling----call.method:\(call.method)")
        print("args:\(String(describing: call.arguments))")
        guard let method = Method(rawValue: call.method) else {
            return result(FlutterMethodNotImplemented)
        }
        
        switch (method) {
        case .toast:
            let args = call.arguments as! Dictionary<String, Any>
            if let rootViewController = window.rootViewController {
                rootViewController.showToast(message: args["content"]! as! String, font: .systemFont(ofSize: 12))
                result(true)
            } else {
                result(false)
            }
        case .saveImage:
            let args = call.arguments as! Dictionary<String, Any>
            
            DispatchQueue.global(qos: .userInitiated).async {
                result(SwiftPixivApi.saveImage(imageBytes:( args["imageBytes"] as! FlutterStandardTypedData).data, name: args["filename"] as! String))
            }

        case .saveGifImage:
            let args = call.arguments as! Dictionary<String, Any>
            DispatchQueue.global(qos: .userInitiated).async {
                result(SwiftPixivApi.saveGIF(id: args["id"] as! Int, images: (args["images"] as! FlutterStandardTypedData).data , delays: (args["delays"] as! FlutterStandardTypedData).intArray))
            }

        case .unZipGif:
            let args = call.arguments as! Dictionary<String, Any>
            DispatchQueue.global(qos: .userInitiated).async {
                result(SwiftPixivApi.unZipGif(zipBytes: args["zipBytes"] as! ByteArray))
            }

        case .imageIsExist:
            let args = call.arguments as! Dictionary<String, Any>
            result(SwiftPixivApi.imageIsExist(filename: args["filename"] as! String))

        case .getBuildVersion:

            result(SwiftPixivApi.getBuildVersion())

        case .getAppVersion:

            result(SwiftPixivApi.getAppVersion())

        case .urlLaunch:
            let args = call.arguments as! Dictionary<String, Any>
            result(SwiftPixivApi.urlLaunch(url: args["url"] as! String))

        case .updateApp:
            let args = call.arguments as! Dictionary<String, Any>
            result(SwiftPixivApi.updateApp(url: args["url"] as! String, versionTag: args["versionTag"] as! String))

        }
    }

    private enum Method: String, CaseIterable & Hashable {
        case toast = "toast"
        case saveImage = "saveImage"
        case saveGifImage = "saveGifImage"
        case unZipGif = "unZipGif"
        case imageIsExist = "imageIsExist"
        case getBuildVersion = "getBuildVersion"
        case getAppVersion = "getAppVersion"
        case urlLaunch = "urlLaunch"
        case updateApp = "updateApp"
    }
}


internal class SwiftPixivApi {
    
    /// 根据data保存image
    /// - Parameters:
    ///   - imageBytes: Data
    ///   - name: 保存名
    /// - Returns: Existence
    static func saveImage(imageBytes: Data, name: String) -> NSNumber.BooleanLiteralType {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(name)
        do {
            try imageBytes.write(to: path)
            return true
        } catch {
            print(error)
            return false
        }
    }

    
    /// Incomplete...
    static func `saveGIF`(id: Int, images: Data, delays: Array<Int>) -> NSNumber.BooleanLiteralType {
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(id).gif")
        
        guard let destinaiton = CGImageDestinationCreateWithURL(path as NSURL,kCMMetadataBaseDataType_GIF, images.count, nil) else {
            return false
        }
        //        设置每帧图片播放时间
        let cgimageDic = [kCGImagePropertyGIFDelayTime as String: 0.1]
        let gifDestinaitonDic = [kCGImagePropertyGIFDictionary as String: cgimageDic]
        let length = delays.count
        //添加gif图像的每一帧元素
        for i in 0..<length{
            let imagedata = images[i*length..<(i+1)*length]
            if let cgimage = UIImage(data: imagedata)?.cgImage{
                CGImageDestinationAddImage(destinaiton, cgimage, gifDestinaitonDic as CFDictionary)
            }else{
                return false
            }
        }

        //         设置gif的彩色空间格式、颜色深度、执行次数
        let gifPropertyDic = NSMutableDictionary()
        gifPropertyDic.setValue(kCGImagePropertyColorModelRGB, forKey: kCGImagePropertyColorModel as String)
        gifPropertyDic.setValue(16, forKey: kCGImagePropertyDepth as String)
        gifPropertyDic.setValue(1, forKey: kCGImagePropertyGIFLoopCount as String)

        //设置gif属性
        let gifDicDest = [kCGImagePropertyGIFDictionary as String: gifPropertyDic]
        CGImageDestinationSetProperties(destinaiton, gifDicDest as CFDictionary)

        //生成gif
        return CGImageDestinationFinalize(destinaiton)
    }

    static func unZipGif(zipBytes: ByteArray) -> Array<ByteArray> {
        []
    }

    
    /// 返回文件是否存在
    /// - Parameter filename: 文件名
    /// - Returns: Existence
    static func imageIsExist(filename: String) -> NSNumber.BooleanLiteralType {
        return !FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(filename)").isFileURL
    }

    
    /// 内部版本
    /// - Returns: BundleVersion
    static func getBuildVersion() -> Int {
        Int(Bundle.main.infoDictionary?["CFBundleVersion"] as! String) ?? 0
    }
    
    ///
    /// - Returns: App外部版本
    static func getAppVersion() -> String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }

    //...always false?
    static func updateApp(url: String, versionTag: String) -> NSNumber.BooleanLiteralType {
        false
    }
    
    /// 根据URL启动
    /// - Parameter url: urlString
    /// - Returns: 是否成功
    static func urlLaunch(url: String) -> NSNumber.BooleanLiteralType {
        if let url = URL(string: url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                return false
            }
            return true
        }
        return false
    }
}

extension UIViewController {

    func showToast(message: String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width / 2 - 75, y: view.frame.size.height - 100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
        })

    }

}

