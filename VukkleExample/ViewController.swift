//
//  ViewController.swift
//  VukkleExample
//
//  Created by MAC_7 on 12/21/17.
//  Copyright © 2017 MAC_7. All rights reserved.
//

import UIKit
import WebKit

final class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet weak var containerForWKWebView: UIView!
    @IBOutlet weak var containerwkWebViewWithScript: UIView!
    @IBOutlet weak var someTextLabel: UILabel!
    @IBOutlet weak var heightWKWebViewWithScript: NSLayoutConstraint!
    @IBOutlet weak var heightWKWebViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightScrollView: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var wkWebViewWithScript: WKWebView!
    private var wkWebViewWithEmoji: WKWebView!
    private let configuration = WKWebViewConfiguration()
    
    private var isPopUpAppeared = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addWKWebViewForScript()
        addWKWebViewForEmoji()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addWKWebViewForScript() {
        let name = "Alex"
        let email = "email@test.com"
        
        let contentController = WKUserContentController()
        let userScript = WKUserScript(
            source: "signInUser('\(name)', '\(email)')",
            injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
            forMainFrameOnly: true
        )
        contentController.addUserScript(userScript)
        configuration.userContentController = contentController
        
        wkWebViewWithScript = WKWebView(frame: .zero, configuration: configuration)
        wkWebViewWithScript.navigationDelegate = self
        self.containerwkWebViewWithScript.addSubview(wkWebViewWithScript)
        
        wkWebViewWithScript.uiDelegate = self
        
        wkWebViewWithScript.translatesAutoresizingMaskIntoConstraints = false
        
        wkWebViewWithScript.topAnchor.constraint(equalTo: self.containerwkWebViewWithScript.topAnchor).isActive = true
        wkWebViewWithScript.bottomAnchor.constraint(equalTo: self.containerwkWebViewWithScript.bottomAnchor).isActive = true
        wkWebViewWithScript.leftAnchor.constraint(equalTo: self.containerwkWebViewWithScript.leftAnchor).isActive = true
        wkWebViewWithScript.rightAnchor.constraint(equalTo: self.containerwkWebViewWithScript.rightAnchor).isActive = true
        
        let urlString = "https://cdn.vuukle.com/amp.html?apiKey=c7368a34-dac3-4f39-9b7c-b8ac2a2da575&host=smalltester.000webhostapp.com&id=381&img=https://smalltester.000webhostapp.com/wp-content/uploads/2017/10/wallhaven-303371-825x510.jpg&title=Newpost&url=https://smalltester.000webhostapp.com/2017/12/new-post-22#1"
        
        if let url = URL(string: urlString) {
            wkWebViewWithScript.load(URLRequest(url: url))
        }
    }
    
    private func addWKWebViewForEmoji() {
        wkWebViewWithEmoji = WKWebView(frame: .zero, configuration: configuration)
        
        self.containerForWKWebView.addSubview(wkWebViewWithEmoji)
        
        wkWebViewWithEmoji.translatesAutoresizingMaskIntoConstraints = false
        
        wkWebViewWithEmoji.topAnchor.constraint(equalTo: self.containerForWKWebView.topAnchor).isActive = true
        wkWebViewWithEmoji.bottomAnchor.constraint(equalTo: self.containerForWKWebView.bottomAnchor).isActive = true
        wkWebViewWithEmoji.leftAnchor.constraint(equalTo: self.containerForWKWebView.leftAnchor).isActive = true
        wkWebViewWithEmoji.rightAnchor.constraint(equalTo: self.containerForWKWebView.rightAnchor).isActive = true
        
        let urlString = "https://cdn.vuukle.com/widgets/emotes.html?apiKey=c7368a34-dac3-4f39-9b7c-b8ac2a2da575&host=smalltester.000webhostapp.com&articleId=381&img=https://smalltester.000webhostapp.com/wp-content/uploads/2017/10/wallhaven-303371-825x510.jpg&title=New%20post%2022&url=https://smalltester.000webhostapp.com/2017/12/new-post-22#1"
        
        if let url = URL(string: urlString) {
            wkWebViewWithEmoji.load(URLRequest(url: url))
        }
    }
    
    // MARK: - Clear cookie
    
    private func clearAllCookies() {
        let cookieJar = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }
    
    private func clearCookiesFromSpecificUrl(yourUrl: String) {
        let cookieStorage: HTTPCookieStorage = HTTPCookieStorage.shared
        let cookies = cookieStorage.cookies(for: URL(string: yourUrl)!)
        for cookie in cookies! {
            cookieStorage.deleteCookie(cookie as HTTPCookie)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let javascriptString = "var meta = document.createElement('meta'); meta.setAttribute( 'name', 'viewport' ); meta.setAttribute( 'content', 'width = device-width, initial-scale = 1.0, user-scalable = yes' ); document.getElementsByTagName('head')[0].appendChild(meta)"
        webView.evaluateJavaScript(javascriptString, completionHandler: nil)
        
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.offsetHeight", completionHandler: { (height, error) in
                    self.heightWKWebViewWithScript.constant = height as! CGFloat
                })
            }
        })
    }
    
    // MARK: - Show confirm alert
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }

    
    // MARK: - Show authorization tab
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            let popup = WKWebView(frame: self.view.frame, configuration: configuration)
            popup.uiDelegate = self
            self.view.addSubview(popup)
            isPopUpAppeared = true
            return popup
        }
        return nil
    }
    
    // MARK: - Close authorization tab
    
    func webViewDidClose(_ webView: WKWebView) {
        if isPopUpAppeared {
            webView.removeFromSuperview()
        }
    }

}

