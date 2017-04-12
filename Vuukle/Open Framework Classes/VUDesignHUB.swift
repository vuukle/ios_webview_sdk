//
//  VUDesignHUB.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import Foundation
import UIKit


open class VUDesignHUB {
  
  private init() {}
  open static var colorsType: VUDesignColorsType = .dayColors
  
  // MARK: - General
  public struct general {
    
    public static var backgroundColor = UIColor.white
    public static var separatorColor  = UIColor.lightGray
    public static var progressIndicatorColor = UIColor.black
  }
  
  
  // MARK: - General Night
  public struct generalNight {
    
    public static var backgroundColor = UIColor.black
    public static var separatorColor  = UIColor.lightGray
    public static var progressIndicatorColor = UIColor.white
  }
  
  
  // MARK: - Keyboard and Toolbar
  public struct keyboard {
    
    public static var keyboardAppearance: UIKeyboardAppearance = .light
    public static var toolbarStyle: UIBarStyle = .default
    public static var editIndicatorColor = UIColor.gray
    
    // TODO: • Toolbar Buttons
    public static var toolbarDoneButtonColor = UIColor.vuukleOrange
    public static var toolbarDownArrowButtonColor = UIColor.vuukleOrange
    public static var toolbarUpArrowButtonColor = UIColor.vuukleOrange
  }
  
  
  // MARK: - Keyboard and Toolbar Night
  public struct keyboardNight {
    
    public static var keyboardAppearance: UIKeyboardAppearance = .dark
    public static var toolbarStyle: UIBarStyle = .black
    public static var editIndicatorColor = UIColor.white
    
    // TODO: • Toolbar Buttons
    public static var toolbarDoneButtonColor = UIColor.vuukleOrange
    public static var toolbarDownArrowButtonColor = UIColor.vuukleOrange
    public static var toolbarUpArrowButtonColor = UIColor.vuukleOrange
  }
  
  
  // MARK: - Emoji Voting Cell
  public struct emojiVotingCell {
    
    public static var titleTextColor = UIColor.black
    public static var emojiMoodTextColor  = UIColor.darkGray
    
    // TODO: • Total Count
    public static var totalCountTextColor = UIColor.white
    public static var totalCountBackgroundColor = UIColor.vuukleOrange
    
    // TODO: • Emoji Percentage
    public static var percentageTextColor = UIColor.white
    public static var percentageTopTextColor = UIColor.white
    public static var percentageTopBackgroundColor = UIColor.vuukleRed
    public static var percentageBackgroundColor = UIColor.lightGray
  }
  
  
  // MARK: - Emoji Voting Cell Night
  public struct emojiVotingCellNight {
    
    public static var titleTextColor = UIColor.white
    public static var emojiMoodTextColor  = UIColor.lightGray
    
    // TODO: • Total Count
    public static var totalCountTextColor = UIColor.darkGray
    public static var totalCountBackgroundColor = UIColor.vuukleOrange
    
    // TODO: • Emoji Percentage
    public static var percentageTextColor = UIColor.white
    public static var percentageTopTextColor = UIColor.darkGray
    public static var percentageTopBackgroundColor = UIColor.vuukleOrange
    public static var percentageBackgroundColor = UIColor.darkGray
  }
  
  
  // MARK: - Comment Cell
  public struct commentCell {
    
    public static var reportButtonDefaultColor  = UIColor.darkGray
    public static var reportButtonReportedColor = UIColor.vuukleRed
    public static var shareButtonColor = UIColor.darkGray
    
    // TODO: • User
    public static var userNameTextColor   = UIColor.black
    public static var userRatingTextColor = UIColor.white
    public static var userRatingBackgroundColor = UIColor.vuukleOrange
    
    public static var userAvatarBackgroundColor = UIColor.lightGray
    public static var usetAvatarProgressIndicatorColor = UIColor.darkGray
    public static var userAvatarInitialsColor = UIColor.darkGray
    
    // TODO: • Comment
    public static var commentTextColor = UIColor.black
    public static var commentTimeTextColor = UIColor.darkGray
    
    // TODO: • Replies for comment
    public static var showCommentRepliesButtonColor = UIColor.black
    public static var replyButtonColor = UIColor.black
    
    public static var repliesCountTextColor = UIColor.white
    public static var repliesCountBackgroundColor = UIColor.lightGray
    
    // TODO: • Voting
    public static var downVoteButtonColor = UIColor.lightGray
    public static var upVoteButtonColor   = UIColor.lightGray
    public static var selectedButtonColor = UIColor.vuukleGray
    
    public static var totalVotesZeroTextColor = UIColor.darkGray
    public static var totalVotesGreaterZeroTextColor = UIColor.vuukleBlue
    public static var totalVotesLessZeroTextColor = UIColor.vuukleRed
    
    public static var commentVotingStyle: VUCommentCellVotingStyle = .fingerIcons
  }
 
  
  // MARK: - Comment Cell Night
  public struct commentCellNight {
    
    public static var reportButtonDefaultColor  = UIColor.darkGray
    public static var reportButtonReportedColor = UIColor.vuukleRed
    public static var shareButtonColor = UIColor.darkGray
    
    // TODO: • User
    public static var userNameTextColor   = UIColor.white
    public static var userRatingTextColor = UIColor.darkGray
    public static var userRatingBackgroundColor = UIColor.vuukleOrange
    
    public static var userAvatarBackgroundColor = UIColor.darkGray
    public static var usetAvatarProgressIndicatorColor = UIColor.white
    public static var userAvatarInitialsColor = UIColor.lightGray
    
    // TODO: • Comment
    public static var commentTextColor = UIColor.white
    public static var commentTimeTextColor = UIColor.gray
    
    // TODO: • Replies for comment
    public static var showRepliesButtonColor = UIColor.lightGray
    public static var replyButtonColor = UIColor.lightGray
    
    public static var repliesCountTextColor = UIColor.white
    public static var repliesCountBackgroundColor = UIColor.darkGray
    
    // TODO: • Voting
    public static var downVoteButtonColor = UIColor.darkGray
    public static var upVoteButtonColor   = UIColor.darkGray
    public static var selectedButtonColor = UIColor.vuukleGray
    
    public static var totalVotesZeroTextColor = UIColor.lightGray
    public static var totalVotesGreaterZeroTextColor = UIColor.vuukleBlue
    public static var totalVotesLessZeroTextColor = UIColor.vuukleRed
    
    public static var commentVotingStyle: VUCommentCellVotingStyle = .fingerIcons
  }
  
  
  // MARK: - New Comment Cell (also New Reply)
  public struct newCommentCell {
    
    // TODO: • Voting
    public static var totalCountTextColor = UIColor.white
    public static var backgroundColor = UIColor.lightGray
    public static var welcomeLabelTextColor = UIColor.black
    
    // TODO: • Input fields
    public static var inputFieldsTextColor = UIColor.black
    public static var inputFieldsBackgroundColor = UIColor.white
    public static var inputFieldsBorderColor = UIColor.lightGray
    public static var inputFieldsPlaceholderColor = UIColor.lightGray
    
    // TODO: • Symbols count
    public static var symbolsCountTextColor = UIColor.white
    public static var symbolsCountBackgroundColor = UIColor.vuukleOrange
    public static var symbolsCountOverLimitBackgroundColor = UIColor.vuukleRed
    public static var symbolsCountZeroBackgroundColor = UIColor.vuukleGray

    // TODO: • Buttons
    public static var postButtonBackgroundColor = UIColor.vuukleOrange
    public static var postButtonTextColor = UIColor.white
    
    public static var logoutButtonTextColor = UIColor.white
    public static var logoutButtonBackgroundColor = UIColor.vuukleGray
  }
  
  
  // MARK: - New Comment Cell (also New Reply) Night
  public struct newCommentCellNight {
    
    // TODO: • Voting
    public static var totalCountTextColor = UIColor.white
    public static var backgroundColor = UIColor.darkGray
    public static var welcomeLabelTextColor = UIColor.white
    
    // TODO: • Input fields
    public static var inputFieldsTextColor = UIColor.white
    public static var inputFieldsBackgroundColor = UIColor.gray
    public static var inputFieldsBorderColor = UIColor.gray
    public static var inputFieldsPlaceholderColor = UIColor.darkGray
    
    // TODO: • Symbols count
    public static var symbolsCountTextColor = UIColor.darkGray
    public static var symbolsCountBackgroundColor = UIColor.vuukleOrange
    public static var symbolsCountOverLimitBackgroundColor = UIColor.vuukleRed
    public static var symbolsCountZeroBackgroundColor = UIColor.vuukleGray
    
    // TODO: • Buttons
    public static var postButtonBackgroundColor = UIColor.vuukleOrange
    public static var postButtonTextColor = UIColor.darkGray
    
    public static var logoutButtonTextColor = UIColor.white
    public static var logoutButtonBackgroundColor = UIColor.vuukleGray
  }

  
  // MARK: - Login From Cell
  public struct loginFormCell {
    
    public static var backgroundColor = UIColor.lightGray
    
    public static var inputFieldsTextColor = UIColor.black
    public static var inputFieldsBackgroundColor = UIColor.white
    
    public static var loginButtonTextColor = UIColor.white
    public static var loginButtonBackgroundColor = UIColor.vuukleOrange
  }
  
  
  // MARK: - Login From Cell Night
  public struct loginFormCellNight {
    
    public static var backgroundColor = UIColor.darkGray
    
    public static var inputFieldsTextColor = UIColor.white
    public static var inputFieldsBackgroundColor = UIColor.gray
    
    public static var loginButtonTextColor = UIColor.darkGray
    public static var loginButtonBackgroundColor = UIColor.vuukleOrange
  }
  
  
  // MARK: - Load More Cell
  public struct loadMoreCell  {
    
    public static var alreadyLoadedTextColor = UIColor.lightGray
    public static var loadMoreButtonTextColor = UIColor.white
    public static var loadMoreButtonBackgroundColor = UIColor.vuukleOrange
  }
  
  
  // MARK: - Load More Cell Night
  public struct loadMoreCellNight  {
    
    public static var alreadyLoadedTextColor = UIColor.gray
    public static var loadMoreButtonTextColor = UIColor.darkGray
    public static var loadMoreButtonBackgroundColor = UIColor.vuukleOrange
  }
  
  
  // MARK: - Talk of The Town Cell
  public struct talkOfTheTownCell  {
    
    public static var titleTextColor = UIColor.black
    public static var timeTextColor = UIColor.darkGray
    
    public static var imageBorderColor = UIColor.lightGray
    
    public static var commentsCountBackground = UIColor.lightGray
    public static var commentsCountTextColor = UIColor.white
  }
  
  public struct talkOfTheTownCellNight  {
    
    public static var titleTextColor = UIColor.white
    public static var timeTextColor = UIColor.gray
    
    public static var imageBorderColor = UIColor.clear
    
    public static var commentsCountBackground = UIColor.darkGray
    public static var commentsCountTextColor = UIColor.white
  }
  
}

