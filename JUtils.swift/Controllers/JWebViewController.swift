//
//  JWebViewController.swift
//  JUtils_swift
//
//  Created by jiangliang on 2018/4/21.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit
import WebKit

class JWebViewController: UIViewController, WKNavigationDelegate {

    var url: String?
    
    private var webView: WKWebView?
    
    deinit {
        JHud.hide()
        self.destroyWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: self.view.bounds)
        webView?.backgroundColor = UIColor.clear
        webView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView?.navigationDelegate = self
        self.view.addSubview(webView!)
        
        if let u = url {
            let request = URLRequest(url: URL(string: u)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20)
            webView?.load(request)
        } else {
            JHud.show(content: "url未提供")
        }
    }
    
    @objc func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func destroyWebView() {
        if let _ = webView {
            webView?.stopLoading()
            URLCache.shared.removeAllCachedResponses()
            webView?.navigationDelegate = nil
            webView = nil
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        JHud.showHudView(inView: self.view, lock: false)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        JHud.hide()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        JHud.show(content: error.localizedDescription)
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        JHud.hide()
    }
    
}


