

import Foundation
import UIKit

open class  CellConstructor {
    static let sharedInstance = CellConstructor()
    let defaults : UserDefaults = UserDefaults.standard

    var totalComentsCount = 0
    
    func returnEmoticonCell(_ cell : EmoticonCell) -> EmoticonCell{
        
        var cell = cell
        cell.thanksText.isHidden = true
        if Global.showEmoticonCell == false {
            cell = CellConstraintsConstructor.sharedInstance.setEmoticonCellConstraint(cell)
        }
        if let selected = self.defaults.object(forKey: "\(Global.article_id)") as? String {
            cell.thanksText.isHidden = false
            switch "\(selected)" {
            case "firstEmoticonSelected":
                cell.firstEmoticonLabel.textColor = UIColor.red
                cell.countFirstEmoticonLabel.textColor = UIColor.red
            case "secondEmoticonSelected":
                cell.secondEmoticonLabel.textColor = UIColor.red
                cell.countSecondEmoticonLabel.textColor = UIColor.red
            case "thirdEmoticonSelected":
                cell.thirdEmoticonLabel.textColor = UIColor.red
                cell.countThirdEmoticonLabel.textColor = UIColor.red
            case "fourthEmoticonSelected":
                cell.fourthEmoticonLabel.textColor = UIColor.red
                cell.countFourthEmoticonLabel.textColor = UIColor.red
            case "fifthEmoticonSelected":
                cell.fifthEmoticonLabel.textColor = UIColor.red
                cell.countFifthEmoticonLabel.textColor = UIColor.red
            case "sixtEmoticonSelected":
                cell.sixthEmoticonLabel.textColor = UIColor.red
                cell.countSixthEmoticonLabel.textColor = UIColor.red
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
            
            cell.firstEmoticonLabel.text = "\(ParametersConstructor.sharedInstance.setRatePercent(Global.votes.first, second: Global.votes.second, thirt: Global.votes.third, fourth: Global.votes.fourth, fifth: Global.votes.fifth, sixt: Global.votes.sixth, element: Global.votes.first))%" ?? "0%"
            cell.secondEmoticonLabel.text = "\(ParametersConstructor.sharedInstance.setRatePercent(Global.votes.first, second: Global.votes.second, thirt: Global.votes.third, fourth: Global.votes.fourth, fifth: Global.votes.fifth, sixt: Global.votes.sixth, element: Global.votes.second))%" ?? "0%"
            cell.thirdEmoticonLabel.text = "\(ParametersConstructor.sharedInstance.setRatePercent(Global.votes.first, second: Global.votes.second, thirt: Global.votes.third, fourth: Global.votes.fourth, fifth: Global.votes.fifth, sixt: Global.votes.sixth, element: Global.votes.third))%" ?? "0%"
            cell.fourthEmoticonLabel.text = "\(ParametersConstructor.sharedInstance.setRatePercent(Global.votes.first, second: Global.votes.second, thirt: Global.votes.third, fourth: Global.votes.fourth, fifth: Global.votes.fifth, sixt: Global.votes.sixth, element: Global.votes.fourth))%" ?? "0%"
            cell.fifthEmoticonLabel.text = "\(ParametersConstructor.sharedInstance.setRatePercent(Global.votes.first, second: Global.votes.second, thirt: Global.votes.third, fourth: Global.votes.fourth, fifth: Global.votes.fifth, sixt: Global.votes.sixth, element: Global.votes.fifth))%" ?? "0%"
            cell.sixthEmoticonLabel.text = "\(ParametersConstructor.sharedInstance.setRatePercent(Global.votes.first, second: Global.votes.second, thirt: Global.votes.third, fourth: Global.votes.fourth, fifth: Global.votes.fifth, sixt: Global.votes.sixth, element: Global.votes.sixth))%" ?? "0%"
            
        }
        
        if !Global.showEmoticonCell {
            cell.countFirstEmoticonLabel.isHidden = true
            cell.countSecondEmoticonLabel.isHidden = true
            cell.countThirdEmoticonLabel.isHidden = true
            cell.countFourthEmoticonLabel.isHidden = true
            cell.countFifthEmoticonLabel.isHidden = true
            cell.countSixthEmoticonLabel.isHidden = true
        }
        
        return cell
        
    }
    
    func returnCommentCell(_ cell : CommentCell ,comment : CommentsFeed , date : Date ,newComment : String ,newName : String ) -> CommentCell {

        
        var cell = CellConstraintsConstructor.sharedInstance.setCommentCellConstraints(cell)
        cell.hideProgress()
        cell.userNameLabel.textColor = UIColor.blue
        cell.commentLabel.text = newComment.replacingOccurrences(of: "<br/>", with: " ", options: NSString.CompareOptions.literal, range: nil)
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
            cell.initialsLabel.isHidden = true
            cell.userImage.isHidden = false
        } else if comment.avatar_url == ""{
            cell.userImage.isHidden = true
            cell.initialsLabel.isHidden = false
            cell.initialsLabel.text = ParametersConstructor.sharedInstance.searchUpperChracters(ParametersConstructor.sharedInstance.decodingString(comment.name!))
        }else {
            cell.userImage.isHidden = true
            cell.initialsLabel.isHidden = false
            cell.initialsLabel.text = ParametersConstructor.sharedInstance.searchUpperChracters(ParametersConstructor.sharedInstance.decodingString(comment.name!))
        }
        
        return cell
    }
    
    func returnMostPopularArticleCell (_ cell : MostPopularArticleCell , object : MostPopularArticle ) -> MostPopularArticleCell {
        if object.imgUrl != "" && object.imgUrl != nil {
            cell.imageForCell = object.imgUrl
        }
        cell.aboutArticleLabel.text = object.heading
        return cell
    }
    
    func returnReplyCell (_ cell : CommentCell ,comment : CommentsFeed , date : Date ,newComment : String ,newName : String ) -> CommentCell {
        
        cell.hideProgress()
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
            cell.initialsLabel.isHidden = true
            cell.userImage.isHidden = false
        } else if comment.avatar_url == ""{
            cell.userImage.isHidden = true
            cell.initialsLabel.isHidden = false
            cell.initialsLabel.text = ParametersConstructor.sharedInstance.searchUpperChracters(ParametersConstructor.sharedInstance.decodingString(comment.name!))
        } else {
            cell.userImage.isHidden = true
            cell.initialsLabel.isHidden = false
            cell.initialsLabel.text = ParametersConstructor.sharedInstance.searchUpperChracters(ParametersConstructor.sharedInstance.decodingString(comment.name!))
        }
        return cell
    }
    
    func returnAddCommentCellForComment(_ cell : AddCommentCell) -> AddCommentCell{
        
        cell.hideProgress()
        
        var cell = CellConstraintsConstructor.sharedInstance.setAddCommentCellConstraints(cell)
        if self.defaults.object(forKey: "name") as? String != nil {
            cell.nameTextField.text = self.defaults.object(forKey: "name") as? String
            cell.nameTextField.isEnabled = false
            cell.nameTextField.isSelected = false
            cell.logOut.isHidden = false
        } else {
            cell.logOut.isHidden = true
            cell.nameTextField.isEnabled = true
            cell.nameTextField.isSelected = true
        }
        
        if self.defaults.object(forKey: "email") as? String != nil {
            cell.emailTextField.text = self.defaults.object(forKey: "email") as? String
            cell.emailTextField.isEnabled = false
            cell.emailTextField.isSelected = false
            cell.logOut.isHidden = false
        } else{
            cell.logOut.isHidden = true
            cell.emailTextField.isEnabled = true
            cell.emailTextField.isSelected = true
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
    
    func returnAddCommentCellForReply(_ cell : AddCommentCell , object : ReplyForm) -> AddCommentCell{
        
        cell.hideProgress()
        var cell = CellConstraintsConstructor.sharedInstance.setAddCommentCellForReplyConstraints(cell)
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
            loadMoreCell.activityIndicator.isHidden = true
            loadMoreCell.heightActivitiIndicator.constant = 37
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
        } else if object is CommentForm {
            var cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell") as! AddCommentCell
            cell = returnAddCommentCellForComment(cell)
            return cell
        } else if object is Emoticon {
            var cell = tableView.dequeueReusableCell(withIdentifier: "EmoticonCell") as! EmoticonCell
            cell = returnEmoticonCell(cell)
            return cell
        } else if object is ReplyForm {
            let objectForcell : ReplyForm = object as! ReplyForm
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
        } else if object is CommentsFeed {
            let objectForcell : CommentsFeed = object as! CommentsFeed
            if objectForcell.isReplie == true{
                var cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
                cell = returnReplyCell(cell, comment: objectForcell, date: ParametersConstructor.sharedInstance.setDateInFofmat(objectForcell.ts!) as Date, newComment: ParametersConstructor.sharedInstance.decodingString(objectForcell.comment!), newName: ParametersConstructor.sharedInstance.decodingString(objectForcell.name!))
                return cell
            } else {
                var cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
                cell = returnCommentCell(cell, comment: objectForcell, date: ParametersConstructor.sharedInstance.setDateInFofmat(objectForcell.ts!) as Date, newComment: ParametersConstructor.sharedInstance.decodingString(objectForcell.comment!), newName: ParametersConstructor.sharedInstance.decodingString(objectForcell.name!))
                return cell
            }
        } else if object is MostPopularArticle {
            let objectForcell : MostPopularArticle = object as! MostPopularArticle
            var cell = tableView.dequeueReusableCell(withIdentifier: "MostPopularArticleCell") as! MostPopularArticleCell
            cell = returnMostPopularArticleCell(cell, object: object as! MostPopularArticle)
            return cell
        }
        return cell
    }
}
