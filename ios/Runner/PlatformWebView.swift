//
//  PlatformWebView.swift
//  Runner
//
//  Created by 夏侯臻 on 2022/1/30.
//

import Foundation
import Flutter
import UIKit
import WebKit
//import PixivLocalReverseProxy

typealias CallBackChannel = FlutterBasicMessageChannel

class PlatformWebView: FlutterPlatformView & NSObject {

    private let webview: WKWebView
    private unowned let messenger: FlutterBinaryMessenger
    
    private let resultChannel:CallBackChannel
    private let progressChannel:CallBackChannel
    private let argumentsOnCreated: Dictionary<String, Any?>
    private let useLocalReverseProxy:Bool
    
    func view() -> UIView {
        webview
    }

    init(messenger: FlutterBinaryMessenger,withFrame frame: CGRect,
         arguments args: Any?) {
        let conf = WKWebViewConfiguration()
        conf.preferences.minimumFontSize = 9.0
        self.messenger = messenger
        
        
        argumentsOnCreated = args as! Dictionary<String, Any?>
        useLocalReverseProxy = argumentsOnCreated["useLocalReverseProxy"] as! Bool
        
//        if(useLocalReverseProxy){
//            PixivLocalReverseProxy.PixivLocalReverseProxyStartServer("12345")
//            conf.addProxyConfig(("127.0.0.1",12345))
//            HttpProxyProtocol.webKitSupport = true
//            HttpProxyProtocol.start(proxyConfig: ("127.0.0.1",12345))
//        }
        
        webview = WKWebView(frame: .zero, configuration:conf )
        
        //setup channel
        resultChannel = FlutterBasicMessageChannel(name: PlatformWebViewFactory.pluginName + "/result", binaryMessenger: messenger, codec: FlutterStandardMessageCodec.sharedInstance())
        progressChannel = FlutterBasicMessageChannel(name: PlatformWebViewFactory.pluginName + "/progress", binaryMessenger: messenger, codec: FlutterStandardMessageCodec.sharedInstance())
        
        super.init()

        //custom...
        webview.navigationDelegate = self
        webview.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
    }
    
    deinit{
//        if(useLocalReverseProxy){
//            HttpProxyProtocol.webKitSupport = false
//            HttpProxyProtocol.stop()
//            PixivLocalReverseProxy.PixivLocalReverseProxyStopServer()
//        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print("now load progress:\(webview.estimatedProgress * 100)")
            progressChannel.sendMessage(Int(webview.estimatedProgress * 100))
        }
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = Method(rawValue: call.method) else {
            return result(FlutterMethodNotImplemented)
        }
        switch method {
        case .loadUrl:
            if let url = URL(string: (call.arguments as! [String: Any?])["url"] as! String) {
                print("load url: \(url)")
                let request = URLRequest(url: url)
//                if HttpProxyProtocol.canInit(with: request){
                    webview.load(request)
//                }
                
            }
        case .reload:
            webview.reload()
            print("reload...")
        }
    }
    
    enum Method: String {
        case loadUrl = "loadUrl"
        case reload = "reload"
    }
}

extension PlatformWebView: WKNavigationDelegate {
    
    
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        guard let serverTrust = challenge.protectionSpace.serverTrust else {

                completionHandler(.performDefaultHandling, nil)
                return
        }
        let credential = URLCredential(trust: serverTrust)
        
        completionHandler(.useCredential, credential)
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request
        let url = request.url
        if "pixiv" == url?.scheme {

            if let host = url?.host, host.contains("account") {
                do {
                    print("send result...")
                    resultChannel.sendMessage(["type": "code", "content": try url?.getQueryStringParameter(key: "code")])
                } catch {
                    
                    print(error)
                }
            }
        }
        decisionHandler(.allow)

    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("evaluateJavaScript...")
        webView.evaluateJavaScript("document.querySelectorAll('input').forEach((current)=>{\n" +
                "            if('password' === current.type){\n" +
                "            current.type='text';\n" +
                "            }\n" +
                "            });")
    }
}
