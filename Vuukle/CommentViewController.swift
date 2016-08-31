

import UIKit
import Alamofire

class CommentViewController: UIViewController , UITableViewDelegate , UITableViewDataSource ,  UITextFieldDelegate , AddCommentCellDelegate , CommentCellDelegate ,AddLoadMoreCellDelegate , EmoticonCellDelegate , UITextViewDelegate{
    
    

    var sortedComment = [GetCommentsFeed]()
    var commentFeed = [GetCommentsFeed]()
    var rating = EmoteRating()
    var output = ""
    var output1 = ""
    var output2 = ""
    var countCell = 0
    var count = 1
    var fname = ""
    var sname = ""
    var naneTF = ""
    var emailTF = ""
    var showRepleiCell = -1
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var savedMail = ""
    var savedName = ""
    var inserReplieindex = -1
    var refreshControl:UIRefreshControl!
    var from_count = 0
    var to_count = Global.countLoadCommentsInPagination
    var canLoadmore = true
    var canGetCommentsFeed = true
    var first : Double = 0
    var second : Double = 0
    var third : Double = 0
    var fourth : Double = 0
    var fifth : Double = 0
    var sixth : Double = 0
    var firstCount = 0
    var secondCount = 0
    var thirdCount = 0
    var fourthCount = 0
    var fifthCount = 0
    var sixthCount = 0
    var totalComentsCount = 0
    var morePost = true
    var loadReply = true
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if Global.sharedInstance.checkAllParameters() == true {
            let bundleCommentCell = NSBundle(forClass: CommentCell.self)
            let bundleAddCommentCell = NSBundle(forClass: CommentCell.self)
            let bundleEmoticonCell = NSBundle(forClass: CommentCell.self)
            let bundleLoadMoreCell = NSBundle(forClass: CommentCell.self)
            
            let nibComment = UINib(nibName: "CommentCell", bundle: bundleCommentCell)
            self.tableView.registerNib(nibComment, forCellReuseIdentifier: "CommentCell")
            
            let nibAdd = UINib(nibName: "AddCommentCell", bundle: bundleAddCommentCell)
            self.tableView.registerNib(nibAdd, forCellReuseIdentifier: "AddCommentCell")
            
            let nibEmoticon = UINib(nibName: "EmoticonCell", bundle: bundleEmoticonCell)
            self.tableView.registerNib(nibEmoticon, forCellReuseIdentifier: "EmoticonCell")
            
            let nibLoadMoreCell = UINib(nibName: "LoadMoreCell", bundle: bundleLoadMoreCell)
            self.tableView.registerNib(nibLoadMoreCell, forCellReuseIdentifier: "LoadMoreCell")
            
            self.tableView.estimatedRowHeight = 180
            
            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CommentViewController.dismissKeyboard)))
            
            refreshControl = UIRefreshControl()
            refreshControl!.addTarget(self, action: #selector(refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
            tableView.addSubview(refreshControl)
            refresh(refreshControl!)
            getRatePercentage ()
            getComments()
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector: #selector(CommentViewController.keyboardWillShow(_:)),
                                                             name: UIKeyboardWillShowNotification,
                                                             object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector: #selector(CommentViewController.keyboardWillHide(_:)),
                                                             name: UIKeyboardWillHideNotification,
                                                             object: nil)
            NetworkManager.sharedInstance.getTotalCommentsCount { (totalCount) in
                self.totalComentsCount = totalCount.comments!
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Table view data source
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Global.sharedInstance.checkAllParameters() == true {
            return sortedComment.count + 2
        } else {
            return 0
        }
        
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCellWithIdentifier("EmoticonCell", forIndexPath: indexPath) as! EmoticonCell
            cell.delegate = self
            return CellForRowAtIndex.sharedInstance.returnEmoticonCell(cell, firstCount: firstCount, secondCount: secondCount, thirdCount: thirdCount, fourthCount: fourthCount, fifthCount: fifthCount, sixthCount: sixthCount, firstPercent: first, secondPercent: second, thirdPercent: third, fourthPercent: fourth, fifthPercent: fifth, sixthPercent: sixth)
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddCommentCell", forIndexPath: indexPath) as! AddCommentCell
            cell.delegate = self
            cell.tag = indexPath.row
            return CellForRowAtIndex.sharedInstance.returnAddCommentCellForComment(cell, totalComentsCount: totalComentsCount)
        }
        let index = indexPath.row - 2
        let comment = sortedComment[index]
        let decodingComment = comment.comment!.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let newComment = decodingComment.stringByReplacingOccurrencesOfString("<br/>", withString: "\n", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let newName = comment.name!.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        searchUpperChracters(comment.name!.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        comment.initials = output
        var date = NSDate()
        if comment.ts != "" {
        let dateString:String = comment.ts!
        let dateFormat = NSDateFormatter.init()
        dateFormat.dateStyle = .FullStyle
        dateFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
        date = dateFormat.dateFromString(dateString)!
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentCell
            cell.commentLabel.text = nil
            cell.upvoteCountLabel.text = nil
            cell.upvoteCountLabel.text = nil
            cell.dateLabel.text = nil
            cell.countLabel.text = nil
            cell.replyCount.text = nil
        if comment.replies > 0 {
            cell.showButtonWidth.constant = 32
            cell.countReplyWidth.constant = 15
        } else {
            cell.showButtonWidth.constant = 0
            cell.countReplyWidth.constant = 0
        }
        if comment.parent_id == "-1" && comment.parent_id != "loadMore" && comment.ts != "loadMore" && comment.name != "loadMore"{
            cell.delegate = self
            cell.tag = indexPath.row
            return CellForRowAtIndex.sharedInstance.returnCommentCell(cell, comment: comment, date: date, newComment: newComment, newName: newName)
        } else if comment.parent_id != "-1" && comment.isReplie == true && comment.parent_id != "loadMore" && comment.ts != "loadMore" && comment.name != "loadMore"{
            cell.delegate = self
            cell.tag = indexPath.row
            return CellForRowAtIndex.sharedInstance.returnReplyCell(cell, comment: comment, date: date, newComment: newComment, newName: newName)
        } else if comment.parent_id == "" && comment.isReplie == false && comment.parent_id != "loadMore" && comment.ts != "loadMore" && comment.name != "loadMore"{
            let lcell = tableView.dequeueReusableCellWithIdentifier("AddCommentCell", forIndexPath: indexPath) as? AddCommentCell
            lcell!.tag = indexPath.row
            comment.myCommentIndex = lcell!.tag
            lcell!.delegate = self
            return CellForRowAtIndex.sharedInstance.returnAddCommentCellForReply(lcell!)
        } else if comment.parent_id == "More" && comment.name == "More" && comment.myComment == true{
            let mcell = tableView.dequeueReusableCellWithIdentifier("LoadMoreCell", forIndexPath: indexPath) as? LoadMoreCell
            if comment.level == -1{
                mcell?.heightButton.constant = 0
                mcell?.heightActivitiIndicator.constant = 0
                mcell?.loadMore.hidden = true
                mcell?.activityIndicator.hidden = true
            } else if comment.level == 0 {
                mcell?.heightButton.constant = 30
                mcell?.heightActivitiIndicator.constant = 37
                mcell?.activityIndicator.hidden = true
                mcell?.loadMore.hidden = false
            }
            mcell!.delegate = self
            return mcell!
        }
        cell.delegate = self
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

  //MARK: CommentCellDelegate
    
    func showReplyButtonPressed(tableCell: CommentCell, showReplyButtonPressed showReplyButton: AnyObject) {

        if sortedComment[tableCell.tag - 2].level! >= sortedComment[tableCell.tag - 1].level! && loadReply == true{
            loadReply = false
            getReplies(tableCell.tag - 1, comment: sortedComment[tableCell.tag - 2])
        } else if sortedComment[tableCell.tag - 1].name != "More" {
            removeObjectFromSortedArray(tableCell.tag - 2)
        }
    }
    
    func upvoteButtonPressed(tableCell: CommentCell, upvoteButtonPressed upvoteButton: AnyObject) {
        
        if  self.defaults.objectForKey("\(sortedComment[tableCell.tag - 2].comment_id)") as? String == nil{
            let lcomment = sortedComment[tableCell.tag - 2]
            var mail = ""
            if self.defaults.objectForKey("email") as? String != nil {
                mail = (self.defaults.objectForKey("email") as! String).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                
            } else {
                mail = "no email"
            }
            
            lcomment.up_votes! += 1
            self.defaults.setObject("\(self.sortedComment[tableCell.tag - 2].comment_id)", forKey: "\(self.sortedComment[tableCell.tag - 2].comment_id)")
            self.defaults.synchronize()
            self.tableView.reloadData()
            
            NetworkManager.sharedInstance.setCommentVote(lcomment.name!, email: mail, comment_id: lcomment.comment_id!, up_down: "1", completion: { (string , error) in
                if error == nil {
                    if string == "error" {
                        lcomment.up_votes! -= 1
                        self.defaults.removeObjectForKey("\(self.sortedComment[tableCell.tag - 2].comment_id)")
                        self.defaults.synchronize()
                        self.tableView.reloadData()
                    }
                } else {
                    NetworkManager.sharedInstance.setCommentVote(lcomment.name!, email: mail, comment_id: lcomment.comment_id!, up_down: "1", completion: { (string , error) in
                        if string == "error" {
                            lcomment.up_votes! -= 1
                            self.defaults.removeObjectForKey("\(self.sortedComment[tableCell.tag - 2].comment_id)")
                            self.defaults.synchronize()
                            self.tableView.reloadData()
                        }
                    })
                }
            })
            
        } else {
            PrivetFunctions.sharedInstance.showAlert("You have already voted!", message: "")
        }
    }
    
    func downvoteButtonPressed(tableCell: CommentCell, downvoteButtonPressed downvoteButton: AnyObject) {
        
        if  self.defaults.objectForKey("\(sortedComment[tableCell.tag - 2].comment_id)") as? String == nil{
            let lcomment = sortedComment[tableCell.tag - 2]
            var mail = ""
            if self.defaults.objectForKey("email") as? String != nil {
                mail = (self.defaults.objectForKey("email") as! String).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            } else {
                mail = "no email"
            }
            
            lcomment.down_votes! += 1
            self.defaults.setObject("\(self.sortedComment[tableCell.tag - 2].comment_id)", forKey: "\(self.sortedComment[tableCell.tag - 2].comment_id)")
            self.defaults.synchronize()
            self.tableView.reloadData()
            
            NetworkManager.sharedInstance.setCommentVote(lcomment.name!, email: mail, comment_id: lcomment.comment_id!, up_down: "-1", completion: { (string , error) in
                if error == nil{
                    if string == "error" {
                        lcomment.down_votes! -= 1
                        self.defaults.removeObjectForKey("\(self.sortedComment[tableCell.tag - 2].comment_id)")
                        self.defaults.synchronize()
                        self.tableView.reloadData()
                    }
                } else {
                    NetworkManager.sharedInstance.setCommentVote(lcomment.name!, email: mail, comment_id: lcomment.comment_id!, up_down: "-1", completion: { (string , error) in
                        if string == "error" {
                            lcomment.down_votes! -= 1
                            self.defaults.removeObjectForKey("\(self.sortedComment[tableCell.tag - 2].comment_id)")
                            self.defaults.synchronize()
                            self.tableView.reloadData()
                        }
                    })
                }
            })
            
        } else {
            PrivetFunctions.sharedInstance.showAlert("You have already voted!", message: "")
        }
    }
    
    func moreButtonPressed(tableCell: CommentCell, moreButtonPressed moreButton: AnyObject) {
        // moreView()
        
    }
    
    func replyButtonPressed(tableCell: CommentCell, replyButtonPressed replyButton: AnyObject) {
        if showRepleiCell == -1 {
            let addComment = PrivetFunctions.sharedInstance.addComment("", name: "No name", ts: "", email: "", up_votes: 0, down_votes: 0, comment_id: "", replies: 0, user_id: "", avatar_url: "", parent_id: "", user_points: 0, myComment: true, isReplie: false ,level : 1000)
            showRepleiCell = tableCell.tag - 1
            sortedComment.insert(addComment, atIndex: showRepleiCell)
            self.tableView.reloadData()
        } else if tableCell.tag != showRepleiCell + 1 && showRepleiCell != tableCell.tag - 1 {
            let addComment = PrivetFunctions.sharedInstance.addComment("", name: "No name", ts: "", email: "", up_votes: 0, down_votes: 0, comment_id: "", replies: 0, user_id: "", avatar_url: "", parent_id: "", user_points: 0, myComment: true, isReplie: false , level : 1000)
            sortedComment.removeAtIndex(showRepleiCell)
            showRepleiCell = tableCell.tag - 2
            if tableCell.tag == 2 {
                showRepleiCell = 1
            }
            sortedComment.insert(addComment, atIndex: showRepleiCell)
            self.tableView.reloadData()
        } else if showRepleiCell == tableCell.tag - 1 {
            sortedComment.removeAtIndex(showRepleiCell)
            showRepleiCell = -1
            tableView.reloadData()
        }
    }
    
    //MARK: Load data
    func refresh(sender: AnyObject) {
        getComments()
    }
    func getComments() {
        if canGetCommentsFeed == true {
            canGetCommentsFeed = false
            NetworkManager.sharedInstance.getCommentsFeed { (array, error) in
                
                if error == nil {
                    self.sortedComment = array!
                    self.refreshControl?.endRefreshing()
                    self.from_count = 0
                    self.to_count = Global.countLoadCommentsInPagination
                    if array?.count >= Global.countLoadCommentsInPagination {
                        let addComment = PrivetFunctions.sharedInstance.addComment("", name: "More", ts: "2016/08/05 11:32:23", email: "", up_votes: 0, down_votes: 0, comment_id: "", replies: 0, user_id: "", avatar_url: "", parent_id: "More", user_points: 0, myComment: true, isReplie: false ,level : 0)
                        self.sortedComment.append(addComment)
                    } else {
                        let addComment = PrivetFunctions.sharedInstance.addComment("", name: "More", ts: "2016/08/05 11:32:23", email: "", up_votes: 0, down_votes: 0, comment_id: "", replies: 0, user_id: "", avatar_url: "", parent_id: "More", user_points: 0, myComment: true, isReplie: false ,level : -1)
                        self.sortedComment.append(addComment)
                    }
                    self.canLoadmore = false
                    self.canGetCommentsFeed = true
                    self.canLoadmore = true
                    self.count = self.commentFeed.count
                    self.tableView.reloadData()
                } else {
                    NetworkManager.sharedInstance.getCommentsFeed { (array, error) in
                        self.sortedComment = array!
                        self.refreshControl?.endRefreshing()
                        self.from_count = 0
                        self.to_count = Global.countLoadCommentsInPagination
                        if self.sortedComment.count > 0 {
                            let addComment = PrivetFunctions.sharedInstance.addComment("", name: "More", ts: "2016/08/05 11:32:23", email: "", up_votes: 0, down_votes: 0, comment_id: "", replies: 0, user_id: "", avatar_url: "", parent_id: "More", user_points: 0, myComment: true, isReplie: false ,level : 100)
                            self.sortedComment.append(addComment)
                        }
                        self.canGetCommentsFeed = true
                        self.canLoadmore = true
                        self.count = self.commentFeed.count
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func getReplies(index : Int ,comment : GetCommentsFeed ) {
        NetworkManager.sharedInstance.getRepliesForComment(comment.comment_id!, parent_id: comment.parent_id! , completion: { (arrayReplies , error) in
            if error == nil {
                let repliesArray = arrayReplies
                self.loadReply = true
                for r in repliesArray! {
                    r.level = comment.level! + 1
                    self.sortedComment.insert(r, atIndex: index)
                }
                self.tableView.reloadData()
            } else {
                self.getReplies(index, comment: comment)
            }
        })
    }
    
   //MARK: remove/create object in "sortedArray"
    
    func createSortedArray(indexInsert : Int , object : GetCommentsFeed) {
        if commentFeed.count != 0 {
            if self.commentFeed[0].replies > 0 {
                self.sortedComment.append(self.commentFeed[0])
                self.commentFeed.removeAtIndex(0)
            } else {
                self.sortedComment.append(self.commentFeed[0])
                self.commentFeed.removeAtIndex(0)
            }
        } else if commentFeed.count == 0 {
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                self.canLoadmore = true
            })
        }
    }
    
    func removeObjectFromSortedArray (indexObject : Int) {
        
        if sortedComment[indexObject + 1].level! > sortedComment[indexObject].level!{
            sortedComment.removeAtIndex(indexObject + 1)
            tableView.reloadData()
            removeObjectFromSortedArray(indexObject)
        } else if sortedComment[indexObject + 1].level! == sortedComment[indexObject].level! {
            tableView.reloadData()
        }
    }

    //MARK: AddCommentCellDelegate
    
    func postButtonPressed(tableCell: AddCommentCell, postButtonPressed postButton: AnyObject) {
        
        if tableCell.tag == 1 {
            if morePost == true {
                let date = NSDate()
                let dateFormat = NSDateFormatter.init()
                dateFormat.dateStyle = .FullStyle
                dateFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
                let stringOfDateInNewFornat = dateFormat.stringFromDate(date)
                
                let indexPath = NSIndexPath.init(forRow: tableCell.tag , inSection: 0)
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddCommentCell
                
                if PrivetFunctions.sharedInstance.checkFields(cell.nameTextField.text!, email: cell.emailTextField.text!, comment: cell.commentTextView.text) == true {
                    morePost = false
                    let name = cell.nameTextField.text!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                    let email = cell.emailTextField.text!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                    let comment = cell.commentTextView.text!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                    NetworkManager.sharedInstance.posComment(name!, email: email!, comment: comment!) { (respon , error) in
                        if (error == nil) {
                            Saver.sharedInstance.savingWhenPostButtonPressed(cell.nameTextField.text!, email: cell.emailTextField.text!)
                            let addComment = PrivetFunctions.sharedInstance.addComment(cell.commentTextView.text, name: cell.nameTextField.text!, ts: stringOfDateInNewFornat, email: cell.emailTextField.text!, up_votes: 0, down_votes: 0, comment_id: respon!.comment_id!, replies: 0, user_id: "", avatar_url: "", parent_id: "-1", user_points: 0, myComment: true, isReplie: true , level : 0)
                            self.sortedComment.insert(addComment, atIndex: 0 )
                            self.totalComentsCount += 1
                            self.tableView.reloadData()
                            cell.commentTextView.text = "Please write a comment..."
                            cell.commentTextView.textColor = UIColor.lightGrayColor()
                            self.morePost = true
                        } else {
                            self.morePost = true
                            NetworkManager.sharedInstance.posComment(name!, email: email!, comment: comment!) { (respon , error) in
                                if error == nil {
                                    Saver.sharedInstance.savingWhenPostButtonPressed(cell.nameTextField.text!, email: cell.emailTextField.text!)
                                    let addComment = PrivetFunctions.sharedInstance.addComment(cell.commentTextView.text, name: cell.nameTextField.text!, ts: stringOfDateInNewFornat, email: cell.emailTextField.text!, up_votes: 0, down_votes: 0, comment_id: respon!.comment_id!, replies: 0, user_id: "", avatar_url: "", parent_id: "-1", user_points: 0, myComment: true, isReplie: true , level : 0)
                                    self.sortedComment.insert(addComment, atIndex: 0 )
                                    self.totalComentsCount += 1
                                    self.tableView.reloadData()
                                    cell.commentTextView.text = "Please write a comment..."
                                    cell.commentTextView.textColor = UIColor.lightGrayColor()
                                    self.morePost = true
                                }
                            }
                        }
                    }
                }
            }

        } else {
            if morePost == true {
                let indexPath = NSIndexPath.init(forRow: tableCell.tag, inSection: 0)
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! AddCommentCell
                
                if PrivetFunctions.sharedInstance.checkFields(cell.nameTextField.text!, email: cell.emailTextField.text!, comment: cell.commentTextView.text) == true {
                    let name = cell.nameTextField.text!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                    let email = cell.emailTextField.text!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                    let comment = cell.commentTextView.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                    morePost = false
                    
                    NetworkManager.sharedInstance.postReplyForComment(name!, email: email!, comment: comment!, comment_id: sortedComment[tableCell.tag - 3].comment_id!) { (responce ,error) in
                        if error == nil {
                            //Saver.sharedInstance.savingWhenPostButtonPressed(cell.nameTextField.text!, email: cell.emailTextField.text!)
                            let date = NSDate()
                            let dateFormat = NSDateFormatter.init()
                            dateFormat.dateStyle = .FullStyle
                            dateFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
                            let stringOfDateInNewFornat = dateFormat.stringFromDate(date)
                            let addComment = PrivetFunctions.sharedInstance.addComment(cell.commentTextView.text, name: cell.nameTextField.text!, ts: stringOfDateInNewFornat, email: cell.emailTextField.text!, up_votes: 0, down_votes: 0, comment_id: responce!.result!, replies: 0, user_id: "", avatar_url: "", parent_id: "", user_points: 0, myComment: true, isReplie: true , level : self.sortedComment[tableCell.tag - 3].level! + 1)
                            self.sortedComment[tableCell.tag - 3].replies! += 1
                            self.sortedComment.removeAtIndex(tableCell.tag - 2)
                            self.sortedComment.insert(addComment, atIndex: tableCell.tag - 2)
                            self.showRepleiCell = -1
                            self.tableView.reloadData()
                            cell.commentTextView.text = "Please write a comment..."
                            cell.commentTextView.textColor = UIColor.lightGrayColor()
                            self.morePost = true
                        } else {
                            NetworkManager.sharedInstance.postReplyForComment(name!, email: email!, comment: comment!, comment_id: self.sortedComment[tableCell.tag - 3].comment_id!) { (responce ,error) in
                                Saver.sharedInstance.savingWhenPostButtonPressed(cell.nameTextField.text!, email: cell.emailTextField.text!)
                                let date = NSDate()
                                let dateFormat = NSDateFormatter.init()
                                dateFormat.dateStyle = .FullStyle
                                dateFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
                                let stringOfDateInNewFornat = dateFormat.stringFromDate(date)
                                let addComment = PrivetFunctions.sharedInstance.addComment(cell.commentTextView.text, name: cell.nameTextField.text!, ts: stringOfDateInNewFornat, email: cell.emailTextField.text!, up_votes: 0, down_votes: 0, comment_id: responce!.result!, replies: 0, user_id: "", avatar_url: "", parent_id: "", user_points: 0, myComment: true, isReplie: true , level : self.sortedComment[tableCell.tag - 3].level! + 1)
                                self.sortedComment[tableCell.tag - 3].replies! += 1
                                self.sortedComment.removeAtIndex(tableCell.tag - 2)
                                self.sortedComment.insert(addComment, atIndex: tableCell.tag - 2)
                                self.showRepleiCell = -1
                                self.tableView.reloadData()
                                cell.commentTextView.text = "Please write a comment..."
                                cell.commentTextView.textColor = UIColor.lightGrayColor()
                                self.morePost = true
                            }
                        }
                    }
                }
            }
            }
    }
    
    func logOutButtonPressed(tableCell: AddCommentCell, logOutButtonPressed logOutButton: AnyObject) {
        tableCell.nameTextField.text = ""
        tableCell.emailTextField.text = ""
            Saver.sharedInstance.removeWhenLogOutbuttonPressed()
            NetworkManager.sharedInstance.logOut()
        
        tableView.reloadData()
    }
    
    //MARK : LoadMoreCell delegate

    func loadMoreButtonPressed(tableCell: LoadMoreCell, loadMoreButtonPressed loadMoreButton: AnyObject) {
        if canGetCommentsFeed == true {
            canGetCommentsFeed = false
            from_count += Global.countLoadCommentsInPagination + 1
            to_count += Global.countLoadCommentsInPagination + 1
        NetworkManager.sharedInstance.getMoreCommentsFeed(from_count, to_count: to_count, completion: { (array ,error) in
            
            if error == nil {
                self.sortedComment.removeLast()
                for r in array! {
                    self.sortedComment.append(r)
                }
                self.canLoadmore = true
                self.canGetCommentsFeed = true
                
                if self.totalComentsCount > self.to_count{
                    let addComment = PrivetFunctions.sharedInstance.addComment("", name: "More", ts: "2016/08/05 11:32:23", email: "", up_votes: 0, down_votes: 0, comment_id: "", replies: 0, user_id: "", avatar_url: "", parent_id: "More", user_points: 0, myComment: true, isReplie: false ,level : 0)
                    self.sortedComment.append(addComment)
                } else {
                    let addComment = PrivetFunctions.sharedInstance.addComment("", name: "More", ts: "2016/08/05 11:32:23", email: "", up_votes: 0, down_votes: 0, comment_id: "", replies: 0, user_id: "", avatar_url: "", parent_id: "More", user_points: 0, myComment: true, isReplie: false ,level : -1)
                    self.sortedComment.append(addComment)
                }
                self.tableView.reloadData()
            } else {
                NetworkManager.sharedInstance.getMoreCommentsFeed(self.from_count, to_count: self.to_count, completion: { (array ,error) in
                        self.sortedComment.removeLast()
                        for r in array! {
                            self.sortedComment.append(r)
                        }
                        self.canLoadmore = true
                        self.canGetCommentsFeed = true
                    if self.totalComentsCount > self.to_count{
                        let addComment = PrivetFunctions.sharedInstance.addComment("", name: "More", ts: "2016/08/05 11:32:23", email: "", up_votes: 0, down_votes: 0, comment_id: "", replies: 0, user_id: "", avatar_url: "", parent_id: "More", user_points: 0, myComment: true, isReplie: false ,level : 0)
                        self.sortedComment.append(addComment)
                    } else {
                        let addComment = PrivetFunctions.sharedInstance.addComment("", name: "More", ts: "2016/08/05 11:32:23", email: "", up_votes: 0, down_votes: 0, comment_id: "", replies: 0, user_id: "", avatar_url: "", parent_id: "More", user_points: 0, myComment: true, isReplie: false ,level : -1)
                        self.sortedComment.append(addComment)
                    }
                        self.tableView.reloadData()
                })
            }
        })
    }
    }
    func openVuukleButtonButtonPressed(tableCell: LoadMoreCell, openVuukleButtonPressed openVuukleButton: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: Global.websiteUrl)!)
    }

    //Mark: EmoticonCellDelegate
    
    func firstEmoticonButtonPressed(tableCell: EmoticonCell, firstEmoticonButtonPressed firstEmoticonButton: AnyObject) {
        setRate(Global.article_id, emote: 1)
    }
    
    func secondEmoticonButtonPressed(tableCell: EmoticonCell, secondEmoticonButtonPressed secondEmoticonButton: AnyObject) {
        setRate(Global.article_id, emote: 2)
    }
    
    func thirdEmoticonButtonPressed(tableCell: EmoticonCell, thirdEmoticonButtonPressed thirdEmoticonButton: AnyObject) {
        setRate(Global.article_id, emote: 3)
    }
    
    func fourthEmoticonButtonPressed(tableCell: EmoticonCell, fourthEmoticonButtonPressed fourthEmoticonButton: AnyObject) {
        setRate(Global.article_id, emote: 4)
    }
    
    func fifthEmoticonButtonPressed(tableCell: EmoticonCell, fifthEmoticonButtonPressed fifthEmoticonButton: AnyObject) {
        setRate(Global.article_id, emote: 5)
    }
    
    func sixthEmoticonButtonPressed(tableCell: EmoticonCell, sixthEmoticonButtonPressed sixthEmoticonButton: AnyObject) {
        setRate(Global.article_id, emote: 6)
    }
    
    //MARK: Emotion Cell get/set data
    
    func getRatePercentage (){
        NetworkManager.sharedInstance.getEmoticonRating { (data) in
            self.rating  = data
            self.firstCount = self.rating.first
            self.secondCount = self.rating.second
            self.thirdCount = self.rating.third
            self.fourthCount = self.rating.fourth
            self.fifthCount = self.rating.fifth
            self.sixthCount = self.rating.sixth
            
            self.setRatePercentage ()
        }
    }
    
    func setRatePercentage () {
        let sume : Double = Double(self.rating.first) + Double(self.rating.second) + Double(self.rating.third) + Double(self.rating.fourth) + Double(self.rating.fifth) + Double(self.rating.sixth)
        self.first  = round(Double(self.rating.first * 100)/sume)
        self.second = round(Double(self.rating.second * 100)/sume)
        self.third = round(Double(self.rating.third * 100)/sume)
        self.fourth = round(Double(self.rating.fourth * 100)/sume)
        self.fifth = round(Double(self.rating.fifth * 100)/sume)
        self.sixth = round(Double(self.rating.sixth * 100)/sume)
        
        self.tableView.reloadData()
    }
    
    func setRate(article_id : String ,emote : Int) {
    
        if  self.defaults.objectForKey("\(article_id)") as? String == nil{
            
            switch emote {
            case 1:
                first += 1
                firstCount += 1
            case 2:
                second += 1
                secondCount += 1
            case 3:
                third += 1
                thirdCount += 1
            case 4:
                fourth += 1
                fourthCount += 1
            case 5:
                fifth += 1
                fifthCount += 1
            case 6:
                sixth += 1
                sixthCount += 1
            default:
                break
            }
            self.defaults.setObject("\(emote)", forKey: "\(article_id)")
            self.defaults.synchronize()
            PrivetFunctions.sharedInstance.showAlert( "Voted!",message: "You just voted!")
            NetworkManager.sharedInstance.setRaring(article_id, emote: emote) { (response) in
            }
            setRatePercentage ()
        } else {
            PrivetFunctions.sharedInstance.showAlert( "You have already voted!",message: "")
        }
    }
    
    //MARK: Keyboard (Show/Hide/Dismiss)
    
    func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y = -keyboardSize.height
        }
    }
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK: Private method
    func searchUpperChracters(fullName: String) {
        
        if fullName != "" {
            var fullNameComponents = fullName.componentsSeparatedByString(" ")
            output1 = ""
            output2 = ""
            output = ""
            sname = ""
            fname = ""
            self.fname = fullNameComponents.count > 0 ? fullNameComponents[0]: ""
            self.sname = fullNameComponents.count > 1 ? fullNameComponents[1]: ""
            self.fname = self.fname.capitalizedString
            self.sname = self.sname.capitalizedString
            for chr in fname.characters {
                if output1.characters.count != 1 {
                    self.output1 = String(chr)
                }
            }
            for chr in sname.characters {
                if output2.characters.count != 1 {
                    self.output2 = String(chr)
                }
            }
            output = "\(output1)\(output2)"
        }
    }
    
    func moreView() {
        let moreView = MoreView.loadViewFromNib()
        moreView.frame = CGRectMake(0, 0, self.view.frame.width , self.view.frame.height )
        self.view.addSubview(moreView)
        moreView.alpha = 0
        UIView.animateWithDuration(0.25) { () -> Void in
            moreView.alpha = 1
        }
    }
}
