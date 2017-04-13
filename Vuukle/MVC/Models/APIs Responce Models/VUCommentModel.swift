//
//  VUCommentModel.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit

class VUCommentModel {
  
  // MARK: - Model
  var userName = "unknown_author"
  var userRating = 0
  var userID: String?
  var userPhotoURL: String?
  var userEmail = "no_email"
  
  var comment = "no_comment"
  var commentID: String?
  var commentDate = NSDate(timeIntervalSinceNow: 0)
  
  var repliesCount = 0
  var upVotes   = 0
  var downVotes = 0
  
  var parentID = "-1"

  
  // MARK: - Additional Fields
  var isRepliesHiden = true
  var isReported = false
  var votedType: VUCommentVoteType = .none
  var nestingLevel = 0
  
  
  // MARK: - Inits of Model
  init(info: NSDictionary) {
    
    if let infoName = info["name"] as? String,
      let decodedName = infoName.jsonDecoded() {
        
      userName = decodedName
    }
    
    if let infoEmail = info["email"] as? String,
      let decodedEmail = infoEmail.jsonDecoded() {
      
      userEmail = decodedEmail
    }
    
    if let infoUserID = info["user_id"] as? String,
      let decodedUserID = infoUserID.jsonDecoded() {
      
      userID = decodedUserID
    }
    
    userRating = info["user_points"] as? Int ?? 0
    
    if let photoURL = info["avatar_url"] as? String,
      photoURL != VUGlobals.defaultPhotoURL {
      
      userPhotoURL = photoURL
    }
    
    if let infoComment = info["comment"] as? String {
      
      if let decodedComent = infoComment.jsonDecoded() {
        comment = decodedComent.decodeEmojis
      } else {
        comment = infoComment.decodeEmojis
      }
    }
    
    if let infoCommentID = info["comment_id"] as? String,
      let decodedCommentID = infoCommentID.jsonDecoded() {
      
      commentID = decodedCommentID
      
      if let currentName = VUCurrentUser.name, let currentEmail = VUCurrentUser.email {
        
        let reportedKey = "\(currentName)\(currentEmail)reported\(decodedCommentID)"
        
        if UserDefaults.standard.object(forKey: reportedKey) != nil {
          isReported = true
        }
      }
      
      if let currentName = VUCurrentUser.name, let currentEmail = VUCurrentUser.email {
        
        let votedKey = "\(currentName)\(currentEmail)voted\(decodedCommentID)"
        
        if let voteTypeString = UserDefaults.standard.object(forKey: votedKey) as? String {
          
          if voteTypeString == "VUUKLE_UP_VOTE" {
            votedType = .upVote
          }
          
          if voteTypeString == "VUUKLE_DOWN_VOTE" {
            votedType = .downVote
          }
        }
        
      }
    }
    
    if let infoDateString = info["ts"] as? String {
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
      
      if let date = dateFormatter.date(from: infoDateString) {
        commentDate = NSDate(timeIntervalSinceNow: date.timeIntervalSinceNow)
      }
    }

    upVotes = info["up_votes"] as? Int ?? 0
    downVotes = info["down_votes"] as? Int ?? 0
    repliesCount = info["replies"] as? Int ?? 0
    
    parentID = info["parent_id"] as? String ?? "-1"
    
    addObserverForShowFlags()
    addObserverForRemoveFlags()
  }

  init(comment: String,
       commentID: String,
       name: String,
       email: String,
       nestingLevel: Int = 0) {
   
    self.nestingLevel = nestingLevel
    self.comment = comment
    self.commentID = commentID
    
    userName = name
    userEmail = email
    
    addObserverForShowFlags()
    addObserverForRemoveFlags()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  
  // MARK: - Private methods
  private func addObserverForRemoveFlags() {
    
    NotificationCenter.default.addObserver(forName: VUGlobals.nLogoutRemoveFlags,
                                           object: nil,
                                           queue: nil) { [weak self] (notification) in
      
      guard let exSelf = self else {
        return
      }
      
      exSelf.isReported = false
      exSelf.votedType = .none
    }
  }
  
  private func addObserverForShowFlags() {
    
    NotificationCenter.default.addObserver(forName: VUGlobals.nLoginShowFlags,
                                           object: nil,
                                           queue: nil) { [weak self] (notification) in
      
      guard let exSelf = self else {
        return
      }

      if let currentName = VUCurrentUser.name,
        let currentEmail = VUCurrentUser.email,
        let commentID = exSelf.commentID {
        
        let reportedKey = "\(currentName)\(currentEmail)reported\(commentID)"
        
        if UserDefaults.standard.object(forKey: reportedKey) != nil {
          exSelf.isReported = true
        }
        
        let votedKey = "\(currentName)\(currentEmail)voted\(commentID)"
        
        if let voteTypeString = UserDefaults.standard.object(forKey: votedKey) as? String {
          
          if voteTypeString == "VUUKLE_UP_VOTE" {
            exSelf.votedType = .upVote
          }
          
          if voteTypeString == "VUUKLE_DOWN_VOTE" {
            exSelf.votedType = .downVote
          }
        }
        
      }
    }
  }
  
}
