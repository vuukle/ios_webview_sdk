

import Foundation
import UIKit

public class  CellConstructor {
    static let sharedInstance = CellConstructor()
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()

    public var totalComentsCount = 0
    
    func returnEmoticonCell(cell : EmoticonCell) -> EmoticonCell{
        
        var cell = cell
        cell.thanksLabel.hidden = true
        
        if Global.showEmoticonCell == false {
            cell.hidden = true
            cell = CellConstraintsConstructor.sharedInstance.setEmoticonCellConstraint(cell)
        }
        
        let selected = self.defaults.objectForKey("\(Global.article_id)") as? String
        
        if selected != nil && selected != ""{
            cell.thanksLabel.hidden = false
            print("\(selected) 1488")
            switch "\(selected)" {
            case "firstEmoticonSelected":
                cell.firstEmoticonLabel.textColor = UIColor.redColor()
                cell.countFirstEmoticonLabel.textColor = UIColor.redColor()
            case "secondEmoticonSelected":
                cell.secondEmoticonLabel.textColor = UIColor.redColor()
                cell.countSecondEmoticonLabel.textColor = UIColor.redColor()
            case "thirdEmoticonSelected":
                cell.thirdEmoticonLabel.textColor = UIColor.redColor()
                cell.countThirdEmoticonLabel.textColor = UIColor.redColor()
            case "fourthEmoticonSelected":
                cell.fourthEmoticonLabel.textColor = UIColor.redColor()
                cell.countFourthEmoticonLabel.textColor = UIColor.redColor()
            case "fifthEmoticonSelected":
                cell.fifthEmoticonLabel.textColor = UIColor.redColor()
                cell.countFifthEmoticonLabel.textColor = UIColor.redColor()
            case "sixthEmoticonSelected":
                cell.sixthEmoticonLabel.textColor = UIColor.redColor()
                cell.countSixthEmoticonLabel.textColor = UIColor.redColor()
            default:
                break
            }
        }
        if Global.firstEmoticonVotesCount == 0 && Global.secondEmoticonVotesCount == 0 && Global.thirdEmoticonVotesCount == 0 && Global.fourthEmoticonVotesCount == 0 && Global.fifthEmoticonVotesCount == 0 && Global.sixthEmoticonVotesCount == 0{
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
            
            cell.countFirstEmoticonLabel.text = "\(Global.firstEmoticonVotesCount)" ?? "0"
            cell.countSecondEmoticonLabel.text = "\(Global.secondEmoticonVotesCount)" ?? "0"
            cell.countThirdEmoticonLabel.text = "\(Global.thirdEmoticonVotesCount)" ?? "0"
            cell.countFourthEmoticonLabel.text = "\(Global.fourthEmoticonVotesCount)" ?? "0"
            cell.countFifthEmoticonLabel.text = "\(Global.fifthEmoticonVotesCount)" ?? "0"
            cell.countSixthEmoticonLabel.text = "\(Global.sixthEmoticonVotesCount)" ?? "0"
            
            cell.firstEmoticonLabel.text = "\(ParametersConstructor.sharedInstance.setRatePercentage(Global.votes, element: Global.votes.first))%" ?? "0%"
            cell.secondEmoticonLabel.text = "\(ParametersConstructor.sharedInstance.setRatePercentage(Global.votes, element: Global.votes.second))%" ?? "0%"
            cell.thirdEmoticonLabel.text = "\(ParametersConstructor.sharedInstance.setRatePercentage(Global.votes, element: Global.votes.third))%" ?? "0%"
            cell.fourthEmoticonLabel.text = "\(ParametersConstructor.sharedInstance.setRatePercentage(Global.votes, element: Global.votes.fourth))%" ?? "0%"
            cell.fifthEmoticonLabel.text = "\(ParametersConstructor.sharedInstance.setRatePercentage(Global.votes, element: Global.votes.fifth))%" ?? "0%"
            cell.sixthEmoticonLabel.text = "\(ParametersConstructor.sharedInstance.setRatePercentage(Global.votes, element: Global.votes.sixth))%" ?? "0%"
            
        }
        
        return cell
        
    }
    
    func returnCommentCell(cell : CommentCell ,comment : CommentsFeed , date : NSDate ,newComment : String ,newName : String ) -> CommentCell {
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
            cell.InitialsLabel.text = ParametersConstructor.sharedInstance.searchUpperChracters(ParametersConstructor.sharedInstance.decodingString(comment.name!))
        }else {
            cell.userImage.hidden = true
            cell.InitialsLabel.hidden = false
            cell.InitialsLabel.text = ParametersConstructor.sharedInstance.searchUpperChracters(ParametersConstructor.sharedInstance.decodingString(comment.name!))
        }
        
        return cell
    }
    
    func returnReplyCell (cell : CommentCell ,comment : CommentsFeed , date : NSDate ,newComment : String ,newName : String ) -> CommentCell {
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
            cell.InitialsLabel.text = ParametersConstructor.sharedInstance.searchUpperChracters(ParametersConstructor.sharedInstance.decodingString(comment.name!))
        } else {
            cell.userImage.hidden = true
            cell.InitialsLabel.hidden = false
            cell.InitialsLabel.text = ParametersConstructor.sharedInstance.searchUpperChracters(ParametersConstructor.sharedInstance.decodingString(comment.name!))
        }
        return cell
    }
    
    func returnAddCommentCellForComment(cell : AddCommentCell) -> AddCommentCell{
        
         var cell = CellConstraintsConstructor.sharedInstance.setAddCommentCellConstraints(cell)
        
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
        
        return cell
    }
    
    func returnAddCommentCellForReply(cell : AddCommentCell , object : ReplyForm) -> AddCommentCell{
        
        
        var cell = CellConstraintsConstructor.sharedInstance.setAddCommentCellForReplyConstraints(cell)
        
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
        } else if object is CommentForm {
            var cell = tableView.dequeueReusableCellWithIdentifier("AddCommentCell") as! AddCommentCell
            cell = returnAddCommentCellForComment(cell)
            return cell
        } else if object is Emoticon {
            var cell = tableView.dequeueReusableCellWithIdentifier("EmoticonCell") as! EmoticonCell
            cell = returnEmoticonCell(cell)
            return cell
        } else if object is ReplyForm {
            let objectForcell : ReplyForm = object as! ReplyForm
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
        } else if object is CommentsFeed {
            let objectForcell : CommentsFeed = object as! CommentsFeed
            if objectForcell.isReplie == true{
                var cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as! CommentCell
                cell = returnReplyCell(cell, comment: objectForcell, date: ParametersConstructor.sharedInstance.setDateInFofmat(objectForcell.ts!), newComment: ParametersConstructor.sharedInstance.decodingString(objectForcell.comment!), newName: ParametersConstructor.sharedInstance.decodingString(objectForcell.name!))
                return cell
            } else {
                var cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as! CommentCell
                cell = returnCommentCell(cell, comment: objectForcell, date: ParametersConstructor.sharedInstance.setDateInFofmat(objectForcell.ts!), newComment: ParametersConstructor.sharedInstance.decodingString(objectForcell.comment!), newName: ParametersConstructor.sharedInstance.decodingString(objectForcell.name!))
                return cell
            }
        }
        return cell
    }
}