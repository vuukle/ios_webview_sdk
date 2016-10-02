

import Foundation

class CommentsFeed {
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
    
    static func getCommentsFeedWhithArray(pDict : NSDictionary) -> CommentsFeed {
        
        let lGetCommentsFeed = CommentsFeed()
        lGetCommentsFeed.comment = pDict["comment"] as? String ?? ""
        lGetCommentsFeed.name = pDict["name"] as? String ?? ""
        lGetCommentsFeed.ts = pDict["ts"] as? String ?? ""
        lGetCommentsFeed.up_votes = pDict["up_votes"] as? Int ?? Int("")
        lGetCommentsFeed.down_votes = pDict["down_votes"] as? Int ?? Int("")
        lGetCommentsFeed.comment_id = pDict["comment_id"] as? String ?? ""
        lGetCommentsFeed.user_id = pDict["user_id"] as? String ?? ""
        lGetCommentsFeed.replies = pDict["replies"] as? Int ?? Int("")
        lGetCommentsFeed.user_points = pDict["user_points"] as? Int ?? Int("")
        lGetCommentsFeed.avatar_url = pDict["avatar_url"] as? String ?? ""
        lGetCommentsFeed.parent_id = pDict["parent_id"] as? String ?? ""
        lGetCommentsFeed.email = pDict["email"] as? String ?? ""
        lGetCommentsFeed.myParent_id = ""
        lGetCommentsFeed.isReplie = false
        if lGetCommentsFeed.parent_id != "-1" {
            lGetCommentsFeed.isReplie = true
        }
        lGetCommentsFeed.myReplyFormIndex = -1
        lGetCommentsFeed.initials = ""
        lGetCommentsFeed.level = 0
        
        return lGetCommentsFeed
    }
}
