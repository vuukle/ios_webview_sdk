//
//  VUAdvertisingView.swift
//  Vuukle
//
//  Created by MAC  on 2/28/17.
//  Copyright © 2017 Alex Chaku. All rights reserved.
//

import UIKit

class VUAdvertisingView: UIView {

  static var sharedInstance: VUAdvertisingView?

  let adsFileName = "VUAdsFile"

  // MARK: - @IBOutlets
  @IBOutlet weak var adsWebView: UIWebView!
  
  // MARK: - Lifecycle
  override func awakeFromNib() {
    super.awakeFromNib()
    
    adsWebView.scrollView.isScrollEnabled = false
    adsWebView.delegate = self
    
    adsWebView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    if let htmlURL = Bundle(for: VUAdvertisingCell.self).url(forResource: adsFileName,
                                                             withExtension:"html") {
      let webviewRequest = URLRequest(url: htmlURL)
      adsWebView.loadRequest(webviewRequest)
      
      getDataFromHTML(htmlURL)
    }
  }
  
  static func instanceFromNib() -> VUAdvertisingView {
    
    let addsView = UINib(nibName: "VUAdvertisingView", bundle: Bundle(for: VUCommentsVC.self)).instantiate(withOwner: nil, options: nil)[0] as! VUAdvertisingView
    
    VUAdvertisingView.sharedInstance = addsView
    
    return addsView
  }
  
  func getDataFromHTML(_ url: URL) {
    
    guard var urlContentString = try? String(contentsOf: url, encoding: .utf8) else {
      return
    }
    
    let articleURL = VUGlobals.requestParametes.articleURL
    urlContentString = urlContentString.replacingOccurrences(of: "[{PAGEURL}]",
                                                             with: articleURL,
                                                             options: .literal)
    let appID = VUGlobals.appName
    urlContentString = urlContentString.replacingOccurrences(of: "[{APPID}]",
                                                             with: appID,
                                                             options: .literal)
    let articleName = VUGlobals.appID
    urlContentString = urlContentString.replacingOccurrences(of: "[{APPNAME}]",
                                                             with: articleName,
                                                             options: .literal)
    let fileName = "\(adsFileName).html"
    
    if let fileDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                               .allDomainsMask, true).first {
      let pathURL = URL(fileURLWithPath: fileDirectory).appendingPathComponent(fileName)
      
      do {
        try urlContentString.write(to: pathURL,
                                   atomically: false,
                                   encoding: String.Encoding.utf8)
      }
      catch {}
    }
  }
  
}


// MARK: - UIWebViewDelegate
extension VUAdvertisingView: UIWebViewDelegate {
  
  func webView(_ webView: UIWebView,
               shouldStartLoadWith request: URLRequest,
               navigationType: UIWebViewNavigationType) -> Bool {
    
    if navigationType == .linkClicked, let adsURL = request.url {
      
      UIApplication.shared.openURL(adsURL)
      return false
    }
    return true
  }
  
}

