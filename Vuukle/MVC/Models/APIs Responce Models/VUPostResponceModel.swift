//
//  VUPostResponceModel.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import Foundation

class VUPostResponceModel {

  // MARK: Model
  var commentID: String?
  
  var isRepeatComment = false
  var isUnderModeration = false
  
  var statusCode = 0
  var requestURL = ""
  var requestErrorReason = ""
  var infoDictionary: NSDictionary?
  
  // MARK: Comment info
  var comment = "no_comment"
  var name = "no_name"
  var email = "no_email"
  var userAvatarUrl: NSURL? 
  
  
  // MARK: Init of Model
  init(info: [String: Any]?, requestURL: String, statusCode: Int, errorReason: String?) {
    
    self.requestURL = requestURL
    self.statusCode = statusCode
    
    if let lReason = errorReason {
      requestErrorReason = lReason
    }

    if statusCode == 200 {
        let infoDictionary = info?["d"] as! String
        if let data = infoDictionary.data(using: String.Encoding.utf8) {
            do {
                let stringToDIctionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                self.infoDictionary = stringToDIctionary as NSDictionary?
            } catch let error as NSError {
                print(error)
            }
        }
        
        if (self.infoDictionary != nil) {
            self.name = (self.infoDictionary?["first_name"] as? String)!
            self.userAvatarUrl = self.infoDictionary?["avatar"] as? NSURL
            var result = self.infoDictionary?["result"] as? String
            let commentID = self.infoDictionary?["comment_id"] as? String
            let isModeration = self.infoDictionary?["isModeration"] as? String
            
            result = result?.lowercased()
            
            if commentID == "repeat_comment" {
                isRepeatComment = true
                return
            }
            self.commentID = commentID
            
            if Bool(isModeration!) == false {
                isUnderModeration = false
            }
            
            if Bool(isModeration!) == true {
                isUnderModeration = true
            }
        }
    }
    
  }
  
}
