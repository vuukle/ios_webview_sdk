

import Foundation
import UIKit

public class  CellForRowAtIndex {
    static let sharedInstance = CellForRowAtIndex()
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var first = 0
    var second  = 0
    var third = 0
    var fourth  = 0
    var fifth  = 0
    var sixth = 0
    var votes = EmoteRating()
    var totalComentsCount = 0
    
    func returnEmoticonCell(cell : EmoticonCell) -> EmoticonCell{
        
        
        
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
        if first == 0 && second == 0 && third == 0 && fourth == 0 && fifth == 0 && sixth == 0{
            cell.countFirstEmoticonLabel.text = "0"
            cell.countSecondEmoticonLabel.text = "0"
            cell.countThirdEmoticonLabel.text = "0"
            cell.countFourthEmoticonLabel.text = "0"
            cell.countFifthEmoticonLabel.text = "0"
            cell.countSixthEmoticonLabel.text = "0"
            
            cell.firstEmoticonLabel.text = "0%"
            cell.secondEmoticonLabel.text = "0%"
            cell.thirdEmoticonLabel.text = "0%"
            cell.fourthEmoticonLabel.text = "0%"
            cell.fifthEmoticonLabel.text = "0%"
            cell.sixthEmoticonLabel.text = "0%"
            
            
        } else {
            
            cell.countFirstEmoticonLabel.text = "\(first)" ?? "0"
            cell.countSecondEmoticonLabel.text = "\(second)" ?? "0"
            cell.countThirdEmoticonLabel.text = "\(third)" ?? "0"
            cell.countFourthEmoticonLabel.text = "\(fourth)" ?? "0"
            cell.countFifthEmoticonLabel.text = "\(fifth)" ?? "0"
            cell.countSixthEmoticonLabel.text = "\(sixth)" ?? "0"
            
            cell.firstEmoticonLabel.text = "\(PrivetFunctions.sharedInstance.setRatePercentage(votes, element: votes.first))%" ?? "0%"
            cell.secondEmoticonLabel.text = "\(PrivetFunctions.sharedInstance.setRatePercentage(votes, element: votes.second))%" ?? "0%"
            cell.thirdEmoticonLabel.text = "\(PrivetFunctions.sharedInstance.setRatePercentage(votes, element: votes.third))%" ?? "0%"
            cell.fourthEmoticonLabel.text = "\(PrivetFunctions.sharedInstance.setRatePercentage(votes, element: votes.fourth))%" ?? "0%"
            cell.fifthEmoticonLabel.text = "\(PrivetFunctions.sharedInstance.setRatePercentage(votes, element: votes.fifth))%" ?? "0%"
            cell.sixthEmoticonLabel.text = "\(PrivetFunctions.sharedInstance.setRatePercentage(votes, element: votes.sixth))%" ?? "0%"
            
        }
        
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
        cell.dateLabel.text = TimeAgo.sharedInstance.timeAgoSinceDate(date, numericDates: true)
        cell.countLabel.text = String(comment.user_points!)
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
            cell.showReply.hidden = false
            cell.replyCount.hidden = false
            cell.showButtonWidth.constant = 40
        } else {
            cell.showButtonWidth.constant = 0
            cell.showReply.hidden = true
            cell.replyCount.hidden = true
        }
        if comment.avatar_url != Global.defaultImageUrl && comment.avatar_url != ""  {
            cell.imageForCell = comment.avatar_url
            cell.InitialsLabel.hidden = true
            cell.userImage.hidden = false
        } else if comment.avatar_url == ""{
            cell.userImage.hidden = true
            cell.InitialsLabel.hidden = false
            cell.InitialsLabel.text = PrivetFunctions.sharedInstance.searchUpperChracters(PrivetFunctions.sharedInstance.decodingString(comment.name!))
        }else {
            cell.userImage.hidden = true
            cell.InitialsLabel.hidden = false
            cell.InitialsLabel.text = PrivetFunctions.sharedInstance.searchUpperChracters(PrivetFunctions.sharedInstance.decodingString(comment.name!))
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
            cell.showReply.hidden = false
            cell.replyCount.hidden = false
            cell.showButtonWidth.constant = 40
        } else {
            cell.showButtonWidth.constant = 0
            cell.showReply.hidden = true
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
            cell.InitialsLabel.text = PrivetFunctions.sharedInstance.searchUpperChracters(PrivetFunctions.sharedInstance.decodingString(comment.name!))
        } else {
            cell.userImage.hidden = true
            cell.InitialsLabel.hidden = false
            cell.InitialsLabel.text = PrivetFunctions.sharedInstance.searchUpperChracters(PrivetFunctions.sharedInstance.decodingString(comment.name!))
        }
        return cell
    }
    
    func returnAddCommentCellForComment(cell : AddCommentCell) -> AddCommentCell{
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
    
    func returnAddCommentCellForReply(cell : AddCommentCell , object : AddReply) -> AddCommentCell{
        
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
    
    func returnLoadMoreCell(cell : LoadMoreCell ,object : LoadMore) -> LoadMoreCell{
        let loadMoreCell = cell
        if object.showLoadMoreButton == true {
            loadMoreCell.heightButton.constant = 30
            loadMoreCell.heightActivitiIndicator.constant = 37
            loadMoreCell.activityIndicator.hidden = true
            loadMoreCell.loadMore.hidden = false
        } else {
            loadMoreCell.heightButton.constant = 0
            loadMoreCell.heightActivitiIndicator.constant = 0
            loadMoreCell.loadMore.hidden = true
            loadMoreCell.activityIndicator.hidden = true
        }
        return loadMoreCell
    }

    
    func returnCellForRow(object : AnyObject , tableView : UITableView) -> UITableViewCell{
        var cell = UITableViewCell()
        if object is LoadMore {
            let objectForcell : LoadMore = object as! LoadMore
            var cell = tableView.dequeueReusableCellWithIdentifier("LoadMoreCell") as! LoadMoreCell
            cell = returnLoadMoreCell(cell, object: objectForcell)
            return cell
        } else if object is AddComment {
            var cell = tableView.dequeueReusableCellWithIdentifier("AddCommentCell") as! AddCommentCell
            cell = returnAddCommentCellForComment(cell)
            return cell
        } else if object is Emoticon {
            var cell = tableView.dequeueReusableCellWithIdentifier("EmoticonCell") as! EmoticonCell
            cell = returnEmoticonCell(cell)
            return cell
        } else if object is AddReply {
            let objectForcell : AddReply = object as! AddReply
            var cell = tableView.dequeueReusableCellWithIdentifier("AddCommentCell") as! AddCommentCell
            cell = returnAddCommentCellForReply(cell, object: objectForcell)
            return cell
        } else if object is WebView {
            let objectForcell : WebView = object as! WebView
            if objectForcell.advertisingBanner == true {
               let  cell = tableView.dequeueReusableCellWithIdentifier("WebViewCell") as! WebViewCell
                return cell
            } else {
               let cell = tableView.dequeueReusableCellWithIdentifier("ContentWebViewCell") as! ContentWebViewCell
                return cell
            }
            cell = tableView.dequeueReusableCellWithIdentifier("WebViewCell") as! WebViewCell
        } else if object is GetCommentsFeed {
            let objectForcell : GetCommentsFeed = object as! GetCommentsFeed
            if objectForcell.isReplie == true{
                var cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as! CommentCell
                cell = returnReplyCell(cell, comment: objectForcell, date: PrivetFunctions.sharedInstance.setDateInFofmat(objectForcell.ts!), newComment: PrivetFunctions.sharedInstance.decodingString(objectForcell.comment!), newName: PrivetFunctions.sharedInstance.decodingString(objectForcell.name!))
                return cell
            } else {
                var cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as! CommentCell
                cell = returnCommentCell(cell, comment: objectForcell, date: PrivetFunctions.sharedInstance.setDateInFofmat(objectForcell.ts!), newComment: PrivetFunctions.sharedInstance.decodingString(objectForcell.comment!), newName: PrivetFunctions.sharedInstance.decodingString(objectForcell.name!))
                return cell
            }
        }
        return cell
    }
}