//
//  VuukleNewsViewController.swift
//  VukkleExample
//
//  Created by Nrek Dallakyan on 11/22/20.
//  Copyright © 2020 MAC_7. All rights reserved.
//

import UIKit
import WebKit

class VuukleNewViewController: UIViewController {
    
    var wkWebView: WKWebView!
    var configuration = WKWebViewConfiguration()
    var activityView = UIActivityIndicatorView()
    
    var urlString = ""
    var isLoadedSettings = false
    var backButton: UIBarButtonItem?
    var forwardButton: UIBarButtonItem?
    var cookies: [HTTPCookie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addWKWebView()
        addNewButtonsOnNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        edgesForExtendedLayout = []
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        wkWebView.scrollView.removeObserver(self, forKeyPath: "contentSize", context: nil)
//    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        NotificationCenter.default.post(name: NSNotification.Name("updateWebViews"), object: nil)
//    }
    
    func addNewButtonsOnNavigationBar() {
        
        self.navigationController?.setToolbarHidden(true, animated: true)
        if #available(iOS 13.0, *) {
            let backButton = UIBarButtonItem(
                image: UIImage(systemName: "arrow.left")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
                style: .plain,
                target: self.wkWebView,
                action: #selector(WKWebView.goBack))
            self.backButton = backButton
        } else {
             let backButton = UIBarButtonItem(
                image: UIImage(named: "arrow-left")?.withRenderingMode(.alwaysTemplate),
                style: .plain,
                target: self.wkWebView,
                action: #selector(WKWebView.goBack))
            self.backButton = backButton
        }
        if #available(iOS 13.0, *) {
            let forwardButton = UIBarButtonItem(
                image: UIImage(systemName: "arrow.right")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
                style: .plain,
                target: self.wkWebView,
                action: #selector(WKWebView.goForward))
            
            self.forwardButton = forwardButton
        } else {
            let forwardButton = UIBarButtonItem(
                image: UIImage(named: "arrow-right")?.withRenderingMode(.alwaysTemplate),
                style: .plain,
                target: self.wkWebView,
                action: #selector(WKWebView.goForward))
            self.forwardButton = forwardButton
        }
        navigationItem.rightBarButtonItems = [self.forwardButton!, self.backButton!]
    }
    
    @objc func configureWebView() {
        wkWebView.reload()
    }
    
    private func addWKWebView() {
        
        let config = WKWebViewConfiguration()
        config.processPool = WKProcessPool()
        let cookies = HTTPCookieStorage.shared.cookies ?? [HTTPCookie]()
        cookies.forEach({ if #available(iOS 11.0, *) {
            config.websiteDataStore.httpCookieStore.setCookie($0, completionHandler: nil)
        } })
        config.applicationNameForUserAgent = "Version/8.0.2 Safari/600.2.5"
        
        let navBarHeight = UIApplication.shared.statusBarFrame.size.height +
                 (navigationController?.navigationBar.frame.height ?? 0.0)
        let safeAreaHeight = self.view.frame.height - navBarHeight
        print(safeAreaHeight)
        
        wkWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: safeAreaHeight), configuration: config)
        self.view.addSubview(wkWebView)
        
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        self.wkWebView.isHidden = true
        self.view.backgroundColor = .white
        
        if urlString == VUUKLE_SETTINGS {
            isLoadedSettings = true
        } else {
            isLoadedSettings = false
        }
        if let url = URL(string: urlString) {
            
            let userAgent = USER_AGENT
            var myURLRequest = URLRequest(url: url)
            myURLRequest.setValue(userAgent, forHTTPHeaderField:"user-agent")
            wkWebView.load(myURLRequest)
        }
        
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.isHidden = false
        activityView.startAnimating()
    }
}

extension VuukleNewViewController:  WKNavigationDelegate, WKUIDelegate  {
    
    // MARK: WKNavigationDelegate methods
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityView.isHidden = true
        activityView.stopAnimating()
        self.wkWebView.isHidden = false
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.offsetHeight", completionHandler: { (height, error) in
                    
                })
            }
        })
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
    
        webView.load(navigationAction.request)
        webView.evaluateJavaScript("window.open = function(open) { return function (url, name, features) { window.location.href = url; return window; }; } (window.open);", completionHandler: nil)
        webView.evaluateJavaScript("window.close = function() { window.location.href = 'myapp://closewebview'; }", completionHandler: nil)
        return nil
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        present(alertController, animated: true)
        alertController.addTextField(configurationHandler: nil)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (okAction) in
            completionHandler(alertController.textFields?.first?.text)
        }))
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        
        if navigationAction.navigationType == .other {
            if (navigationAction.request.url?.absoluteString.contains(VUUKLE_SOCIAL_LOGIN_SUCCESS))! {
                if isLoadedSettings {
                    wkWebView.goBack()
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }

        decisionHandler(.allow)
        return
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            guard let serverTrust = challenge.protectionSpace.serverTrust else { return completionHandler(.useCredential, nil) }
            let exceptions = SecTrustCopyExceptions(serverTrust)
            SecTrustSetExceptions(serverTrust, exceptions)
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        }
   
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return true
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        completionHandler(true)
    }
}



