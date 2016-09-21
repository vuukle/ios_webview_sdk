

import Foundation
import UIKit
import Social


class PrivetFunctions {
    static let sharedInstance = PrivetFunctions()
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    func addComment(comment : String,name :String ,ts : String ,email : String ,up_votes : Int ,down_votes : Int ,comment_id : String ,replies : Int , user_id : String ,avatar_url : String ,parent_id : String , user_points : Int ,myComment : Bool, level : Int) -> GetCommentsFeed {
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
        addComment.isReplie = false
        addComment.level = level
        
        return addComment
    }
    
    func addReply(comment : String,name :String ,ts : String ,email : String ,up_votes : Int ,down_votes : Int ,comment_id : String ,replies : Int , user_id : String ,avatar_url : String ,parent_id : String , user_points : Int ,myComment : Bool, level : Int) -> GetCommentsFeed {
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
        addComment.isReplie = true
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
    
    func setDateInFofmat(dateInString : String) -> NSDate{
        var date = NSDate()
        if dateInString != "" {
            let dateString:String = dateInString
            let dateFormat = NSDateFormatter.init()
            dateFormat.dateStyle = .FullStyle
            dateFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
            date = dateFormat.dateFromString(dateString)!
        }
        return date
    }
    
    func encodingString(string : String) -> String{
        let stringToEncoding = string.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        return stringToEncoding!
        
    }
    
    func decodingString(string : String) -> String{
        let stringToDecoding = string.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        return stringToDecoding
    }
    
    func setRatePercentage (rating : EmoteRating, element : Int)  -> Int{
        let sume = rating.first + rating.second + rating.third + rating.fourth + rating.fifth + rating.sixth
        let percent = (element * 100)/sume
        return percent
    }

    
    func searchUpperChracters(fullName: String) -> String{
        var output1 = ""
        var output2 = ""
        var output = ""
        var sname = ""
        var fname = ""
        if fullName != "" {
            
            var fullNameComponents = fullName.componentsSeparatedByString(" ")
            
            fname = fullNameComponents.count > 0 ? fullNameComponents[0]: ""
            sname = fullNameComponents.count > 1 ? fullNameComponents[1]: ""
            fname = fname.capitalizedString
            sname = sname.capitalizedString
            for chr in fname.characters {
                if output1.characters.count != 1 {
                    output1 = String(chr)
                }
            }
            for chr in sname.characters {
                if output2.characters.count != 1 {
                    output2 = String(chr)
                }
            }
            output = "\(output1)\(output2)"
        }
        return output
    }
    
    func setRate(article_id : String ,emote : Int , tableView : UITableView) {
        
        if  self.defaults.objectForKey("\(article_id)") as? String == nil{
            self.defaults.setObject("\(emote)", forKey: "\(article_id)")
            self.defaults.synchronize()
            PrivetFunctions.sharedInstance.showAlert( "Voted!",message: "You just voted!")
            NetworkManager.sharedInstance.setRaring(article_id, emote: emote) { (response) in
                switch emote {
                case 1:
                    CellForRowAtIndex.sharedInstance.first += 1
                case 2:
                    CellForRowAtIndex.sharedInstance.second += 1
                case 3:
                    CellForRowAtIndex.sharedInstance.third += 1
                case 4:
                    CellForRowAtIndex.sharedInstance.fourth += 1
                case 5:
                    CellForRowAtIndex.sharedInstance.fifth += 1
                case 6:
                    CellForRowAtIndex.sharedInstance.sixth += 1
                default:
                    break
                }
                tableView.reloadData()
            }
            
        } else {
            PrivetFunctions.sharedInstance.showAlert( "You have already voted!",message: "")
        }
    }
    
    func removeDecimal(value : Double) -> String{
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 0
        return formatter.stringFromNumber(value)!
        
    }
    
    func setEmoticonCountVotes (data : EmoteRating){
        CellForRowAtIndex.sharedInstance.first = data.first
        CellForRowAtIndex.sharedInstance.second = data.second
        CellForRowAtIndex.sharedInstance.third = data.third
        CellForRowAtIndex.sharedInstance.fourth = data.fourth
        CellForRowAtIndex.sharedInstance.fifth = data.fifth
        CellForRowAtIndex.sharedInstance.sixth = data.sixth
        CellForRowAtIndex.sharedInstance.votes = data
        
    }
}