

import Foundation
import UIKit

class PrivetFunctions {
    static let sharedInstance = PrivetFunctions()
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    func addComment(comment : String,name :String ,ts : String ,email : String ,up_votes : Int ,down_votes : Int ,comment_id : String ,replies : Int , user_id : String ,avatar_url : String ,parent_id : String , user_points : Int ,myComment : Bool ,isReplie : Bool , level : Int) -> GetCommentsFeed {
        let addComment = GetCommentsFeed()
        
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
        addComment.isReplie = isReplie
        addComment.level = level
        
        return addComment
    }

    func showAlert(title : String ,message : String) {
        let ErrorAlert = UIAlertView(title: "\(title)", message: "\(message)", delegate: self, cancelButtonTitle: "Ok")
        ErrorAlert.show()
    }
    
    func checkFields(name : String , email : String , comment : String) -> Bool {
        var allFill = false
        if name != "" && email != "" && comment != "" && comment != "Please write a comment..."{
            if ((email.rangeOfString("@")) != nil) && ((email.rangeOfString(".")) != nil) {
                allFill = true
            } else {
                showAlert( "Please enter a correct email!",message: "")
                allFill = false
            }
        } else if name == ""{
            showAlert("Please enter a name!", message: "")
            allFill = false
        } else if email == ""{
            showAlert("Please enter a email!", message: "")
            allFill = false
        } else if comment == "Please write a comment..."{
            showAlert("Please enter a comment!", message: "")
            allFill = false
        }
        return allFill
    }
    
    func removeDecimal(value : Double) -> String{
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 0
        return formatter.stringFromNumber(value)!
        
    }
    
}