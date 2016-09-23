

import Foundation
import UIKit

open class  CellForRowAtIndex {
    static let sharedInstance = CellForRowAtIndex()
    let defaults : UserDefaults = UserDefaults.standard
    
    var first = 0
    var second  = 0
    var third = 0
    var fourth  = 0
    var fifth  = 0
    var sixth = 0
    var votes = EmoteRating()
    var totalComentsCount = 0
    
    func returnEmoticonCell(_ cell : EmoticonCell) -> EmoticonCell{
        
        
        
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
        if let selected = self.defaults.object(forKey: "\(Global.article_id)") as? String {
            switch "\(selected)" {
            case "1":
                cell.firstEmoticonLabel.textColor = UIColor.red
            case "2":
                cell.secondEmoticonLabel.textColor = UIColor.red
            case "3":
                cell.thirdEmoticonLabel.textColor = UIColor.red
            case "4":
                cell.fourthEmoticonLabel.textColor = UIColor.red
            case "5":
                cell.fifthEmoticonLabel.textColor = UIColor.red
            case "6":
                cell.sixthEmoticonLabel.textColor = UIColor.red
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
            
            cell.firstEmoticonLabel.text = "\(PrivetFunctions.sharedInstance.setRatePercent(votes.first, second: votes.second, thirt: votes.third, fourth: votes.fourth, fifth: votes.fifth, sixt: votes.sixth, element: votes.first))%" ?? "0%"
            cell.secondEmoticonLabel.text = "\(PrivetFunctions.sharedInstance.setRatePercent(votes.first, second: votes.second, thirt: votes.third, fourth: votes.fourth, fifth: votes.fifth, sixt: votes.sixth, element: votes.second))%" ?? "0%"
            cell.thirdEmoticonLabel.text = "\(PrivetFunctions.sharedInstance.setRatePercent(votes.first, second: votes.second, thirt: votes.third, fourth: votes.fourth, fifth: votes.fifth, sixt: votes.sixth, element: votes.third))%" ?? "0%"
            cell.fourthEmoticonLabel.text = "\(PrivetFunctions.sharedInstance.setRatePercent(votes.first, second: votes.second, thirt: votes.third, fourth: votes.fourth, fifth: votes.fifth, sixt: votes.sixth, element: votes.fourth))%" ?? "0%"
            cell.fifthEmoticonLabel.text = "\(PrivetFunctions.sharedInstance.setRatePercent(votes.first, second: votes.second, thirt: votes.third, fourth: votes.fourth, fifth: votes.fifth, sixt: votes.sixth, element: votes.fifth))%" ?? "0%"
            cell.sixthEmoticonLabel.text = "\(PrivetFunctions.sharedInstance.setRatePercent(votes.first, second: votes.second, thirt: votes.third, fourth: votes.fourth, fifth: votes.fifth, sixt: votes.sixth, element: votes.sixth))%" ?? "0%"
            
        }
        
        return cell
        
    }
    
    func returnCommentCell(_ cell : CommentCell ,comment : GetCommentsFeed , date : Date ,newComment : String ,newName : String ) -> CommentCell {
        cell.imageLeftCostraint.constant = CGFloat(Global.leftConstrainCommentSize)
        cell.totalCountLeftConstraint.constant = CGFloat(Global.leftConstrainCommentSize)
        cell.upvoteButtonLeftConstraint.constant = CGFloat(Global.leftConstrainCommentSize)
        cell.initialsLabelLeftConstraints.constant = CGFloat(Global.leftConstrainCommentSize)
        
        cell.userNameLabel.textColor = UIColor.blue
        cell.commentLabel.text = newComment
        cell.userNameLabel.text = newName
        cell.dateLabel.text = TimeAgo.sharedInstance.timeAgoSinceDate(date: date as NSDate, numericDates: true)
        cell.countLabel.text = String(comment.user_points!)
        if comment.up_votes! > 0 {
            cell.upvoteCountLabel.text = String(comment.up_votes!)
            cell.upvoteCountLabel.isHidden = false
        } else {
            cell.upvoteCountLabel.isHidden = true
        }
        if comment.down_votes! > 0 {
            cell.downvoteCountLabel.text  = String(comment.down_votes!)
            cell.downvoteCountLabel.isHidden = false
        } else {
            cell.downvoteCountLabel.isHidden = true
        }
        if comment.replies! > 0 {
            cell.replyCount.text  = String(comment.replies!)
            cell.showReply.isHidden = false
            cell.replyCount.isHidden = false
            cell.showButtonWidth.constant = 40
        } else {
            cell.showButtonWidth.constant = 0
            cell.showReply.isHidden = true
            cell.replyCount.isHidden = true
        }
        if comment.avatar_url != Global.defaultImageUrl && comment.avatar_url != ""  {
            cell.imageForCell = comment.avatar_url
            cell.InitialsLabel.isHidden = true
            cell.userImage.isHidden = false
        } else if comment.avatar_url == ""{
            cell.userImage.isHidden = true
            cell.InitialsLabel.isHidden = false
            cell.InitialsLabel.text = PrivetFunctions.sharedInstance.searchUpperChracters(PrivetFunctions.sharedInstance.decodingString(comment.name!))
        }else {
            cell.userImage.isHidden = true
            cell.InitialsLabel.isHidden = false
            cell.InitialsLabel.text = PrivetFunctions.sharedInstance.searchUpperChracters(PrivetFunctions.sharedInstance.decodingString(comment.name!))
        }
        
        return cell
    }
    
    func returnReplyCell (_ cell : CommentCell ,comment : GetCommentsFeed , date : Date ,newComment : String ,newName : String ) -> CommentCell {
        cell.imageLeftCostraint.constant = CGFloat(Global.leftConstrainReplySize)
        cell.totalCountLeftConstraint.constant = CGFloat(Global.leftConstrainReplySize)
        cell.upvoteButtonLeftConstraint.constant = CGFloat(Global.leftConstrainReplySize)
        cell.initialsLabelLeftConstraints.constant = CGFloat(Global.leftConstrainReplySize)
        
        cell.userNameLabel.textColor = UIColor.blue
        cell.commentLabel.text = newComment
        cell.userNameLabel.text = newName
        if comment.up_votes! > 0 {
            cell.upvoteCountLabel.text = String(comment.up_votes!)
            cell.upvoteCountLabel.isHidden = false
        } else {
            cell.upvoteCountLabel.isHidden = true
        }
        if comment.down_votes! > 0 {
            cell.downvoteCountLabel.text  = String(comment.down_votes!)
            cell.downvoteCountLabel.isHidden = false
        } else {
            cell.downvoteCountLabel.isHidden = true
        }
        if comment.replies! > 0 {
            cell.replyCount.text  = String(comment.replies!)
            cell.showReply.isHidden = false
            cell.replyCount.isHidden = false
            cell.showButtonWidth.constant = 40
        } else {
            cell.showButtonWidth.constant = 0
            cell.showReply.isHidden = true
            cell.replyCount.isHidden = true
        }
        cell.dateLabel.text = TimeAgo.sharedInstance.timeAgoSinceDate(date: date as NSDate, numericDates: true)
        cell.countLabel.text = String(comment.user_points!)
        if comment.avatar_url != Global.defaultImageUrl && comment.avatar_url != ""  {
            cell.imageForCell = comment.avatar_url
            cell.InitialsLabel.isHidden = true
            cell.userImage.isHidden = false
        } else if comment.avatar_url == ""{
            cell.userImage.isHidden = true
            cell.InitialsLabel.isHidden = false
            cell.InitialsLabel.text = PrivetFunctions.sharedInstance.searchUpperChracters(PrivetFunctions.sharedInstance.decodingString(comment.name!))
        } else {
            cell.userImage.isHidden = true
            cell.InitialsLabel.isHidden = false
            cell.InitialsLabel.text = PrivetFunctions.sharedInstance.searchUpperChracters(PrivetFunctions.sharedInstance.decodingString(comment.name!))
        }
        return cell
    }
    
    func returnAddCommentCellForComment(_ cell : AddCommentCell) -> AddCommentCell{
        if self.defaults.object(forKey: "email") as? String != nil {
            cell.emailTextField.text = self.defaults.object(forKey: "email") as? String
            cell.emailTextField.isEnabled = false
            cell.logOut.isHidden = false
        } else{
            cell.logOut.isHidden = true
            cell.emailTextField.isEnabled = true
        }
        if self.defaults.object(forKey: "name") as? String != nil {
            cell.nameTextField.text = self.defaults.object(forKey: "name") as? String
            cell.nameTextField.isEnabled = false
        } else {
            cell.nameTextField.isEnabled = true
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
    
    func returnAddCommentCellForReply(_ cell : AddCommentCell , object : AddReply) -> AddCommentCell{
        
        cell.totalCountHeight.constant = 0
        cell.logOutButtonHeight.constant = 0
        cell.leftConstrainSize.constant = 8
        cell.logOut.isHidden = true
        if let lname = self.defaults.object(forKey: "name") as? String {
            cell.nameTextField.text = lname
            cell.nameTextField.isEnabled = false
        } else if self.defaults.object(forKey: "name") == nil{
            cell.nameTextField.text = ""
            cell.nameTextField.isEnabled = true
        }
        if let lemail = self.defaults.object(forKey: "email") as? String {
            cell.emailTextField.text = lemail
            cell.logOut.isHidden = true
            cell.emailTextField.isEnabled = false
        } else if self.defaults.object(forKey: "email") == nil {
            cell.emailTextField.text = ""
            cell.logOut.isHidden = true
            cell.emailTextField.isEnabled = true
        }
        return cell
    }
    
    func returnLoadMoreCell(_ cell : LoadMoreCell ,object : LoadMore) -> LoadMoreCell{
        let loadMoreCell = cell
        if object.showLoadMoreButton == true {
            loadMoreCell.heightButton.constant = 30
            loadMoreCell.heightActivitiIndicator.constant = 37
            loadMoreCell.activityIndicator.isHidden = true
            loadMoreCell.loadMore.isHidden = false
        } else {
            loadMoreCell.heightButton.constant = 0
            loadMoreCell.heightActivitiIndicator.constant = 0
            loadMoreCell.loadMore.isHidden = true
            loadMoreCell.activityIndicator.isHidden = true
        }
        return loadMoreCell
    }
    
    
    func returnCellForRow(_ object : AnyObject , tableView : UITableView) -> UITableViewCell{
        var cell = UITableViewCell()
        if object is LoadMore {
            let objectForcell : LoadMore = object as! LoadMore
            var cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell") as! LoadMoreCell
            cell = returnLoadMoreCell(cell, object: objectForcell)
            return cell
        } else if object is AddComment {
            var cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell") as! AddCommentCell
            cell = returnAddCommentCellForComment(cell)
            return cell
        } else if object is Emoticon {
            var cell = tableView.dequeueReusableCell(withIdentifier: "EmoticonCell") as! EmoticonCell
            cell = returnEmoticonCell(cell)
            return cell
        } else if object is AddReply {
            let objectForcell : AddReply = object as! AddReply
            var cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell") as! AddCommentCell
            cell = returnAddCommentCellForReply(cell, object: objectForcell)
            return cell
        } else if object is WebView {
            let objectForcell : WebView = object as! WebView
            if objectForcell.advertisingBanner == true {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "WebViewCell") as! WebViewCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContentWebViewCell") as! ContentWebViewCell
                return cell
            }
            cell = tableView.dequeueReusableCell(withIdentifier: "WebViewCell") as! WebViewCell
        } else if object is GetCommentsFeed {
            let objectForcell : GetCommentsFeed = object as! GetCommentsFeed
            if objectForcell.isReplie == true{
                var cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
                cell = returnReplyCell(cell, comment: objectForcell, date: PrivetFunctions.sharedInstance.setDateInFofmat(objectForcell.ts!) as Date, newComment: PrivetFunctions.sharedInstance.decodingString(objectForcell.comment!), newName: PrivetFunctions.sharedInstance.decodingString(objectForcell.name!))
                return cell
            } else {
                var cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
                cell = returnCommentCell(cell, comment: objectForcell, date: PrivetFunctions.sharedInstance.setDateInFofmat(objectForcell.ts!) as Date, newComment: PrivetFunctions.sharedInstance.decodingString(objectForcell.comment!), newName: PrivetFunctions.sharedInstance.decodingString(objectForcell.name!))
                return cell
            }
        }
        return cell
    }
}
