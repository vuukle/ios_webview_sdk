//
//  VUCommentsBuilder.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

// MARK: - VUTalkOfTheTownDelegate
public protocol VUTalkOfTheTownDelegate {
  
  func openArticle(title: String,
                   apiKey: String,
                   articleHost: String,
                   articleID: String,
                   articleURL: String)
}


// MARK: - VUCommentsBuilder
open class VUCommentsBuilder: NSObject {
  
  private override init() { }
  public static var delegate: VUTalkOfTheTownDelegate?
  
  // MARK: - REQUIRED: Add Vuukle Comments and Update Height.
  
  /**
   REQUIRED: This method initializes and puts Vuukle Comments to specific UIView You set.
   
   - parameters:
     - baseVC: UIViewController wich contains contentView for comments.
    
     - baseScrollView: OPTIONAL PARAMETER: If You use nested comments You have to set base UIScrollView.
   
     - contentView: Vuukle Comments will be added to this UIView as subview.

     - contentHeightConstraint: OPTIONAL PARAMETER: If You use nested comments, You have to set height NSLayoutConstraint of contentView for comments.
   
     - vuukleApiKey: Set your API key for API. To get API KEY You need:
         1) Sign in to dashboard thouth [vuukle.com](http://vuukle.com/)
         2) Navigate to domain from home page of dashboard (first page after signing in).
         3) Choose in menu Integration, then API Docs from the dropdown.
         4) Then You will be able to see API and secret keys.
   
         --- OR ---
   
         1) Sign in to dashboard thouth [vuukle.com](http://vuukle.com/)
         2) After signing in, in header You can find 'Integration' click -> choose API docs in the drop-down.
   
     - vuukleSecretKey:  Set your SecretKey for API. To get SECRET KEY You need:
         1) Sign in to dashboard through [vuukle.com](http://vuukle.com/)
         2) Navigate to domain from home page of dashboard (first page after signing in).
         3) Choose in menu Integration, then API Docs from the dropdown.
         4) Then You will be able to see api and SECRET keys.
  
         --- OR ---
   
         1) Sign in to dashboard thouth [vuukle.com](http://vuukle.com/)
         2) after signing in, in header You can find ‘Integration’ click -> choose API docs in the drop-down.
   
     - vuukleHost: This is domain of the publisher’s site(e.g. indianexpress.com, thehindu.com etc.).
         
         FOR EXAMPLE: 
         
         You are the owner of indianexpress.com and have own app where want’s to setup this library, so when library installed on your app, You should paste domain for 'host' property without http:// or https:// or www.
   
     - vuukleTimeZone: You have to set string with format like "Europe/Kiev".
   
        Get your timezone from this resource: [List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
   
     - articleID: Get ID from [vuukle.com](http://vuukle.com/). Every article has unique ID.
   
     - articleTag: Tag of your article, it should be NOT empty string.
    
       FOR EXAMPLE:
   
       If You article is about sport news, set this parameter "Sport" etc.
   
     - articleTitle: Your Article Title, it should be NOT empty string.
   
     - articleURL: Your Article URL, it should be valide URL and NOT empty string.
   
     - isScrollEnabled: OPTIONAL PARAMETER: Set "true", if You want to enable own scroll of comments UITableView.
   
     - edgeInserts: OPTIONAL PARAMETER: UIEdgeInsets of comments UITableView, default value is UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)/
  */
  open static func addVuukleComments(baseVC: UIViewController,
                                     baseScrollView: UIScrollView? = nil,
                                     contentView: UIView,
                                     contentHeightConstraint: NSLayoutConstraint? = nil,
                                     appName: String? = nil,
                                     appID: String? = nil,
                                     vuukleApiKey: String,
                                     vuukleSecretKey: String,
                                     vuukleHost: String,
                                     vuukleTimeZone: String,
                                     articleTitle: String,
                                     articleID: String,
                                     articleTag: String,
                                     articleURL: String,
                                     isScrollEnabled: Bool = false,
                                     edgeInserts: UIEdgeInsets = VUGlobals.defaultEdgeInserts) {
    
    VUCommentsBuilderModel.loadVuukleComments(baseVC: baseVC, contentView: contentView, apiKey: vuukleApiKey, secretKey: vuukleSecretKey, host: vuukleHost, timeZone: vuukleTimeZone, articleID: articleID, articleTitle: articleTitle, articleURL: articleURL, articleTag: articleTag, appName: appName, appID: appID)

    VUCommentsBuilderModel.isCommentScrollEnabled = isScrollEnabled
    VUCommentsBuilderModel.vuukleEdgeInserts = edgeInserts
    VUCommentsBuilderModel.vBaseVC = baseVC
    VUCommentsBuilderModel.vScrollView = baseScrollView
    VUCommentsBuilderModel.vContentViewHieghtConstraint = contentHeightConstraint
  }
  
  /**
   REQUIRED: You have to call this method in "viewWillAppear" and after rotation.
  */
  open static func updateAllHeights() {
    VUCommentsBuilderModel.updateAllHeights()
  }
  

  // MARK: - OPTIONAL: Emoji, Adds, TalkOfTheTown in separeate UIView.
 
  /**
   OPTIONAL: This method initializes and puts Vuukle Emoji to specific UIView You set.
   
   - parameters:
     - baseVC: UIViewController wich contains contentView for Emoji.
 
     - emojiContentView: Vuukle Emoji will be added to this UIView as subview.
   
     - emojiHeightConstraint: You have to set height NSLayoutConstraint of contentView for Emoji.
   
     - vuukleApiKey: Set your API key for API. To get API KEY You need:
         1) Sign in to dashboard thouth [vuukle.com](http://vuukle.com/)
         2) Navigate to domain from home page of dashboard (first page after signing in).
         3) Choose in menu Integration, then API Docs from the dropdown.
         4) Then You will be able to see API and secret keys.
   
         --- OR ---
   
         1) Sign in to dashboard thouth [vuukle.com](http://vuukle.com/)
         2) After signing in, in header You can find ‘Integration’ click -> choose API docs in the drop-down.
   
     - vuukleSecretKey:  Set your SecretKey for API. To get SECRET KEY You need:
         1) Sign in to dashboard through [vuukle.com](http://vuukle.com/)
         2) Navigate to domain from home page of dashboard (first page after signing in).
         3) Choose in menu Integration, then API Docs from the dropdown.
         4) Then You will be able to see api and SECRET keys.
   
         --- OR ---
   
         1) Sign in to dashboard thouth [vuukle.com](http://vuukle.com/)
         2) after signing in, in header You can find ‘Integration’ click -> choose API docs in the drop-down.
   
     - vuukleHost: This is domain of the publisher’s site(e.g. indianexpress.com, thehindu.com etc.).
   
     FOR EXAMPLE:
   
     You are the owner of indianexpress.com and have own app where want’s to setup this library, so when library installed on your app, You should paste domain for 'host' property without http:// or https:// or www.
   
     - articleID: Get ID from [vuukle.com](http://vuukle.com/). Every article has unique ID.
   
     - articleTitle: Your Article Title, it should be NOT empty string.
   
     - articleURL: Your Article URL, it should be valide URL and NOT empty string.
  */
  open static func addVuukleEmoji(baseVC: UIViewController,
                                  emojiContentView: UIView,
                                  emojiHeightConstraint: NSLayoutConstraint,
                                  vuukleApiKey: String,
                                  vuukleSecretKey: String,
                                  vuukleHost: String,
                                  articleTitle: String,
                                  articleID: String,
                                  articleURL: String) {

    VUCommentsBuilderModel.loadVuukleEmoji(emojiContentView: emojiContentView, apiKey: vuukleApiKey, secretKey: vuukleSecretKey, host: vuukleHost,articleTitle: articleTitle, articleID: articleID, articleURL: articleURL)
    
    VUCommentsBuilderModel.vBaseVC = baseVC
    VUCommentsBuilderModel.vEmojiViewHieghtConstraint = emojiHeightConstraint
  }
  

  /**
   OPTIONAL: This method initializes and puts Vuukle TalkOfTheTown to specific UIView You set.
   
   - parameters:
     - baseVC: UIViewController wich contains contentView for TalkOfTheTown.
   
     - topArticleContentView: Vuukle TalkOfTheTown will be added to this UIView as subview.
   
     - topArticleHeightConstraint: You have to set height NSLayoutConstraint of contentView for TalkOfTheTown.
   
     - vuukleApiKey: Set your API key for API. To get API KEY You need:
         1) Sign in to dashboard thouth [vuukle.com](http://vuukle.com/)
         2) Navigate to domain from home page of dashboard (first page after signing in).
         3) Choose in menu Integration, then API Docs from the dropdown.
         4) Then You will be able to see API and secret keys.
   
         --- OR ---
   
         1) Sign in to dashboard thouth [vuukle.com](http://vuukle.com/)
         2) After signing in, in header You can find ‘Integration’ click -> choose API docs in the drop-down.
   
     - vuukleSecretKey:  Set your SecretKey for API. To get SECRET KEY You need:
         1) Sign in to dashboard through [vuukle.com](http://vuukle.com/)
         2) Navigate to domain from home page of dashboard (first page after signing in).
         3) Choose in menu Integration, then API Docs from the dropdown.
         4) Then You will be able to see api and SECRET keys.
   
         --- OR ---
   
         1) Sign in to dashboard thouth [vuukle.com](http://vuukle.com/)
         2) after signing in, in header You can find ‘Integration’ click -> choose API docs in the drop-down.
   
     - vuukleHost: This is domain of the publisher’s site(e.g. indianexpress.com, thehindu.com etc.).
   
       FOR EXAMPLE:
   
       You are the owner of indianexpress.com and have own app where want’s to setup this library, so when library installed on your app, You should paste domain for 'host' property without http:// or https:// or www.
   
     - articleID: Get ID from [vuukle.com](http://vuukle.com/). Every article has unique ID.
   
     - articleTitle: Your Article Title, it should be NOT empty string.
   
     - articleURL: Your Article URL, it should be valide URL and NOT empty string.
  */
  open static func addVuukleTalkOfTheTown(baseVC: UIViewController,
                                          talkContentView: UIView,
                                          talkHeightConstraint: NSLayoutConstraint,
                                          vuukleApiKey: String,
                                          vuukleSecretKey: String,
                                          vuukleHost: String,
                                          articleTitle: String,
                                          articleID: String,
                                          articleURL: String) {
    
    VUCommentsBuilderModel.loadVuukleTopArticle(baseVC: baseVC,
                                                topArticleContentView: talkContentView,
                                                apiKey: vuukleApiKey,
                                                secretKey: vuukleSecretKey,
                                                host: vuukleHost,
                                                articleTitle: articleTitle,
                                                articleID: articleID,
                                                articleURL: articleURL)
    
    VUCommentsBuilderModel.vBaseVC = baseVC
    VUCommentsBuilderModel.vTopArticleViewHieghtConstraint = talkHeightConstraint
  }
  
  /**
   OPTIONAL: This method initializes and puts Vuukle Talk of The Town to specific UIView You set.
   
   - parameters:
     - baseVC: UIViewController wich contains contentView for TalkOfTheTown.
   
     - addsContentView: Vuukle TalkOfTheTown will be added to this UIView as subview.
   
     - addsHeightConstraint: You have to set height NSLayoutConstraint of contentView for TalkOfTheTown.
     
     - appName:
   
     - appID:
   
     - articleURL: Your Article URL, it should be valide URL and NOT empty string.
  */
  open static func addVuukleAdds(baseVC: UIViewController,
                                 addsContentView: UIView,
                                 addsHeightConstraint: NSLayoutConstraint,
                                 appName: String,
                                 appID: String,
                                 articleURL: String) {
    
    VUCommentsBuilderModel.loadVuukleAdds(addsContentView: addsContentView, appName: appName, appID: appID, articleURL: articleURL)
    
    VUCommentsBuilderModel.vBaseVC = baseVC
    VUCommentsBuilderModel.vAdsHieghtConstraint = addsHeightConstraint
  }

  
  // MARK: - OPTIONAL: Vuukle Comments Parameters
  
  /**
   OPTIONAL: You can hide Vuukle Adds
   */
  
  public static var isVuukleAdsHiden: Bool {
    set{
      VUGlobals.isVuukleAdsHiden = newValue
    }
    get {
      return VUGlobals.isVuukleAdsHiden
    }
  }
  
  
  /**
   OPTIONAL: You can hide Vuukle Emoji.
   */
  
  public static var isEmojiVotingHiden: Bool {
    set{
      VUGlobals.isEmojiVotingHidden = newValue
    }
    get {
      return VUGlobals.isEmojiVotingHidden
    }
  }

  
  /**
   OPTIONAL: You can change comments pagination (in range 0 to 40, default value is 10).
  */
  public static var commentPagination: Int {
    set {
      if newValue >= 1 && newValue <= 40 {
        VUGlobals.commentsPagination = newValue
      }
    }
    get {
      return VUGlobals.commentsPagination
    }
  }

  /**
   OPTIONAL: You can hide "Talk of the Town" articles.
  */
  public static var isTalkOfTheTownHiden: Bool {
    set {
      VUGlobals.isTopArticlesHiden = newValue
    }
    get {
      return VUGlobals.isTopArticlesHiden
    }
  }

  /**
   OPTIONAL: You can change the count of displayed "Talk of the Town" articles (in range 1 to 20, default value is 6).
  */
  public static var talkOfTheTownCount: Int {
    set {
      if newValue >= 1 && newValue <= 20 {
        VUGlobals.topArticlesCount = newValue
      }
    }
    get {
      return VUGlobals.topArticlesCount
    }
  }
  
  /**
   OPTIONAL: You can change the count of hours for which the "Talk of the Town" articles are shown (in range 12 to 240 hours, default value is 24 hours).
  */
  public static var talkOfTheTownHours: Int {
    set {
      if newValue >= 12 && newValue <= 240 {
        VUGlobals.topArticlesHours = newValue
      }
    }
    get {
      return VUGlobals.topArticlesHours
    }
  }
  
  
  // MARK: - OPTIONAL: Load URL and update height
  
  /**
   OPTIONAL: If you use nested comments with UIWebView, framework can load URL and manage height of this UIWebView depending of content size.
   
   - parameters:
   - stringURL: String with contains URL address of page you need.
   
   - webView: UIWebView with should load URL address.
   
   - webViewHieghtConstraint: You have to set height NSLayoutConstraint of your UIWebView.
   */
  open static func loadVuukleURL(_ stringURL: String,
                                 webView: UIWebView,
                                 webViewHieghtConstraint: NSLayoutConstraint) {
    
    VUCommentsBuilderModel.loadVuukleURL(stringURL, webView: webView, webViewHieghtConstraint: webViewHieghtConstraint)
  }
  
  /**
   OPTIONAL: If you need, this method can manage height of your UIWebView depending of content size.
   */
  open static func updateWebViewHeight(webView: UIWebView,
                                       heightConstraint: NSLayoutConstraint) {
    
    VUCommentsBuilderModel.updateWebViewHeight(webView: webView, heightConstraint: heightConstraint)
  }
  
  
  // MARK: - DESIGN: Updating of colors and night mod
  /**
   DESIGN: This methods will update all colors of framework.
  */
  open static func updateDesingColors() {
    
    NotificationCenter.default.post(name: VUGlobals.nSetNewDesign, object: nil)
  }
  
  /**
   DESIGN: This method will set day/night mode will update all colors of framework.
  */
  open static func setDesingType(_ type: VUDesignColorsType) {
    
    VUDesignHUB.colorsType = type
    NotificationCenter.default.post(name: VUGlobals.nSetNewDesign, object: nil)
  }
  
  /**
   REQUIRED: This method takes name and email for login.
   
   - parameters:
    - name: String with contains your name
   
    - email: String with contains your email adress
  */
  open static func loginUser(name: String, email: String) {
    VUModelsFactory.loginUser(name: name, email: email)
  }
  
  /**
   OPTIONAL: This method makes logOut
  */
  open static func logOut() {
    
    VUServerManager.logoutCurrentUser { (success, vuukleError) in
      if success {
        VUCurrentUser.deleteUser()
      } else {
        VUBugReportsFactory.showSendReportBUG(vuukleError!)
      }
    }
  }
}
