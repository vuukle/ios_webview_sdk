//
//  ModalViewController.swift
//  VukkleExample
//
//  Created by user2020 on 4/13/20.
//  Copyright © 2020 MAC_7. All rights reserved.
//

import UIKit
import WebKit
import MessageUI

final class ModalViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet private weak var containerwkWebViewWithScript: UIView!
    @IBOutlet private weak var loadingView: UIView!    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var wkWebViewWithScript: WKWebView!
    private var wkWebViewWithEmoji: WKWebView!
    private let configuration = WKWebViewConfiguration()
    private var originalPosition: CGPoint = CGPoint(x: 0, y: 0)
    
    public var urlToOpen = ""
    
    private var isPopUpAppeared = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.addWKWebViewForScript()
        activityIndicator.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "needToReload"), object: nil)
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
            forMainFrameOnly: false
        )
        contentController.addUserScript(userScript)
        configuration.userContentController = contentController
        configuration.applicationNameForUserAgent = "Version/8.0.2 Safari/600.2.5"
        wkWebViewWithScript = WKWebView(frame: .zero, configuration: configuration)
        wkWebViewWithScript.navigationDelegate = self
        wkWebViewWithScript.allowsBackForwardNavigationGestures = true
        self.containerwkWebViewWithScript.addSubview(wkWebViewWithScript)
        
        wkWebViewWithScript.uiDelegate = self
        
        wkWebViewWithScript.translatesAutoresizingMaskIntoConstraints = false
        
        wkWebViewWithScript.topAnchor.constraint(equalTo: self.containerwkWebViewWithScript.topAnchor).isActive = true
        wkWebViewWithScript.bottomAnchor.constraint(equalTo: self.containerwkWebViewWithScript.bottomAnchor).isActive = true
        wkWebViewWithScript.leftAnchor.constraint(equalTo: self.containerwkWebViewWithScript.leftAnchor).isActive = true
        wkWebViewWithScript.rightAnchor.constraint(equalTo: self.containerwkWebViewWithScript.rightAnchor).isActive = true
        
        let urlString = "https://cdntest.vuukle.com/amp.html?apiKey=c7368a34-dac3-4f39-9b7c-b8ac2a2da575&host=smalltester.000webhostapp.com&id=381&img=https://smalltester.000webhostapp.com/wp-content/uploads/2017/10/wallhaven-303371-825x510.jpg&title=Newpost&url=https://smalltester.000webhostapp.com/2017/12/new-post-22#1"
        
        if let url = URL(string: urlString) {
            wkWebViewWithScript.load(URLRequest(url: url))
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
    
    private func openMailApp(text: String?) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setMessageBody(text ?? "", isHTML: true)
            present(mail, animated: true)
        }
    }
    
    private func openMessenger(with url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:], completionHandler: {
                (success) in
                if success == false {
                    guard let url = URL(string: "https://apps.apple.com/us/app/messenger/id454638411") else { return }
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            })
        }
    }
    var isLoaded = false
    private func configureAuthorisation() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            
            if let url = URL(string: self.urlToOpen) {
                
                let urlRequest = URLRequest(url: url)
                self.wkWebViewWithScript.load(urlRequest)
                self.isLoaded = true
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let javascriptString = "var meta = document.createElement('meta'); meta.setAttribute( 'name', 'viewport' ); meta.setAttribute( 'content', 'width = device-width, initial-scale = 1.0, user-scalable = yes' ); document.getElementsByTagName('head')[0].appendChild(meta)"
        webView.evaluateJavaScript(javascriptString, completionHandler: nil)
        
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.offsetHeight")
            }
        })
      
        if !isLoaded {
            
            configureAuthorisation()
        } else {
            
            self.loadingView.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        false
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
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            let popup = WKWebView(frame: self.view.frame, configuration: configuration)
            popup.uiDelegate = self
            popup.navigationDelegate = self
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            popup.addGestureRecognizer(panGesture)
            popup.allowsBackForwardNavigationGestures = true
            self.view.addSubview(popup)
            isPopUpAppeared = true
            return popup
        }
        return nil
    }
    
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url?.relativeString, url.contains("mailto") {
            let urlComponents = URLComponents(string: url)
            openMailApp(text: urlComponents?.queryItems?.last?.value)
        } else if let url = navigationAction.request.url?.relativeString, url.contains("fb-messenger") {
            openMessenger(with: url)
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    
            if let url = navigationAction.request.url?.relativeString {
            
                if url.contains("urth=Excited&fifth=Angry&sixth=Sad&darkMode=false&commentsEnabled=true") {
                
                    
                
            }
        }
    }
    
    // MARK: - Close authorization tab
    
    func webViewDidClose(_ webView: WKWebView) {
        if isPopUpAppeared {
            webView.removeFromSuperview()
        }
    }
}

extension ModalViewController {
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard let lastWebView = self.view.subviews.last as? WKWebView else { return }
        guard self.isPopUpAppeared && (lastWebView.backForwardList.backItem == nil) else { return }
        let touchPoint = sender.location(in: lastWebView.window)
        let percent = max(sender.translation(in: lastWebView).x, 0) / lastWebView.frame.width
        let velocity = sender.velocity(in: lastWebView).x
        
        if sender.state == UIGestureRecognizer.State.began {
            originalPosition = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.x - originalPosition.x > 0 {
                lastWebView.frame = CGRect(x: touchPoint.x - originalPosition.x, y: 0, width: lastWebView.frame.size.width, height: lastWebView.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if percent > 0.5 || velocity > 500 {
                lastWebView.removeFromSuperview()
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    lastWebView.frame = CGRect(x: 0, y: 0, width: lastWebView.frame.size.width, height: lastWebView.frame.size.height)
                })
            }
        }
    }
}
