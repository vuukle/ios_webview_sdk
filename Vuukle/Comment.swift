//
//  Comment.swift
//  Vuukle Comment
//
//  Created by Орест on 07.09.16.
//  Copyright © 2016 Midgets. All rights reserved.
//

import Foundation

class Comment {
    var comment : String?
    var name : String?
    var ts : String?
    var up_votes : Int?
    var down_votes : Int?
    var comment_id : String?
    var user_id : String?
    var replies : Int?
    var user_points : Int?
    var avatar_url : String?
    var parent_id : String?
    var email : String?
    var myParent_id : String?
    var myComment : Bool?
    var isReplie : Bool?
    var myReplyFormIndex : Int?
    var initials : String?
    var level : Int?
    var myReplys : NSArray?
    
    static func getCommentWhithArray(pDict : NSDictionary) -> Comment {
        
        let lComment = Comment()
        lComment.comment = pDict["comment"] as? String ?? ""
        lComment.name = pDict["name"] as? String ?? ""
        lComment.ts = pDict["ts"] as? String ?? ""
        lComment.up_votes = pDict["up_votes"] as? Int ?? Int("")
        lComment.down_votes = pDict["down_votes"] as? Int ?? Int("")
        lComment.comment_id = pDict["comment_id"] as? String ?? ""
        lComment.user_id = pDict["user_id"] as? String ?? ""
        lComment.replies = pDict["replies"] as? Int ?? Int("")
        lComment.user_points = pDict["user_points"] as? Int ?? Int("")
        lComment.avatar_url = pDict["avatar_url"] as? String ?? ""
        lComment.parent_id = pDict["parent_id"] as? String ?? ""
        lComment.email = pDict["email"] as? String ?? ""
        lComment.myParent_id = ""
        lComment.myComment = false
        lComment.isReplie = true
        lComment.myReplyFormIndex = -1
        lComment.initials = ""
        lComment.level = 0
        lComment.myReplys = []
        
        return lComment
    }
}