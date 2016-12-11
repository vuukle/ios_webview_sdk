
import Foundation


class ResponseToComment {
    
    var result: String?
    var comment_id: String?
    var isModeration: String?
    var statusCode: Int?
    
    static func getResponseToComment(_ pDict : NSDictionary) -> ResponseToComment {
        
        let lResponseToComment = ResponseToComment()
        lResponseToComment.result = pDict["result"] as? String ?? ""
        lResponseToComment.comment_id = pDict["comment_id"] as? String ?? ""
        lResponseToComment.isModeration = pDict["isModeration"] as? String ?? ""
        lResponseToComment.statusCode = pDict["statusCode"] as? Int ?? 0
        
        return lResponseToComment
    }
}
