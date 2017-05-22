//
//  VUGlobals.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit


class VUGlobals {

  private init() {}
  private static var _currentDeviceType: VUCurrentDeviceType?
  
  
  // MARK: - INFO: About framework
  static let vuukleVersion = "2.0.26"
  static let isDebugBuild = false
  static let emojiStrings = ["😄", "😐", "😏", "😂", "😡", "😕"]
  
  static var activeTextInput: Any?
  
  static var currentDeviceType: VUCurrentDeviceType {
    
    if let deviceType = _currentDeviceType {
      return deviceType
    }
  
    let deviceType = UIDevice.current.deviceType
    _currentDeviceType = deviceType
    
    return deviceType
  }

  
  // MARK: - COUNT: Total and loaded comments
  static var totalCommentsCount = 0 {
    didSet {
      NotificationCenter.default.post(name: nTotalCountUpdate,
                                      object: totalCommentsCount)
    }
  }
  
  static var loadedCommetsCount = 0 {
    didSet {
      NotificationCenter.default.post(name: nLoadedCountUpdate,
                                      object: loadedCommetsCount)
    }
  }
  
  
  // MARK: - DEFAULT: Basic values
  static let defaultPhotoURL = "http://3aa0b40d2aab024f527d-510de3faeb1a65410c7c889a906ce44e.r42.cf6.rackcdn.com/avatar.png"
  static var imgUrlForPostComment = ""
  static let defaultEdgeInserts = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  
  
  // MARK: - REQUIRED: Parametes for requests
  static let vuukleBaseURL = "https://vuukle.com/api.asmx/"
  static let vuukleBaseURLCommentAction = "http://vuukle.com/v1/api.asmx/"
  
  static var appName = ""
  static var appID = ""
  
  struct requestParametes {
    
    static var vuukleApiKey    = ""
    static var vuukleSecretKey = ""
    static var vuukleHost      = ""
    static var vuukleTimeZone  = ""
    
    static var articleTitle = ""
    static var articleID  = ""
    static var articleTag = ""
    static var articleURL = ""
    static var resourceID = 0
  }
  
  
  // MARK: - ADDITIONAL: Settings and parameters
  static var commentsPagination = 20
  static var isCommentsScrollEnabled = false
  
  static var isEmojiVotingHidden = false
  
  static var isTopArticlesHiden = false
  static var topArticlesCount = 10
  static var topArticlesHours = 24
  
  static var isVuukleAdsHiden = false
  static var applicationName = ""
  static var applicationID = ""
  
  
  // MARK: - NOTIFICATIONS: Different internal notifications
  static let nNewCommentShowProgress = Notification.Name("NOTIFICATION_NEW_COMMENT_SHOW_PROGRESS")
  static let nNewCommentHideProgress = Notification.Name("NOTIFICATION_NEW_COMMENT_HIDE_PROGRESS")
  static let nTotalCountUpdate = Notification.Name("NOTIFICATION_TOTAL_COUNT_UPDATE")
  static let nLoadedCountUpdate = Notification.Name("NOTIFICATION_LOADED_COUNT_UPDATE")
  static let nLoginUserUpdate = Notification.Name("NOTIFICATION_LOGIN_USER_UPDATE")
  
  static let nLoginShowFlags = Notification.Name("NOTIFICATION_LOGIN_USER_SHOW_FLAGS")
  static let nLogoutRemoveFlags = Notification.Name("NOTIFICATION_LOGOUT_USER_REMOVE_FLAGS")
  static let nHideLoadMoreButton = Notification.Name("NOTIFICATION_LOAD_MORE_BUTTON")
  
  static let nEmojiUpdateFrames = Notification.Name("NOTIFICATION_EMOJI_UPDATE_FRAMES")
  static let nEmojiUpdateModels = Notification.Name("NOTIFICATION_EMOJI_UPDATE_MODELS")
  
  static let nSetNewDesign = Notification.Name("NOTIFICATION_SET_NEW_DESIGN")
  
  
  // MARK: - Errors and warnings
  static var errorFlag = ""
}

