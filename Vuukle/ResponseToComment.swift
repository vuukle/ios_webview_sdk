

import Foundation


class ResponseToComment {
    
    
    var result : String?
    var comment_id : String?
    var isModeration : String?
    
    static func getResponseToComment(pDict : NSDictionary) -> ResponseToComment {
        
        let lResponseToComment = ResponseToComment()
                lResponseToComment.result = pDict["result"] as? String ?? ""
                lResponseToComment.comment_id = pDict["comment_id"] as? String ?? ""
                lResponseToComment.isModeration = pDict["isModeration"] as? String ?? ""

        
        return lResponseToComment
    }
    
    
}