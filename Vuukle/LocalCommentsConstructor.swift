

import Foundation

class LocalCommentsConstructor{
    static let sharedInstance = LocalCommentsConstructor()
    let defaults : UserDefaults = UserDefaults.standard
    
    func addComment(_ comment : String,name :String ,ts : String ,email : String ,up_votes : Int ,down_votes : Int ,comment_id : String ,replies : Int , user_id : String ,avatar_url : String ,parent_id : String , user_points : Int ,myComment : Bool, level : Int) -> CommentsFeed {
        let addComment = CommentsFeed()
        
        addComment.comment = comment
        addComment.name = name
        addComment.up_votes = up_votes
        addComment.down_votes = down_votes
        addComment.ts = ts
        addComment.comment_id = comment_id
        addComment.replies = replies
        addComment.email = email
        addComment.user_id = user_id
        addComment.avatar_url = avatar_url
        addComment.parent_id = parent_id
        addComment.user_points = user_points
        addComment.myComment = myComment
        addComment.isReplie = false
        addComment.level = level
        
        return addComment
    }
    
    func addReply(_ comment : String,name :String ,ts : String ,email : String ,up_votes : Int ,down_votes : Int ,comment_id : String ,replies : Int , user_id : String ,avatar_url : String ,parent_id : String , user_points : Int ,myComment : Bool, level : Int) -> CommentsFeed {
        let addComment = CommentsFeed()
        
        addComment.comment = comment
        addComment.name = name
        addComment.up_votes = up_votes
        addComment.down_votes = down_votes
        addComment.ts = ts
        addComment.comment_id = comment_id
        addComment.replies = replies
        addComment.email = email
        addComment.user_id = user_id
        addComment.avatar_url = avatar_url
        addComment.parent_id = parent_id
        addComment.user_points = user_points
        addComment.myComment = myComment
        addComment.isReplie = true
        addComment.level = level
        
        return addComment
    }
}
