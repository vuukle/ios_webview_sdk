

import UIKit
import Alamofire
import Social


class CommentViewController: UIViewController , UITableViewDelegate , UITableViewDataSource ,  UITextFieldDelegate , AddCommentCellDelegate , CommentCellDelegate ,AddLoadMoreCellDelegate , EmoticonCellDelegate , UITextViewDelegate{
    
    static let sharedInstance = Global()
    var arrayObjectsForCell = [AnyObject]()
    var rating = EmoteRating()
    var showRepleiCell = -1
    let defaults : UserDefaults = UserDefaults.standard
    var savedMail = ""
    var savedName = ""
    var inserReplieindex = -1
    var refreshControl:UIRefreshControl!
    var from_count = 0
    var to_count = Global.countLoadCommentsInPagination
    var canLoadmore = true
    var canGetCommentsFeed = true
    var totalComentsCount = 0
    var morePost = true
    var loadReply = true
    var countOthetCell = 3
    var indexOfLastObject = -1
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Global.sharedInstance.checkAllParameters() == true {
            let bundleCommentCell = Bundle(for: CommentCell.self)
            let bundleAddCommentCell = Bundle(for: CommentCell.self)
            let bundleEmoticonCell = Bundle(for: CommentCell.self)
            let bundleLoadMoreCell = Bundle(for: CommentCell.self)
            
            let nibComment = UINib(nibName: "CommentCell", bundle: bundleCommentCell)
            self.tableView.register(nibComment, forCellReuseIdentifier: "CommentCell")
            
            let nibAdd = UINib(nibName: "AddCommentCell", bundle: bundleAddCommentCell)
            self.tableView.register(nibAdd, forCellReuseIdentifier: "AddCommentCell")
            
            let nibEmoticon = UINib(nibName: "EmoticonCell", bundle: bundleEmoticonCell)
            self.tableView.register(nibEmoticon, forCellReuseIdentifier: "EmoticonCell")
            
            let nibLoadMoreCell = UINib(nibName: "LoadMoreCell", bundle: bundleLoadMoreCell)
            self.tableView.register(nibLoadMoreCell, forCellReuseIdentifier: "LoadMoreCell")
            
            let nibWebViewCell = UINib(nibName: "WebViewCell", bundle: bundleLoadMoreCell)
            self.tableView.register(nibWebViewCell, forCellReuseIdentifier: "WebViewCell")
            
            let nibContentWebViewCell = UINib(nibName: "ContentWebViewCell", bundle: bundleLoadMoreCell)
            self.tableView.register(nibContentWebViewCell, forCellReuseIdentifier: "ContentWebViewCell")
            
            self.tableView.estimatedRowHeight = 180
            
            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CommentViewController.dismissKeyboard)))
            
            if Global.showRefreshControl == true {
                refreshControl = UIRefreshControl()
                refreshControl!.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
                tableView.addSubview(refreshControl)
                refresh(sender: refreshControl!)
            }
            
            NotificationCenter.default.addObserver(self,
                                                             selector: #selector(CommentViewController.keyboardWillShow(sender:)),
                                                             name: NSNotification.Name.UIKeyboardWillShow,
                                                             object: nil)
            NotificationCenter.default.addObserver(self,
                                                             selector: #selector(CommentViewController.keyboardWillHide(sender:)),
                                                             name: NSNotification.Name.UIKeyboardWillHide,
                                                             object: nil)
            
            getComments()
            

            NetworkManager.sharedInstance.getTotalCommentsCount { (totalCount) in
                CellConstructor.sharedInstance.totalComentsCount = totalCount.comments!
                self.tableView.reloadData()
                NetworkManager.sharedInstance.getEmoticonRating { (data) in
                    ParametersConstructor.sharedInstance.setEmoticonCountVotes(data)
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Global.sharedInstance.checkAllParameters() == true {
            return arrayObjectsForCell.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = CellConstructor.sharedInstance.returnCellForRow(arrayObjectsForCell[indexPath.row], tableView: tableView)
        
        switch arrayObjectsForCell[indexPath.row] {
        case is CommentsFeed:
            let  cell : CommentCell = CellConstructor.sharedInstance.returnCellForRow(arrayObjectsForCell[indexPath.row], tableView: tableView) as! CommentCell
            cell.delegate = self
            cell.tag = indexPath.row
            return cell
        case is Emoticon:
            let  cell : EmoticonCell = CellConstructor.sharedInstance.returnCellForRow(arrayObjectsForCell[indexPath.row], tableView: tableView) as! EmoticonCell
            cell.delegate = self
            cell.tag = indexPath.row
            return cell
        case is CommentForm:
            let  cell : AddCommentCell = CellConstructor.sharedInstance.returnCellForRow(arrayObjectsForCell[indexPath.row], tableView: tableView) as! AddCommentCell
            cell.delegate = self
            cell.tag = indexPath.row
            return cell
        case is LoadMore:
            let  cell : LoadMoreCell = CellConstructor.sharedInstance.returnCellForRow(arrayObjectsForCell[indexPath.row], tableView: tableView) as! LoadMoreCell
            cell.delegate = self
            cell.tag = indexPath.row
            return cell
        case is ReplyForm:
            let  cell : AddCommentCell = CellConstructor.sharedInstance.returnCellForRow(arrayObjectsForCell[indexPath.row], tableView: tableView) as! AddCommentCell
            cell.delegate = self
            cell.tag = indexPath.row
            return cell
        default:
            break
        }
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK: CommentCellDelegate
    
    func secondShareButtonPressed(_ tableCell: CommentCell, shareButtonPressed shareButton: AnyObject) {
        shareComment(index: tableCell.tag, shareTo: "Facebook")
    }
    
    func firstShareButtonPressed(_ tableCell: CommentCell, shareButtonPressed shareButton: AnyObject) {
        shareComment(index: tableCell.tag, shareTo: "Twitter")
    }
    
    func showReplyButtonPressed(_ tableCell: CommentCell, showReplyButtonPressed showReplyButton: AnyObject) {
        var firstLevel = 0
        var secondLevel = 0
        
        if arrayObjectsForCell[tableCell.tag] is CommentsFeed {
            let firstObject = arrayObjectsForCell[tableCell.tag] as! CommentsFeed
            firstLevel = firstObject.level!
        }
        if arrayObjectsForCell[tableCell.tag + 1] is CommentsFeed {
            let secondObject = arrayObjectsForCell[tableCell.tag + 1] as! CommentsFeed
            secondLevel = secondObject.level!
        } else {
            secondLevel = 0
        }
        
        if firstLevel == secondLevel && loadReply == true || firstLevel > secondLevel{
            loadReply = false
            getReplies(index: tableCell.tag , comment: self.arrayObjectsForCell[tableCell.tag] as! CommentsFeed)
            
        } else if firstLevel < secondLevel {
            removeObjectFromSortedArray(indexObject: tableCell.tag)
        }
    }
    
    func upvoteButtonPressed(_ tableCell: CommentCell, upvoteButtonPressed upvoteButton: AnyObject) {
        let commen = arrayObjectsForCell[tableCell.tag] as! CommentsFeed
        
        if  self.defaults.object(forKey: "\(commen.comment_id)") as? String == nil{
            
            var mail = ""
            if self.defaults.object(forKey: "email") as? String != nil {
                mail = ParametersConstructor.sharedInstance.encodingString(self.defaults.object(forKey: "email") as! String)
            } else {
                mail = "no email"
            }
            let name = ParametersConstructor.sharedInstance.encodingString(commen.name!)
            self.defaults.set("\(commen.comment_id)", forKey: "\(commen.comment_id)")
            self.defaults.synchronize()
            NetworkManager.sharedInstance.setCommentVote(name, email: mail, comment_id: commen.comment_id!, up_down: "1", completion: { (string , error) in
                if error == nil {
                    print(string)
                    commen.up_votes! += 1
                    self.tableView.reloadData()
                } else {
                    NetworkManager.sharedInstance.setCommentVote(name, email: mail, comment_id: commen.comment_id!, up_down: "1", completion: { (string , error) in
                        if string == "error" {
                            commen.up_votes! += 1
                            self.tableView.reloadData()
                        }
                    })
                }
            })
            
        } else {
            ParametersConstructor.sharedInstance.showAlert("You have already voted!", message: "")
        }
    }
    
    func downvoteButtonPressed(_ tableCell: CommentCell, downvoteButtonPressed downvoteButton: AnyObject) {
        let commen = arrayObjectsForCell[tableCell.tag] as! CommentsFeed
        
        if  self.defaults.object(forKey: "\(commen.comment_id)") as? String == nil{
            var mail = ""
            if self.defaults.object(forKey: "email") as? String != nil {
                mail = ParametersConstructor.sharedInstance.encodingString(self.defaults.object(forKey: "email") as! String)
                
            } else {
                mail = "no email"
            }
            let name = ParametersConstructor.sharedInstance.encodingString(commen.name!)
            self.defaults.set("\(commen.comment_id)", forKey: "\(commen.comment_id)")
            self.defaults.synchronize()
            NetworkManager.sharedInstance.setCommentVote(name, email: mail, comment_id: commen.comment_id!, up_down: "-1", completion: { (string , error) in
                if error == nil {
                    commen.down_votes! += 1
                    self.tableView.reloadData()
                } else {
                    NetworkManager.sharedInstance.setCommentVote(name, email: mail, comment_id: commen.comment_id!, up_down: "-1", completion: { (string , error) in
                        if string == "error" {
                            commen.down_votes! += 1
                            self.tableView.reloadData()
                        }
                    })
                }
            })
        } else {
            ParametersConstructor.sharedInstance.showAlert("You have already voted!", message: "")
        }
    }
    
    func moreButtonPressed(_ tableCell: CommentCell, moreButtonPressed moreButton: AnyObject) {
        // moreView()
        print("\(tableCell.tag)")
        
    }
    
    func replyButtonPressed(_ tableCell: CommentCell, replyButtonPressed replyButton: AnyObject) {
        
        if arrayObjectsForCell[tableCell.tag] is CommentsFeed {
            
            if indexOfLastObject > 0 && indexOfLastObject == Int(tableCell.tag + 1) {
                arrayObjectsForCell.remove(at: indexOfLastObject)
                indexOfLastObject = -1
                tableView.reloadData()
            } else if indexOfLastObject > 0 && indexOfLastObject != Int(tableCell.tag + 1) {
                if indexOfLastObject > tableCell.tag + 1 {
                    arrayObjectsForCell.insert(ReplyForm(), at: tableCell.tag + 1)
                    indexOfLastObject = Int(tableCell.tag + 1)
                } else if indexOfLastObject < tableCell.tag + 1 {
                    arrayObjectsForCell.insert(ReplyForm(), at: tableCell.tag + 1 )
                    indexOfLastObject = Int(tableCell.tag + 1)
                }
                tableView.reloadData()
            } else {
                arrayObjectsForCell.insert(ReplyForm(), at: tableCell.tag + 1)
                indexOfLastObject = Int(tableCell.tag + 1)
                tableView.reloadData()
            }
        }
    }
    
    //MARK: Load data
    func refresh(sender: AnyObject) {
        
        getComments()
    }
    func getComments() {
        if canGetCommentsFeed == true {
            canGetCommentsFeed = false
            if Global.setYourWebContent == true && Global.articleUrl != ""{
                let webView = WebView()
                webView.advertisingBanner = false
                self.arrayObjectsForCell.removeAll()
                self.arrayObjectsForCell.append(webView)
                tableView.reloadData()
            } else {
                self.arrayObjectsForCell.removeAll()
                tableView.reloadData()
            }
            
            NetworkManager.sharedInstance.getCommentsFeed { (array, error) in
                if error == nil {
                    self.refreshControl?.endRefreshing()
                    self.saveCommentData(array: array!)
                } else {
                    NetworkManager.sharedInstance.getCommentsFeed { (array, error) in
                        self.refreshControl?.endRefreshing()
                        self.saveCommentData(array: array!)
                    }
                }
            }
        }
    }
    
    func getReplies(index : Int ,comment : CommentsFeed ) {
        NetworkManager.sharedInstance.getRepliesForComment(comment.comment_id!, parent_id: comment.parent_id! , completion: { (arrayReplies , error) in
            if error == nil {
                let repliesArray = arrayReplies
                self.loadReply = true
                for r in repliesArray! {
                    r.level = comment.level! + 1
                    self.arrayObjectsForCell.insert(r, at: index + 1)
                }
                self.tableView.reloadData()
            } else {
                self.getReplies(index: index, comment: comment)
            }
        })
    }
    
    func removeObjectFromSortedArray (indexObject : Int) {
        var firstLevel = 0
        var secondLevel = 0
        
        if arrayObjectsForCell[indexObject] is CommentsFeed {
            let firstObject = arrayObjectsForCell[indexObject] as! CommentsFeed
            firstLevel = firstObject.level!
        }
        if arrayObjectsForCell[indexObject + 1] is CommentsFeed {
            let secondObject = arrayObjectsForCell[indexObject + 1] as! CommentsFeed
            secondLevel = secondObject.level!
        } else {
            secondLevel = 0
        }
        
        if firstLevel < secondLevel {
            arrayObjectsForCell.remove(at: indexObject + 1)
            tableView.reloadData()
            removeObjectFromSortedArray(indexObject: indexObject)
        } else if firstLevel == secondLevel {
            tableView.reloadData()
        }
    }
    
    //MARK: AddCommentCellDelegate
    
    func postButtonPressed(tableCell: AddCommentCell, pressed postButton: AnyObject) {
        
        if arrayObjectsForCell[tableCell.tag] is CommentForm {
            let comment = arrayObjectsForCell[tableCell.tag] as! CommentForm
            if comment.addComment == true {
                
                if morePost == true {
                    
                    let indexPath = NSIndexPath.init(row: tableCell.tag , section: 0)
                    let cell = tableView.cellForRow(at: indexPath as IndexPath) as! AddCommentCell
                    
                    if ParametersConstructor.sharedInstance.checkFields(cell.nameTextField.text!, email: cell.emailTextField.text!, comment: cell.commentTextView.text) == true {
                        morePost = false
                        
                        let name = ParametersConstructor.sharedInstance.encodingString(cell.nameTextField.text!)
                        let email = ParametersConstructor.sharedInstance.encodingString(cell.emailTextField.text!)
                        let comment = ParametersConstructor.sharedInstance.encodingString(cell.commentTextView.text!)
                        NetworkManager.sharedInstance.posComment(name, email: email, comment: comment) { (respon , error) in
                            if (error == nil) {
                                self.morePost = true
                                self.addLocalCommentObjectToTableView(cell: cell, commentText: comment, nameText: name, emailText: email,commentID: (respon?.comment_id)! , index : tableCell.tag)
                            } else {
                                NetworkManager.sharedInstance.posComment(name, email: email, comment: comment) { (respon , error) in
                                    if (error == nil) {
                                        self.addLocalCommentObjectToTableView(cell: cell, commentText: comment, nameText: name, emailText: email,commentID: (respon?.comment_id)! , index : tableCell.tag)
                                    } else {
                                        self.morePost = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else if arrayObjectsForCell[tableCell.tag] is ReplyForm {
            if morePost == true {
                let indexPath = NSIndexPath.init(row: tableCell.tag, section: 0)
                let cell = tableView.cellForRow(at: indexPath as IndexPath) as! AddCommentCell
                
                if ParametersConstructor.sharedInstance.checkFields(cell.nameTextField.text!, email: cell.emailTextField.text!, comment: cell.commentTextView.text) == true {
                    let nameText = ParametersConstructor.sharedInstance.encodingString(cell.nameTextField.text!)
                    let emailText = ParametersConstructor.sharedInstance.encodingString(cell.emailTextField.text!)
                    let commentText = ParametersConstructor.sharedInstance.encodingString(cell.commentTextView.text!)
                    morePost = false
                    self.arrayObjectsForCell.remove(at: tableCell.tag)
                    let commen = arrayObjectsForCell[tableCell.tag - 1] as! CommentsFeed
                    NetworkManager.sharedInstance.postReplyForComment(nameText, email: emailText, comment: commentText, comment_id: commen.comment_id!) { (responce ,error) in
                        if error == nil  && responce?.result != "repeat_comment" {
                            self.addLocalPeplyObjectToTableView(cell: cell, commentText: commentText, nameText: nameText, emailText: emailText, index: tableCell.tag, forObject: commen, commentID: (responce?.result!)!)
                            
                        } else {
                            NetworkManager.sharedInstance.postReplyForComment(nameText, email: emailText, comment: commentText, comment_id: commen.comment_id!) { (responce ,error) in
                                self.addLocalPeplyObjectToTableView(cell: cell, commentText: commentText, nameText: nameText, emailText: emailText, index: tableCell.tag, forObject: commen, commentID: (responce?.result!)!)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func logOutButtonPressed(tableCell: AddCommentCell,pressed logOutButton: AnyObject) {
        tableCell.nameTextField.text = ""
        tableCell.emailTextField.text = ""
        Saver.sharedInstance.removeWhenLogOutbuttonPressed()
        NetworkManager.sharedInstance.logOut()
        
        tableView.reloadData()
    }
    
    //MARK : LoadMoreCell delegate
    
    func loadMoreButtonPressed(_ tableCell: LoadMoreCell, loadMoreButtonPressed loadMoreButton: AnyObject) {
        if canGetCommentsFeed == true {
            canGetCommentsFeed = false
            from_count += Global.countLoadCommentsInPagination + 1
            to_count += Global.countLoadCommentsInPagination + 1
            
            NetworkManager.sharedInstance.getMoreCommentsFeed(from_count, to_count: to_count, completion: { (array ,error) in
                
                if error == nil {
                    self.addMoreCommentsToArrayOfObjects(array: array!)
                } else {
                    NetworkManager.sharedInstance.getMoreCommentsFeed(self.from_count, to_count: self.to_count, completion: { (array ,error) in
                        self.addMoreCommentsToArrayOfObjects(array: array!)
                    })
                }
            })
        }
    }
    func openVuukleButtonButtonPressed(_ tableCell: LoadMoreCell, openVuukleButtonPressed openVuukleButton: AnyObject) {
        UIApplication.shared.openURL(NSURL(string: Global.websiteUrl)! as URL)
    }
    
    //Mark: EmoticonCellDelegate
    
    func firstEmoticonButtonPressed(_ tableCell: EmoticonCell, firstEmoticonButtonPressed firstEmoticonButton: AnyObject) {
        
        ParametersConstructor.sharedInstance.setRate(Global.article_id, emote: 1, tableView: tableView)
    }
    
    func secondEmoticonButtonPressed(_ tableCell: EmoticonCell, secondEmoticonButtonPressed secondEmoticonButton: AnyObject) {
        ParametersConstructor.sharedInstance.setRate(Global.article_id, emote: 2, tableView: tableView)
    }
    
    func thirdEmoticonButtonPressed(_ tableCell: EmoticonCell, thirdEmoticonButtonPressed thirdEmoticonButton: AnyObject) {
        ParametersConstructor.sharedInstance.setRate(Global.article_id, emote: 3, tableView: tableView)
    }
    
    func fourthEmoticonButtonPressed(_ tableCell: EmoticonCell, fourthEmoticonButtonPressed fourthEmoticonButton: AnyObject) {
        ParametersConstructor.sharedInstance.setRate(Global.article_id, emote: 4, tableView: tableView)
    }
    
    func fifthEmoticonButtonPressed(_ tableCell: EmoticonCell, fifthEmoticonButtonPressed fifthEmoticonButton: AnyObject) {
        ParametersConstructor.sharedInstance.setRate(Global.article_id, emote: 5, tableView: tableView)
    }
    
    func sixthEmoticonButtonPressed(_ tableCell: EmoticonCell, sixthEmoticonButtonPressed sixthEmoticonButton: AnyObject) {
        ParametersConstructor.sharedInstance.setRate(Global.article_id, emote: 6, tableView: tableView)
    }
    
    //MARK: Keyboard (Show/Hide/Dismiss)
    
    func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = -keyboardSize.height
        }
    }
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK: Sharing to Facebook/Twitter
    func shareComment(index : Int , shareTo : String) {
        var socialservice = SLServiceTypeFacebook
        if shareTo == "Facebook" {
            socialservice = SLServiceTypeFacebook
        } else {
            socialservice = SLServiceTypeTwitter
        }
        let object = arrayObjectsForCell[index] as! CommentsFeed
        let textToshare = ParametersConstructor.sharedInstance.decodingString(object.comment!)
        if SLComposeViewController.isAvailable(forServiceType: socialservice){
            let vc = SLComposeViewController(forServiceType: socialservice)
            vc?.setInitialText("\(textToshare)")
            vc?.add(NSURL(string: "\(Global.articleUrl)") as URL!)
            present(vc!, animated: true, completion: nil)
        } else {
            ParametersConstructor.sharedInstance.showAlert("Accounts", message: "Please login to a \(shareTo) account to share.")
        }
    }
    
    //MARK: Addding local objects
    func addLocalPeplyObjectToTableView(cell : AddCommentCell, commentText : String,nameText : String , emailText : String , index : Int ,forObject : CommentsFeed , commentID : String) {
        let date = NSDate()
        let dateFormat = DateFormatter.init()
        dateFormat.dateStyle = .full
        dateFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let stringOfDateInNewFornat = dateFormat.string(from: date as Date)
        let addComment = LocalCommentsConstructor.sharedInstance.addReply(commentText, name: nameText, ts: stringOfDateInNewFornat, email: emailText, up_votes: 0, down_votes: 0, comment_id: commentID, replies: 0, user_id: "", avatar_url: "", parent_id: forObject.comment_id!, user_points: 0, myComment: true, level : forObject.level! + 1)
        forObject.replies! += 1
        self.arrayObjectsForCell.insert(addComment, at: index)
        self.tableView.reloadData()
        cell.commentTextView.text = "Please write a comment..."
        cell.commentTextView.textColor = UIColor.lightGray
        self.morePost = true
    }
    
    func addLocalCommentObjectToTableView(cell : AddCommentCell, commentText : String,nameText : String , emailText : String , commentID : String ,index : Int) {
        let date = NSDate()
        let dateFormat = DateFormatter.init()
        dateFormat.dateStyle = .full
        dateFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let stringOfDateInNewFornat = dateFormat.string(from: date as Date)
        Saver.sharedInstance.savingWhenPostButtonPressed(cell.nameTextField.text!, email: cell.emailTextField.text!)
        let addComment = LocalCommentsConstructor.sharedInstance.addComment(commentText, name: nameText, ts: stringOfDateInNewFornat, email: emailText, up_votes: 0, down_votes: 0, comment_id: commentID, replies: 0, user_id: "", avatar_url: "", parent_id: "-1", user_points: 0, myComment: true, level : 0 )
        self.arrayObjectsForCell.insert(addComment, at: index + 1)
        self.totalComentsCount += 1
        self.tableView.reloadData()
        cell.commentTextView.text = "Please write a comment..."
        cell.commentTextView.textColor = UIColor.lightGray
        self.morePost = true
    }
    
    func addMoreCommentsToArrayOfObjects(array : [CommentsFeed]) {
        self.arrayObjectsForCell.removeLast()
        for object in array {
            self.arrayObjectsForCell.append(object)
        }
        
        self.canLoadmore = true
        self.canGetCommentsFeed = true
        
        if array.count >= Global.countLoadCommentsInPagination{
            let load = LoadMore()
            load.showLoadMoreButton = true
            self.arrayObjectsForCell.append(load)
        } else {
            let load = LoadMore()
            load.showLoadMoreButton = false
            self.arrayObjectsForCell.append(load)
            
        }
        self.tableView.reloadData()
    }
    
    func saveCommentData(array : [CommentsFeed]) {
        
        self.from_count = 0
        self.to_count = Global.countLoadCommentsInPagination
        if array.count >= Global.countLoadCommentsInPagination {
            
            self.arrayObjectsForCell.append(WebView())
            self.arrayObjectsForCell.append(Emoticon())
            let addComment = CommentForm()
            addComment.addComment = true
            self.arrayObjectsForCell.append(addComment)
            for object in array {
                self.arrayObjectsForCell.append(object)
            }
            let load = LoadMore()
            load.showLoadMoreButton = true
            self.arrayObjectsForCell.append(load)
        } else {
            
            self.arrayObjectsForCell.append(WebView())
            self.arrayObjectsForCell.append(Emoticon())
            let addComment = CommentForm()
            addComment.addComment = true
            self.arrayObjectsForCell.append(addComment)
            for object in array {
                self.arrayObjectsForCell.append(object)
            }
            let load = LoadMore()
            load.showLoadMoreButton = false
            self.arrayObjectsForCell.append(load)
        }
        self.canGetCommentsFeed = true
        self.canLoadmore = true
        self.tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.indexPathsForVisibleRows?.last?.row {
            let myNumber = NSNumber(value: Float(tableView.contentSize.height))
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContentHeightDidChaingedNotification"), object: myNumber)
        }
    }
}
