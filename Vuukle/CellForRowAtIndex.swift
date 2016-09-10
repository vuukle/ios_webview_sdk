

import Foundation
import UIKit

public class  CellForRowAtIndex{
    static let sharedInstance = CellForRowAtIndex()
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    
    func returnEmoticonCell(cell : EmoticonCell, firstCount : Int , secondCount: Int ,thirdCount: Int , fourthCount: Int , fifthCount :Int , sixthCount : Int , firstPercent : Double ,secondPercent : Double ,thirdPercent : Double ,fourthPercent : Double ,fifthPercent : Double ,sixthPercent : Double ) -> EmoticonCell{
        if Global.showEmoticonCell == false {
            cell.viewHeight.constant = 0
            cell.titleHeight.constant = 0
            cell.firstEmoticonImageHeight.constant = 0
            cell.secondEmoticonImageHeight.constant = 0
            cell.thirdEmoticonImageHeight.constant = 0
            cell.fourthEmoticonImageHeight.constant = 0
            cell.fifthEmoticonImageHeight.constant = 0
            cell.sixthEmoticonImageHeight.constant = 0
        }
        if let selected = self.defaults.objectForKey("\(Global.article_id)") as? String {
            switch "\(selected)" {
            case "1":
                cell.firstEmoticonLabel.textColor = UIColor.redColor()
            case "2":
                cell.secondEmoticonLabel.textColor = UIColor.redColor()
            case "3":
                cell.thirdEmoticonLabel.textColor = UIColor.redColor()
            case "4":
                cell.fourthEmoticonLabel.textColor = UIColor.redColor()
            case "5":
                cell.fifthEmoticonLabel.textColor = UIColor.redColor()
            case "6":
                cell.sixthEmoticonLabel.textColor = UIColor.redColor()
            default:
                break
            }
        }
        
        cell.countFirstEmoticonLabel.text = "\(firstCount)"
        cell.countSecondEmoticonLabel.text = "\(secondCount)"
        cell.countThirdEmoticonLabel.text = "\(thirdCount)"
        cell.countFourthEmoticonLabel.text = "\(fourthCount)"
        cell.countFifthEmoticonLabel.text = "\(fifthCount)"
        cell.countSixthEmoticonLabel.text = "\(sixthCount)"
        
        cell.firstEmoticonLabel.text = "\(PrivetFunctions.sharedInstance.removeDecimal(fifthPercent))%"
        cell.secondEmoticonLabel.text = "\(PrivetFunctions.sharedInstance.removeDecimal(secondPercent))%"
        cell.thirdEmoticonLabel.text = "\(PrivetFunctions.sharedInstance.removeDecimal(thirdPercent))%"
        cell.fourthEmoticonLabel.text = "\(PrivetFunctions.sharedInstance.removeDecimal(fourthPercent))%"
        cell.fifthEmoticonLabel.text = "\(PrivetFunctions.sharedInstance.removeDecimal(fifthPercent))%"
        cell.sixthEmoticonLabel.text = "\(PrivetFunctions.sharedInstance.removeDecimal(sixthPercent))%"
        
        return cell
    }
    
    func returnCommentCell(cell : CommentCell ,comment : GetCommentsFeed , date : NSDate ,newComment : String ,newName : String ) -> CommentCell {
        cell.imageLeftCostraint.constant = CGFloat(Global.leftConstrainCommentSize)
        cell.totalCountLeftConstraint.constant = CGFloat(Global.leftConstrainCommentSize)
        cell.upvoteButtonLeftConstraint.constant = CGFloat(Global.leftConstrainCommentSize)
        cell.initialsLabelLeftConstraints.constant = CGFloat(Global.leftConstrainCommentSize)
        
        cell.userNameLabel.textColor = UIColor.blueColor()
        cell.commentLabel.text = newComment
        cell.userNameLabel.text = newName
        if comment.up_votes > 0 {
            cell.upvoteCountLabel.text = String(comment.up_votes!)
            cell.upvoteCountLabel.hidden = false
        } else {
            cell.upvoteCountLabel.hidden = true
        }
        if comment.down_votes > 0 {
            cell.downvoteCountLabel.text  = String(comment.down_votes!)
            cell.downvoteCountLabel.hidden = false
        } else {
            cell.downvoteCountLabel.hidden = true
        }
        if comment.replies > 0 {
            cell.replyCount.text  = String(comment.replies!)
            cell.replyCount.hidden = false
        } else {
            cell.replyCount.hidden = true
        }
        cell.dateLabel.text = TimeAgo.sharedInstance.timeAgoSinceDate(date, numericDates: true)
        cell.countLabel.text = String(comment.user_points!)
        if comment.avatar_url != Global.defaultImageUrl && comment.avatar_url != ""  {
            cell.imageForCell = comment.avatar_url
            cell.InitialsLabel.hidden = true
            cell.userImage.hidden = false
        } else if comment.avatar_url == ""{
            cell.userImage.hidden = true
            cell.InitialsLabel.hidden = false
            cell.InitialsLabel.text = comment.initials
        }else {
            cell.userImage.hidden = true
            cell.InitialsLabel.hidden = false
            cell.InitialsLabel.text = comment.initials
        }
        
        return cell
    }
    
    func returnReplyCell (cell : CommentCell ,comment : GetCommentsFeed , date : NSDate ,newComment : String ,newName : String ) -> CommentCell {
        cell.imageLeftCostraint.constant = CGFloat(Global.leftConstrainReplySize)
        cell.totalCountLeftConstraint.constant = CGFloat(Global.leftConstrainReplySize)
        cell.upvoteButtonLeftConstraint.constant = CGFloat(Global.leftConstrainReplySize)
        cell.initialsLabelLeftConstraints.constant = CGFloat(Global.leftConstrainReplySize)
        
        cell.userNameLabel.textColor = UIColor.blueColor()
        cell.commentLabel.text = newComment
        cell.userNameLabel.text = newName
        if comment.up_votes > 0 {
            cell.upvoteCountLabel.text = String(comment.up_votes!)
            cell.upvoteCountLabel.hidden = false
        } else {
            cell.upvoteCountLabel.hidden = true
        }
        if comment.down_votes > 0 {
            cell.downvoteCountLabel.text  = String(comment.down_votes!)
            cell.downvoteCountLabel.hidden = false
        } else {
            cell.downvoteCountLabel.hidden = true
        }
        if comment.replies > 0 {
            cell.replyCount.text  = String(comment.replies!)
            cell.replyCount.hidden = false
        } else {
            cell.replyCount.hidden = true
        }
        cell.dateLabel.text = TimeAgo.sharedInstance.timeAgoSinceDate(date, numericDates: true)
        cell.countLabel.text = String(comment.user_points!)
        if comment.avatar_url != Global.defaultImageUrl && comment.avatar_url != ""  {
            cell.imageForCell = comment.avatar_url
            cell.InitialsLabel.hidden = true
            cell.userImage.hidden = false
        } else if comment.avatar_url == ""{
            cell.userImage.hidden = true
            cell.InitialsLabel.hidden = false
            cell.InitialsLabel.text = comment.initials
        } else {
            cell.userImage.hidden = true
            cell.InitialsLabel.hidden = false
            cell.InitialsLabel.text = comment.initials
        }
        return cell
    }
    
    func returnAddCommentCellForComment(cell : AddCommentCell , totalComentsCount : Int ) -> AddCommentCell{
        if self.defaults.objectForKey("email") as? String != nil {
            cell.emailTextField.text = self.defaults.objectForKey("email") as? String
            cell.emailTextField.enabled = false
            cell.logOut.hidden = false
        } else{
            cell.logOut.hidden = true
            cell.emailTextField.enabled = true
        }
        if self.defaults.objectForKey("name") as? String != nil {
            cell.nameTextField.text = self.defaults.objectForKey("name") as? String
            cell.nameTextField.enabled = false
        } else {
            cell.nameTextField.enabled = true
        }
        if totalComentsCount > 1 {
            cell.totalCount.text = "Total comments: \(totalComentsCount)"
        } else if totalComentsCount == 0 {
            cell.totalCount.text = "Leave a comment"
        } else if totalComentsCount == 1 {
            cell.totalCount.text = "Total comment: 1"
        }
        
        cell.leftConstrainSize.constant = 5
        cell.totalCountHeight.constant = 21
        cell.logOutButtonHeight.constant = 26
        return cell
    }
    
    func returnAddCommentCellForReply(cell : AddCommentCell) -> AddCommentCell{
        cell.totalCountHeight.constant = 0
        cell.logOutButtonHeight.constant = 0
        cell.leftConstrainSize.constant = 8
        cell.logOut.hidden = true
        if let lname = self.defaults.objectForKey("name") as? String {
            cell.nameTextField.text = lname
            cell.nameTextField.enabled = false
        } else if self.defaults.objectForKey("name") == nil{
            cell.nameTextField.text = ""
            cell.nameTextField.enabled = true
        }
        if let lemail = self.defaults.objectForKey("email") as? String {
            cell.emailTextField.text = lemail
            cell.logOut.hidden = true
            cell.emailTextField.enabled = false
        } else if self.defaults.objectForKey("email") == nil {
            cell.emailTextField.text = ""
            cell.logOut.hidden = true
            cell.emailTextField.enabled = true
        }
        return cell
    }
}