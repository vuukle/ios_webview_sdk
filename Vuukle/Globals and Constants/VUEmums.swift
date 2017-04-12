//
//  VUEmums.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit


// MARK: - General Info
enum VUCurrentDeviceType {
  
  case iPodTouch
  case iPhone4
  case iPhone5
  case iPhone6
  case iPhonePlus
  case iPadMini
  case iPadRetina
  case iPadPro
  case unknown
}

enum VUAssetsIdentifier: String {

  case offlineIcon = "Vuukle_Offline_Icon"
  case failureIcon = "Vuukle_Failure_Icon"
  
  case topArticlePlaceholder = "Top_Article_Placeholder"
  
  case upArrow         = "Up_Arrow_Icon"
  case upArrowSelected = "Up_Arrow_Icon_Selected"
  case downArrow         = "Down_Arrow_Icon"
  case downArrowSelected = "Down_Arrow_Icon_Selected"
  
  case upVote         = "Up_Vote_Icon"
  case upVoteSelected = "Up_Vote_Icon_Selected"
  case downVote         = "Down_Vote_Icon"
  case downVoteSelected = "Down_Vote_Icon_Selected"
  
  case hudSuccessIcon = "Success_Icon_HUD"
  case hudErrorIcon   = "Error_Icon_HUD"
  case hudModerationIcon = "Moderation_Icon_HUD"
  case hudReportedIcon   = "Reported_Icon_HUD"
  case hudLogoutIcon = "Logout_Icon_HUD"
  case hudUpVotedIcon = "Up_Voted_Icon_HUD"
  case hudDownVotedIcon = "Down_Voted_Icon_HUD"
  
  case emojiHappyIcon = "Happy_Emoji_Icon"
  case emojiNeutralIcon = "Neutral_Emoji_Icon"
  case emojiAmusedIcon = "Amused_Emoji_Icon"
  case emojiExictedIcon = "Excited_Emoji_Icon"
  case emojiAngryIcon = "Angry_Emoji_Icon"
  case emojiSadIcon = "Sad_Emoji_Icon" 
 }


// MARK: - Design
public enum VUCommentCellVotingStyle {
  
  case arrowIcons
  case fingerIcons
}


public enum VUDesignColorsType {
  
  case dayColors
  case nightColors
}


// MARK: - Actions with comment
enum VUTextInputType {
  
  case commentTextView
  case nameTextField
  case emailTextField
  case unknown
}


enum VULoginActionType {
  
  case reportComment
  case upVote
  case downVote
  case none
}

enum VUCommentVoteType: String {
  
  case upVote = "1"
  case downVote = "-1"
  case none = "none"
}


// MARK: - Checking of parameters
enum VUCommentCheckResultType {
  
  case emptyComment
  case commentContaintsURL
  case correct
}

enum VUNameCheckResultType {
  
  case emptyName
  case nameContainsURL
  case correct
}

enum VUEmailCheckResultType {
  
  case emptyEmail
  case notEmail
  case correct
}


// MARK: - Errors
enum VUFailureAddVuukleType {
  
  case vuukleOffline
  case errorInParameters
}

enum VUBugReportType: String {
  
  case errorEncodeText = "Error to Encode Text"
  case errorPostComment = "Error to Post Comment"
  case errorPostReply = "Error to Post Reply"
  case errorReportComment = "Error to Report Comment"
  case errorVoteForComment = "Error to Vote for Comment"
  case errorVoteForEmoji = "Error to Vote for Emoji"
  case errorLogOut = "Error to Log Out"
  case none = "no_error"
}
