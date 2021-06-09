//
//  ViewController.swift
//  VukkleExample
//
//  Created by MAC_7 on 12/21/17.
//  Copyright © 2017 MAC_7. All rights reserved.

import UIKit
import WebKit
import AVFoundation
import MessageUI

final class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var containerwkWebViewWithScript: UIView!
    @IBOutlet weak var containerForTopPowerBar: UIView!
    
    @IBOutlet weak var containerTopPowerBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightWKWebViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightScrollView: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var wkWebViewWithScript: WKWebView!
    private var wkWebViewWithEmoji: WKWebView!
    private var wkWebViewForTopPowerBar: WKWebView!
    private var wkWebViewForBottonPowerBar: WKWebView!
    
    private let configuration = WKWebViewConfiguration()
    private var scriptWebViewHeight: CGFloat = 0
    var newWebviewPopupWindow: WKWebView?
    var isKeyboardOpened = false
    let name = "Ross"
    let email = "email@sda"
    
    private var isWkWebViewWithScriptCreated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "VUUKLE"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
        setWKWebViewConfigurations()
        addNewButtonsOnNavigationBar()
        configureWebView()
        askCameraAccess()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isWkWebViewWithScriptCreated {
            wkWebViewForTopPowerBar.reload()
            configureWKWebViewWithScript()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isWkWebViewWithScriptCreated = true
    }
    
    @objc func loginBySSOTapped() {
        loginBySSO(email: "sometempmail@yopmail.com", username: "Sample User Name")
    }
    
    @objc func logoutTapped() {
        UserDefaults.standard.removeObject(forKey: "loginToken")
        removeCookies()
        let urlString = VUUKLE_IFRAME
        if let url = URL(string: urlString) {
            wkWebViewWithScript.load(URLRequest(url: url))
        }
    }
    
    func addNewButtonsOnNavigationBar() {
        
        let login = UIBarButtonItem(title: "LOGIN", style: .plain, target: self, action: #selector(loginBySSOTapped))
        login.setBackgroundImage(UIImage(named: "dark_gray"), for: .normal, barMetrics: .default)
        login.setTitleTextAttributes([
                                        NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
                                        NSAttributedStringKey.foregroundColor: UIColor.white],
                                     for: .normal)
        let logout = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logoutTapped))
        logout.setBackgroundImage(UIImage(named: "dark_gray"), for: .normal, barMetrics: .default)
        logout.setTitleTextAttributes([
                                        NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
                                        NSAttributedStringKey.foregroundColor: UIColor.white],
                                      for: .normal)
        
        logout.tintColor = .white
        
        navigationItem.rightBarButtonItems = [logout, login]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > 10 {
            self.containerTopPowerBarTopConstraint.constant = -100
            self.view.setNeedsLayout()
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.containerTopPowerBarTopConstraint.constant = 10
            self.view.setNeedsLayout()
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // Set wkwebview configurations
    private func setWKWebViewConfigurations() {
        let thePreferences = WKPreferences()
        thePreferences.javaScriptCanOpenWindowsAutomatically = true
        thePreferences.javaScriptEnabled = true
        configuration.preferences = thePreferences
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"
        
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController: WKUserContentController = WKUserContentController()
        
        userContentController.addUserScript(script)
        configuration.userContentController = userContentController
        configuration.processPool = WKProcessPool()
        let cookies = HTTPCookieStorage.shared.cookies ?? [HTTPCookie]()
        cookies.forEach({ if #available(iOS 11.0, *) {
            configuration.websiteDataStore.httpCookieStore.setCookie($0, completionHandler: nil)
        }
        })
    }
    
    func removeCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("All cookies deleted")
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("Cookie ::: \(record) deleted")
            }
        }
    }
    
    @objc func configureWebView() {
        addWKWebViewForScript()
        addWKWebViewForTopPowerBar()
    }
    
    //Hide keyboard
    @objc func keyboardHide() {
        //Code the lines to hide the keyboard and the extra lines you want to execute before keyboard hides.
        self.perform(#selector(keyboardHided), with: nil, afterDelay: 1)
    }
    
    @objc func keyboardHided() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.wkWebViewForTopPowerBar.reload()
        }
        isKeyboardOpened = false
    }
    
    //Show keyboard
    @objc func keyboardShow() {
        //Code the lines you want to execute before keyboard pops up.
        isKeyboardOpened = true
    }
    
    
    // Ask permission to use camera For adding photo in the comment box
    func askCameraAccess() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                // access granted
            } else {
                // access not granted
            }
        }
    }
    
    // Create WebView for Comment Box
    private func addWKWebViewForScript() {
        
        let thePreferences = WKPreferences()
        thePreferences.javaScriptCanOpenWindowsAutomatically = true
        thePreferences.javaScriptEnabled = true
        configuration.preferences = thePreferences
        
        wkWebViewWithScript = WKWebView(frame: .zero, configuration: configuration)
        wkWebViewWithScript.navigationDelegate = self
        wkWebViewWithScript.uiDelegate = self
        self.containerwkWebViewWithScript.addSubview(wkWebViewWithScript)
        
        configureWKWebViewWithScript()
        
    }
    
    private func configureWKWebViewWithScript() {
        
        wkWebViewWithScript.translatesAutoresizingMaskIntoConstraints = false
        
        wkWebViewWithScript.scrollView.delegate = self
        
        wkWebViewWithScript.topAnchor.constraint(equalTo: self.containerwkWebViewWithScript.topAnchor).isActive = true
        wkWebViewWithScript.bottomAnchor.constraint(equalTo: self.containerwkWebViewWithScript.bottomAnchor).isActive = true
        wkWebViewWithScript.leftAnchor.constraint(equalTo: self.containerwkWebViewWithScript.leftAnchor).isActive = true
        wkWebViewWithScript.rightAnchor.constraint(equalTo: self.containerwkWebViewWithScript.rightAnchor).isActive = true
        
        wkWebViewWithScript.isMultipleTouchEnabled = false
        wkWebViewWithScript.contentMode = .scaleAspectFit
        wkWebViewWithScript.scrollView.bouncesZoom = false
        
        var urlString = VUUKLE_IFRAME
        if let loginToken = UserDefaults.standard.string(forKey: "loginToken") {
            urlString += "&sso=true&loginToken=\(loginToken)"
        }
        if let url = URL(string: urlString) {
            
            let userAgent = USER_AGENT
            var myURLRequest = URLRequest(url: url)
            myURLRequest.setValue(userAgent, forHTTPHeaderField:"user-agent")
            wkWebViewWithScript.load(myURLRequest)
        }
    }
    
    // Create WebView for Top PowerBar
    private func addWKWebViewForTopPowerBar() {
        
        wkWebViewForTopPowerBar = WKWebView(frame: .zero, configuration: configuration)
        self.containerForTopPowerBar.addSubview(wkWebViewForTopPowerBar)
        
        wkWebViewForTopPowerBar.translatesAutoresizingMaskIntoConstraints = false
        wkWebViewForTopPowerBar.topAnchor.constraint(equalTo: self.containerForTopPowerBar.topAnchor).isActive = true
        wkWebViewForTopPowerBar.bottomAnchor.constraint(equalTo: self.containerForTopPowerBar.bottomAnchor).isActive = true
        wkWebViewForTopPowerBar.leftAnchor.constraint(equalTo: self.containerForTopPowerBar.leftAnchor).isActive = true
        wkWebViewForTopPowerBar.rightAnchor.constraint(equalTo: self.containerForTopPowerBar.rightAnchor).isActive = true
        wkWebViewForTopPowerBar.uiDelegate = self
        wkWebViewForTopPowerBar.navigationDelegate = self
        wkWebViewForTopPowerBar.scrollView.isScrollEnabled = false
        
        if let url = URL(string: VUUKLE_POWERBAR) {
            wkWebViewForTopPowerBar.load(URLRequest(url: url))
        }
    }
    
    // Create WebView for Bottom PowerBar
    private func addWKWebViewForBottomPowerBar() {
        
        wkWebViewForBottonPowerBar = WKWebView(frame: .zero, configuration: configuration)

        wkWebViewForBottonPowerBar.translatesAutoresizingMaskIntoConstraints = false
        wkWebViewForBottonPowerBar.uiDelegate = self
        wkWebViewForBottonPowerBar.navigationDelegate = self
        if let url = URL(string: VUUKLE_POWERBAR) {
            wkWebViewForBottonPowerBar.load(URLRequest(url: url))
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
    
    private func openNewWindow(newURL: String, openWindow: Bool = false) {
        for url in VUUKLE_URLS {
            if newURL.hasPrefix(VUUKLE_MAIL_SHARE) {
                let mailSubjectBody = parsMailSubjextAndBody(mailto: newURL)
                sendEmail(subject: mailSubjectBody.subject, body: mailSubjectBody.body)
                return
            } else if newURL.hasPrefix(VUUKLE_WHATSAPP_SHARE) {
                let appURL = URL(string: newURL)!
                if UIApplication.shared.canOpenURL(appURL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                    }
                    else {
                        UIApplication.shared.openURL(appURL)
                    }
                }
                return
            } else if newURL.hasPrefix(VUUKLE_MESSENGER_SHARE) {
                let messengerUrlString = replaceLinkSymboles(text: newURL)
                guard let messengerUrl = URL(string: messengerUrlString) else { return }
                UIApplication.shared.open(messengerUrl)
                return
            } else if newURL.hasPrefix(url) {
                wkWebViewWithScript.load(URLRequest(url: URL(string: "about:blank")!))
                print("current opening url:\(newURL)")
                self.openNewsWindow(withURL: newURL)
                return
            } else {
                if openWindow {
                    self.openNewsWindow(withURL: newURL)
                }
                
                return
            }
        }
    }
    
    // MARK: - WKUIDelegate methods
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        present(alertController, animated: true)
        alertController.addTextField(configurationHandler: nil)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            completionHandler(nil)
        }))
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (okAction) in
            completionHandler(alertController.textFields?.first?.text)
        }))
    }
    
    func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
        let vc = UIViewController()
        return vc
    }
    
    @available(iOS 13.0, *)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        
        print("URL :\(navigationAction.request.url?.absoluteString ?? "")")
        if navigationAction.request.url?.absoluteString == VUUKLE_SETTINGS {
            self.openNewWindow(newURL: VUUKLE_SETTINGS, openWindow: true)
        } else if (navigationAction.request.url?.absoluteString ?? "").hasPrefix(VUUKLE_MAIL_TO_SHARE) {
            let mailSubjectBody = parsMailSubjextAndBody(mailto: navigationAction.request.url?.absoluteString ?? "")
            sendEmail(subject: mailSubjectBody.subject, body: mailSubjectBody.body)
        } else if (navigationAction.request.url?.absoluteString ?? "").hasPrefix(VUUKLE_MESSENGER_SHARE) {
            openNewWindow(newURL: navigationAction.request.url?.absoluteString ?? "", openWindow: true)
        }
        decisionHandler(WKNavigationActionPolicy.allow, preferences)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return true
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        webView.evaluateJavaScript("window.open = function(open) { return function (url, name, features) { window.location.href = url; return window; }; } (window.open);", completionHandler: nil)
        
        
        webView.evaluateJavaScript("window.close = function() { window.location.href = 'myapp://closewebview'; }", completionHandler: nil)
        print( navigationAction.request.url?.absoluteString )
        openNewWindow(newURL: navigationAction.request.url?.absoluteString ?? "", openWindow: true)
        
        return nil
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        
        //        self.heightWKWebViewWithScript.constant = scriptWebViewHeight
        if navigationAction.navigationType == .linkActivated {
            openNewWindow(newURL: navigationAction.request.url?.absoluteString ?? "", openWindow: true)
            decisionHandler(.allow)
            return
        } else if navigationAction.navigationType == .other {
            openNewWindow(newURL: navigationAction.request.url?.absoluteString ?? "") //, openWindow: true)
        }
        decisionHandler(.allow)
        return
    }
    
    func openNewsWindow(withURL: String) {
        let newsWindow = VuukleNewViewController()
        newsWindow.wkWebView = self.wkWebViewWithScript
        newsWindow.configuration = self.configuration
        newsWindow.urlString = withURL
        
        self.navigationController?.pushViewController(newsWindow, animated: true)
    }
    
    private func loginBySSO(email: String, username: String) {
        let authModel = AuthenticationModel(email: email, username: username)
        
        do {
            let authModelData = try JSONEncoder().encode(authModel).base64EncodedString()
            UserDefaults.standard.setValue(authModelData, forKey: "loginToken")
            let urlString = VUUKLE_IFRAME + "&sso=true&loginToken=" + (UserDefaults.standard.string(forKey: "loginToken") ?? "")
            if let url = URL(string: urlString) {
                wkWebViewWithScript.load(URLRequest(url: url))
            }
        } catch {
            
        }
    }
}

// MARK: - SEND EMAIL Metods
extension ViewController: MFMailComposeViewControllerDelegate {
    
    func sendEmail(subject: String, body: String) {
        let recipientEmail = ""
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            present(mail, animated: true)
            
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            let newMailto = (emailUrl.absoluteString).replacingOccurrences(of: "%20", with: "")
            UIApplication.shared.open(URL(string: newMailto)!)
        }
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        return defaultUrl
    }
    
    // Get Subject and Body from mailto url.
    func parsMailSubjextAndBody(mailto: String) -> (subject: String, body: String) {
        
        let newMailto = replaceLinkSymboles(text: mailto)
        
        let subjectStartIndex = newMailto.firstIndex(of: "=")!
        let subjectEndIndex = newMailto.firstIndex(of: "&")!
        var subject = String(newMailto[subjectStartIndex..<subjectEndIndex])
        let bodyStartIndex = newMailto.lastIndex(of: "=")!
        var body = String(newMailto[bodyStartIndex...])
        subject.removeFirst()
        body.removeFirst()
        
        return (subject: subject, body: body)
    }
    
    func replaceLinkSymboles(text: String) -> String {
        var newText = text.replacingOccurrences(of: "%20", with: " ")
        newText = newText.replacingOccurrences(of: "%3A", with: ":")
        newText = newText.replacingOccurrences(of: "%2F", with: "/")
        return newText
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
