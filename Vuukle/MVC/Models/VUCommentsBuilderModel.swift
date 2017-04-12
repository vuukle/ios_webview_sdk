//
//  VUCommentsBuilderModel.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit


class VUCommentsBuilderModel {
  
  private init() { }
  
  // MARK: - Class variables
  static weak var vContentView: UIView?
  static weak var vEmojiView  : UIView?
  static weak var vTopArticle : UIView?
  static weak var vAddsView   : UIView?
    
  static weak var vBaseVC: UIViewController?
  static weak var vScrollView: UIScrollView?
    
  static weak var vWebView: UIWebView?
  static weak var vWebViewHeightConstraint: NSLayoutConstraint?
    
  static weak var vContentViewHieghtConstraint   : NSLayoutConstraint?
  static weak var vEmojiViewHieghtConstraint     : NSLayoutConstraint?
  static weak var vTopArticleViewHieghtConstraint: NSLayoutConstraint?
  static weak var vAdsHieghtConstraint: NSLayoutConstraint?

  
  // MARK: - LAUNCH: Setting aditional parameters in "addVuukleComments" method
  static var isCommentScrollEnabled: Bool {
    set {
      if let tableView = VUCommentsVC.sharedInstance.tableView {
        
        VUGlobals.isCommentsScrollEnabled = newValue
        tableView.isScrollEnabled = newValue
      }
    }
    get {
      if let tableView = VUCommentsVC.sharedInstance.tableView {
        return tableView.isScrollEnabled
      }
      return false
    }
  }
  
  static var vuukleEdgeInserts: UIEdgeInsets {
    set {
      if let tableView = VUCommentsVC.sharedInstance.tableView {
        tableView.contentInset = newValue
      }
    }
    get {
      if let tableView = VUCommentsVC.sharedInstance.tableView {
        return tableView.contentInset
      }
      return VUGlobals.defaultEdgeInserts
    }
  }

  
  // MARK: - REQUIRED: Method to add Vuukle Comments
  static func loadVuukleComments(baseVC: UIViewController,
                                 contentView: UIView,
                                 apiKey: String,
                                 secretKey: String,
                                 host: String,
                                 timeZone: String,
                                 articleID: String,
                                 articleTitle: String,
                                 articleURL: String,
                                 articleTag: String,
                                 appName: String?,
                                 appID: String?) {
    
    var apiKey = apiKey, secretKey = secretKey, host = host
    if VUParametersChecker.checkCommentsBuilder(apiKey: &apiKey,
                                                secretKey: &secretKey,
                                                host: &host) == false {
      
      addFailureSubviewTo(contentView, errorMessage: VUGlobals.errorFlag)
      return
    }
    
    var timeZone = timeZone
    if VUParametersChecker.checkCommentsBuilder(timeZone: &timeZone) == false {
      
      addFailureSubviewTo(contentView, errorMessage: VUGlobals.errorFlag)
      return
    }
    
    var articleID = articleID, articleTitle = articleTitle, articleURL = articleURL
    if VUParametersChecker.checkCommentsBuilder(articleID: &articleID,
                                                articleTitle: &articleTitle,
                                                articleURL: &articleURL) == false {
      
      addFailureSubviewTo(contentView, errorMessage: VUGlobals.errorFlag)
      return
    }
    
    if VUGlobals.isVuukleAdsHiden == false && appName == nil {
      addFailureSubviewTo(contentView, errorMessage: "Empty App Name")
      return
    }
    
    if VUGlobals.isVuukleAdsHiden == false && appID == nil {
      addFailureSubviewTo(contentView, errorMessage: "Emplty App ID")
      return
    }
    
    if var appName = appName, var appID = appID {
      if VUParametersChecker.checkCommentsBuilder(appName: &appName,
                                                  appID: &appID) == false {
        
        addFailureSubviewTo(contentView, errorMessage: VUGlobals.errorFlag)
        return
        
      } else {
        
        guard let encodedAppName = appName.jsonEncoded() else {
          
          addFailureSubviewTo(contentView,
                              errorMessage: "Can't encode App ID")
          return
        }
        
        guard let encodedAppID = appID.jsonEncoded() else {
          
          addFailureSubviewTo(contentView,
                              errorMessage: "Can't encode App Name")
          return
        }
        
        VUGlobals.appName = encodedAppName
        VUGlobals.appID = encodedAppID
      }
    }
    
    if VUInternetChecker.isOnline == false {
      addFailureSubviewTo(contentView, errorMessage: "Vuukle is Offline")
      return
    }
    
    guard let encodedApiKey = apiKey.jsonEncoded() else {
      addFailureSubviewTo(contentView,
                          errorMessage: "Can't encode Api Key")
      return
    }
    
    guard let encodedSecretKey = secretKey.jsonEncoded() else {
      addFailureSubviewTo(contentView,
                          errorMessage: "Can't encode Secret Key")
      return
    }
    
    guard let encodedHost = host.jsonEncoded() else {
      addFailureSubviewTo(contentView,
                          errorMessage: "Can't encode Host")
      return
    }
    
    guard let encodedTimeZone = timeZone.jsonEncoded() else {
      addFailureSubviewTo(contentView,
                          errorMessage: "Can't encode Time Zone")
      return
    }
    
    guard let encodedArticleTitle = articleTitle.jsonEncoded() else {
      addFailureSubviewTo(contentView,
                          errorMessage: "Can't encode Article Title")
      return
    }
    
    guard let encodedArticleID = articleID.jsonEncoded() else {
      addFailureSubviewTo(contentView,
                          errorMessage: "Can't encode Article ID")
      return
    }
    
    guard let encodedArticleTag = articleTag.jsonEncoded() else {
      addFailureSubviewTo(contentView,
                          errorMessage: "Can't encode Article Tag")
      return
    }
    
    guard let encodedArticleURL = articleURL.jsonEncoded() else {
      addFailureSubviewTo(contentView,
                          errorMessage: "Can't encode Article URL")
      return
    }
    
    VUGlobals.requestParametes.vuukleApiKey = encodedApiKey
    VUGlobals.requestParametes.vuukleSecretKey = encodedSecretKey
    VUGlobals.requestParametes.vuukleHost = encodedHost
    VUGlobals.requestParametes.vuukleTimeZone = encodedTimeZone
    
    VUGlobals.requestParametes.articleTitle = encodedArticleTitle
    VUGlobals.requestParametes.articleID = encodedArticleID
    VUGlobals.requestParametes.articleTag = encodedArticleTag
    VUGlobals.requestParametes.articleURL = encodedArticleURL
 
    addVuukleCommentsSubviewTo(contentView)
  }
  
  static func loadVuukleEmoji(emojiContentView: UIView,
                              apiKey: String,
                              secretKey: String,
                              host: String,
                              articleTitle: String,
                              articleID: String,
                              articleURL: String) {
   
    var apiKey = apiKey, secretKey = secretKey, host = host
    if VUParametersChecker.checkCommentsBuilder(apiKey: &apiKey,
                                                secretKey: &secretKey,
                                                host: &host) == false {
      
      addFailureSubviewTo(emojiContentView, errorMessage: VUGlobals.errorFlag)
      return
    }
    
    var articleID = articleID, articleTitle = articleTitle, articleURL = articleURL
    if VUParametersChecker.checkCommentsBuilder(articleID: &articleID,
                                                articleTitle: &articleTitle,
                                                articleURL: &articleURL) == false {
      
      addFailureSubviewTo(emojiContentView, errorMessage: VUGlobals.errorFlag)
      return
    }
    
    if VUInternetChecker.isOnline == false {
      addFailureSubviewTo(emojiContentView, errorMessage: "Vuukle is Offline")
      return
    }
    
    guard let encodedApiKey = apiKey.jsonEncoded() else {
      addFailureSubviewTo(emojiContentView,
                          errorMessage: "Can't encode Api Key")
      return
    }
    
    guard let encodedSecretKey = secretKey.jsonEncoded() else {
      addFailureSubviewTo(emojiContentView,
                          errorMessage: "Can't encode Secret Key")
      return
    }
    
    guard let encodedHost = host.jsonEncoded() else {
      addFailureSubviewTo(emojiContentView,
                          errorMessage: "Can't encode Host")
      return
    }
    guard let encodedArticleTitle = articleTitle.jsonEncoded() else {
      addFailureSubviewTo(emojiContentView,
                          errorMessage: "Can't encode Article Title")
      return
    }
    
    guard let encodedArticleID = articleID.jsonEncoded() else {
      addFailureSubviewTo(emojiContentView,
                          errorMessage: "Can't encode Article ID")
      return
    }
    
    guard let encodedArticleURL = articleURL.jsonEncoded() else {
      addFailureSubviewTo(emojiContentView,
                          errorMessage: "Can't encode Article URL")
      return
    }
    
    VUGlobals.requestParametes.vuukleApiKey = encodedApiKey
    VUGlobals.requestParametes.vuukleSecretKey = encodedSecretKey
    VUGlobals.requestParametes.vuukleHost = encodedHost
    
    VUGlobals.requestParametes.articleTitle = encodedArticleTitle
    VUGlobals.requestParametes.articleURL = encodedArticleURL
    VUGlobals.requestParametes.articleID = encodedArticleID
    
    addVuukleEmojiSubviewTo(emojiContentView)
  }
  
  static func loadVuukleTopArticle(baseVC: UIViewController,
                                   topArticleContentView: UIView,
                                   apiKey: String,
                                   secretKey: String,
                                   host: String,
                                   articleTitle: String,
                                   articleID: String,
                                   articleURL: String) {
    
    var apiKey = apiKey, secretKey = secretKey, host = host
    if VUParametersChecker.checkCommentsBuilder(apiKey: &apiKey,
                                                secretKey: &secretKey,
                                                host: &host) == false {
      
      addFailureSubviewTo(topArticleContentView, errorMessage: VUGlobals.errorFlag)
      return
    }
    
    var articleID = articleID, articleTitle = articleTitle, articleURL = articleURL
    if VUParametersChecker.checkCommentsBuilder(articleID: &articleID,
                                                articleTitle: &articleTitle,
                                                articleURL: &articleURL) == false {
      
      addFailureSubviewTo(topArticleContentView, errorMessage: VUGlobals.errorFlag)
      return
    }
    
    if VUInternetChecker.isOnline == false {
      addFailureSubviewTo(topArticleContentView, errorMessage: "Vuukle is Offline")
      return
    }
    
    guard let encodedApiKey = apiKey.jsonEncoded() else {
      addFailureSubviewTo(topArticleContentView,
                          errorMessage: "Can't encode Api Key")
      return
    }
    
    guard let encodedSecretKey = secretKey.jsonEncoded() else {
      addFailureSubviewTo(topArticleContentView,
                          errorMessage: "Can't encode Secret Key")
      return
    }
    
    guard let encodedHost = host.jsonEncoded() else {
      addFailureSubviewTo(topArticleContentView,
                          errorMessage: "Can't encode Host")
      return
    }
    guard let encodedArticleTitle = articleTitle.jsonEncoded() else {
      addFailureSubviewTo(topArticleContentView,
                          errorMessage: "Can't encode Article Title")
      return
    }
    
    guard let encodedArticleID = articleID.jsonEncoded() else {
      addFailureSubviewTo(topArticleContentView,
                          errorMessage: "Can't encode Article ID")
      return
    }
    
    guard let encodedArticleURL = articleURL.jsonEncoded() else {
      addFailureSubviewTo(topArticleContentView,
                          errorMessage: "Can't encode Article URL")
      return
    }
    
    VUGlobals.requestParametes.vuukleApiKey = encodedApiKey
    VUGlobals.requestParametes.vuukleSecretKey = encodedSecretKey
    VUGlobals.requestParametes.vuukleHost = encodedHost
    
    VUGlobals.requestParametes.articleTitle = encodedArticleTitle
    VUGlobals.requestParametes.articleURL = encodedArticleURL
    VUGlobals.requestParametes.articleID = encodedArticleID
    
    addVuukleTopArticleSubviewTo(topArticleContentView)
  }

  
  static func loadVuukleAdds(addsContentView: UIView,
                             appName: String,
                             appID: String,
                             articleURL: String) {
    
    var appName = appName, appID = appID
    if VUParametersChecker.checkCommentsBuilder(appName: &appName,
                                                appID: &appID) == false {
      
      addFailureSubviewTo(addsContentView,
                          errorMessage: VUGlobals.errorFlag)
      return
    }
    
    if VUParametersChecker.checkTextContaintsURL(articleURL) == nil {
      
      addFailureSubviewTo(addsContentView,
                          errorMessage: "Invalide Article URL")
      return
    }
    
    guard let encodedAppName = appName.jsonEncoded() else {
      
      addFailureSubviewTo(addsContentView,
                          errorMessage: "Can't encode App ID")
      return
    }
    
    guard let encodedAppID = appID.jsonEncoded() else {
     
      addFailureSubviewTo(addsContentView,
                          errorMessage: "Can't encode App Name")
      return
    }
    
    guard let encodedArticleURL = articleURL.jsonEncoded() else {
      
      addFailureSubviewTo(addsContentView,
                          errorMessage: "Can't encode Article URL")
      return
    }
    
    if VUInternetChecker.isOnline == false {
      
      addFailureSubviewTo(addsContentView,
                          errorMessage: "Vuukle is Offline")
      return
    }
   
    VUGlobals.appID   = encodedAppID
    VUGlobals.appName = encodedAppName
    VUGlobals.requestParametes.articleURL = encodedArticleURL
    
    addVuukleAddsSubviewTo(addsContentView)
  }
  
  
  // MARK: - REQUIRED: Update heights after Rotation or changing View Controller
  static func updateAllHeights() {
    
    if let webView = vWebView,
      let heightConstraint = vWebViewHeightConstraint {
      
      updateWebViewHeight(webView: webView,
                          heightConstraint: heightConstraint)
    }

    if vContentViewHieghtConstraint != nil {
      updateTableViewHeight()
    }
    
    if vTopArticleViewHieghtConstraint != nil {
        VUServerManager.getTopArticles() { (responceArray, error) in
            if let articlesArray = responceArray, articlesArray.count > 0 {
                let count = articlesArray.count
                if count > 2 {
                    if vTopArticleViewHieghtConstraint?.constant == CGFloat(count * 83 + (83 + 42)) {
                        vTopArticleViewHieghtConstraint?.constant = CGFloat(count * 83 + ((83 * 2) - 40))
                    } else {
                        vTopArticleViewHieghtConstraint?.constant = CGFloat(count * 83 + ((83 * 2) + 42))
                    }
                } else {
                    if vTopArticleViewHieghtConstraint?.constant == CGFloat(count * 83) + 83 {
                        vTopArticleViewHieghtConstraint?.constant = CGFloat(count * 83) + 83 - 40
                    } else {
                        vTopArticleViewHieghtConstraint?.constant = CGFloat(count * 83) + 83
                    }
                }
            } else {
                vTopArticleViewHieghtConstraint?.constant = 0
            }
        }
    }

    if vEmojiViewHieghtConstraint != nil {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        if screenWidth > 420 {
            vEmojiViewHieghtConstraint?.constant = 170
        } else {
            vEmojiViewHieghtConstraint?.constant = screenWidth/2.285
        }
    }
    
    if vAdsHieghtConstraint != nil {
      vAdsHieghtConstraint?.constant = 112.0
    }
    
    NotificationCenter.default.post(name: VUGlobals.nEmojiUpdateFrames, object: nil)
  }
    
  static func updateWebViewHeight(webView: UIWebView, heightConstraint: NSLayoutConstraint) {
    
    var frame = webView.frame
    frame.size.height = 1
    webView.frame = frame
    
    let fittingSize = webView.sizeThatFits(CGSize.zero)
    frame.size = fittingSize
    webView.frame = frame
    
    heightConstraint.constant = fittingSize.height
    
    vuuklePrint("[WebView] New Heigth = \(fittingSize.height)")
  }
  
  
  // MARK: - ADDITIONAL: Methods before adding URL
  static func loadVuukleURL(_ stringURL: String,
                            webView: UIWebView,
                            webViewHieghtConstraint: NSLayoutConstraint) {
    
    vWebView = webView
    vWebViewHeightConstraint = webViewHieghtConstraint
    
    guard let encodedStringURL = stringURL.jsonEncoded() else {
      return
    }
    
    if let contentURL = URL(string: encodedStringURL) {
      webView.loadRequest(URLRequest(url: contentURL))
    }
    
    webView.scrollView.isScrollEnabled = false
    webView.delegate = VUCommentsVC.sharedInstance
  }
  
  
  // MARK: - PRIVATE: Supporting methods
  private static func addVuukleCommentsSubviewTo(_ contentView: UIView) {

    if vContentView != nil, let currentView = vContentView, contentView !== currentView {
      VUModelsFactory.generateObjectsForCells(true, contentView: contentView)
    }
    
    vContentView = contentView
    loadSubviewFromVC(contentView, subviewVC: VUCommentsVC.sharedInstance)
  }
  
  private static func addVuukleEmojiSubviewTo(_ contentView: UIView) {
    
    if vContentView != nil, let currentView = vEmojiView, contentView !== currentView {
      VUModelsFactory.generateEmojiModel()
    }
    
    vEmojiView = contentView
    loadEmojiSubview(contentView)
  }
  
  private static func addVuukleTopArticleSubviewTo(_ contentView: UIView) {
    
    if vContentView != nil, let currentView = vTopArticle, contentView !== currentView {
//      VUModelsFactory.generateTopArticleModel()
    }
    
    vTopArticle = contentView
    loadTopArticleSubview(contentView)
  }
  
  private static func addVuukleAddsSubviewTo(_ contentView: UIView) {
    
    if vContentView != nil, let currentView = vAddsView, contentView !== currentView {
      return
    }
    
    vAddsView = contentView
    loadAddsSubview(contentView)
  }
  
  private static func addFailureSubviewTo(_ contentView: UIView, errorMessage: String) {
    
    if let constraint = vContentViewHieghtConstraint {
      constraint.constant = 124
    }
    
    VUFailureVC.sharedInstance.errorMessage = errorMessage
    loadSubviewFromVC(contentView, subviewVC:  VUFailureVC.sharedInstance)
  }

  private static func loadSubviewFromVC(_ contentView: UIView, subviewVC: UIViewController) {
    
    contentView.layer.masksToBounds = true
    contentView.frame = subviewVC.view.frame
    contentView.addSubview(subviewVC.view)
  }
  
  private static func loadEmojiSubview(_ contentView: UIView) {
    
    let emojiSubView = VUEmojiVoitingView.instanceFromNib()
    
    contentView.layer.masksToBounds = true
    contentView.frame = emojiSubView.frame
    contentView.addSubview(emojiSubView)
  }
  
  private static func loadTopArticleSubview(_ contentView: UIView) {
    
    let topArticleSubView = VUTopArticleVC.sharedInstance
    contentView.layer.masksToBounds = true
    contentView.frame = topArticleSubView.view.frame
    contentView.addSubview(topArticleSubView.view)
  }
  
  private static func loadAddsSubview(_ contentView: UIView) {
    
    let addsSubView = VUAdvertisingView.instanceFromNib()
    
    contentView.layer.masksToBounds = true
    contentView.frame = addsSubView.frame
    contentView.addSubview(addsSubView)
  }
  
  // MARK: - HEIGHT: Updating height of TableView
  static func updateTableViewHeight() {
    
    if let tableView = VUCommentsVC.sharedInstance.tableView {
      
      tableView.layoutSubviews()
      
      let newHeight = tableView.contentSize.height
      vContentViewHieghtConstraint?.constant = newHeight

      vuuklePrint("[TableView] New Heigth = \(newHeight)")
    }
  }
  
  static func setTempHeight() {
    
    if let tableView = VUCommentsVC.sharedInstance.tableView {
      
      let newHeight = tableView.frame.height * 2
      vContentViewHieghtConstraint?.constant = newHeight
      
      vuuklePrint("[TableView] Temp Heigth = \(newHeight)")
    }
  }
  

  // MARK: - HEIGHT: Updating height of Top Article TableView
  static func updateTopArticleTableViewHeight() {
    
    if let tableView = VUTopArticleVC.sharedInstance.tableView {
      
      tableView.layoutSubviews()
      
      let newHeight = tableView.contentSize.height
      vTopArticleViewHieghtConstraint?.constant = newHeight
      
      vuuklePrint("[TableView] New Heigth = \(newHeight)")
    }
  }
  
  static func setDefaultTopArticleHeight() {
    
    if let tableView = VUTopArticleVC.sharedInstance.tableView {
      
      tableView.layoutSubviews()
      vTopArticleViewHieghtConstraint?.constant = 1000
    }
  }

  
}
