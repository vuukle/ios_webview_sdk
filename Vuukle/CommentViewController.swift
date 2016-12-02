import UIKit
import Alamofire
import MessageUI


class CommentViewController: UIViewController , UITableViewDelegate , UITableViewDataSource ,  UITextFieldDelegate , AddCommentCellDelegate , CommentCellDelegate ,AddLoadMoreCellDelegate , EmoticonCellDelegate , UITextViewDelegate , MostPopularArticleCellDelegate, LoginCellDelegate, MFMailComposeViewControllerDelegate {
    
    static let sharedInstance = Global()
    static var shared : CommentViewController?
    var arrayObjectsForCell = [AnyObject]()
    var rating = EmoteRating()
    let defaults : UserDefaults = UserDefaults.standard
    var refreshControl:UIRefreshControl!
    var from_count = 0
    var removed = 0
    var to_count = Global.countLoadCommentsInPagination
    var canLoadmore = true
    var canGetCommentsFeed = true
    var totalComentsCount = 0
    //Needed to lock another action while server will not respond
    var morePost = true
    var loadReply = true
    var countOthetCell = 3
    var indexOfLastObject = -1
    //Needed to check if reply form is opened
    var lastReplyID = 0
    var replyOpened = false
    //Needed to check if login form is opened
    var lastLoginID = 0
    var loginOpened = false
    //Needed to check action
    var lastAction: Action = .unknown
    var lastActionPosition = -1
    var reportId = ""
    //Needed to check how to scroll view, if keyboard is opening
    var scrollIs = false
    var keyboardOpened = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Global.sharedInstance.checkAllParameters() == true {
            let bundleCommentCell = Bundle(for: CommentCell.self)
            let bundleAddCommentCell = Bundle(for: CommentCell.self)
            let bundleEmoticonCell = Bundle(for: CommentCell.self)
            let bundleLoadMoreCell = Bundle(for: CommentCell.self)
            let bundleLoginCell = Bundle(for: CommentCell.self)
            
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
            
            let nibMostPopularArticleCell = UINib(nibName: "MostPopularArticleCell", bundle: bundleLoadMoreCell)
            self.tableView.register(nibMostPopularArticleCell, forCellReuseIdentifier: "MostPopularArticleCell")
            
            let nibLoginCell = UINib(nibName: "LoginCell", bundle: bundleLoginCell)
            self.tableView.register(nibLoginCell, forCellReuseIdentifier: "LoginCell")
            
            self.tableView.estimatedRowHeight = 180
            
            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CommentViewController.dismissKeyboard)))
            
            if Global.showRefreshControl == true {
                refreshControl = UIRefreshControl()
                refreshControl!.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
                tableView.addSubview(refreshControl)
                refresh(sender: refreshControl!)
            }
            
            getComments()
            
        }
        CommentViewController.shared = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setHeight(sender:)),
                                               name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation,
                                               object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let object = arrayObjectsForCell[indexPath.row]
        
        switch object {
        case is CommentsFeed:
            let objectForCell = object as! CommentsFeed
            var cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            if cell == nil {
                cell = CommentCell() as! CommentCell
            }
            if objectForCell.isReply! {
                cell = CellConstructor.sharedInstance.returnReplyCell(cell, comment: objectForCell, date: ParametersConstructor.sharedInstance.setDateInFofmat(objectForCell.ts!) as Date, newComment: ParametersConstructor.sharedInstance.decodingString(objectForCell.comment), newName: ParametersConstructor.sharedInstance.decodingString(objectForCell.name)) as! CommentCell
            } else {
                cell = CellConstructor.sharedInstance.returnCommentCell(cell as! CommentCell, comment: objectForCell, date: ParametersConstructor.sharedInstance.setDateInFofmat(objectForCell.ts!) as Date, newComment: ParametersConstructor.sharedInstance.decodingString(objectForCell.comment), newName: ParametersConstructor.sharedInstance.decodingString(objectForCell.name)) as! CommentCell
            }
            cell.userImage.layer.masksToBounds = true
            cell.userImage.layer.cornerRadius = 22
            cell.delegate = self
            cell.tag = indexPath.row
            return cell
        case is MostPopularArticle:
            let objectForCell = object as! MostPopularArticle
            var cell = tableView.dequeueReusableCell(withIdentifier: "MostPopularArticleCell") as! MostPopularArticleCell
            if cell == nil {
                cell = MostPopularArticleCell() as! MostPopularArticleCell
            }
            cell = CellConstructor.sharedInstance.returnMostPopularArticleCell(cell, object: objectForCell) as! MostPopularArticleCell
            cell.delegate = self
            cell.tag = indexPath.row
            return cell
        case is ReplyForm:
            let objectForCell = object as! ReplyForm
            var cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell") as! AddCommentCell
            if cell == nil {
                cell = AddCommentCell() as! AddCommentCell
            }
            cell = CellConstructor.sharedInstance.returnAddCommentCellForReply(cell, object: objectForCell) as! AddCommentCell
            cell.delegate = self
            if objectForCell.hidden {
                cell.isHidden = true
            }
            cell.tag = indexPath.row
            return cell
        case is CommentForm:
            let objectForCell = object as! CommentForm
            var cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell") as! AddCommentCell
            if cell == nil {
                cell = AddCommentCell() as! AddCommentCell
            }
            cell = CellConstructor.sharedInstance.returnAddCommentCellForComment(cell) as! AddCommentCell
            cell.delegate = self
            cell.tag = indexPath.row
            return cell
        case is LoginForm:
            let objectForCell = object as! LoginForm
            var cell = tableView.dequeueReusableCell(withIdentifier: "LoginCell") as! LoginCell
            if cell == nil {
                cell = LoginCell() as! LoginCell
            }
            cell = CellConstructor.sharedInstance.returnLoginCell(cell, object: objectForCell) as! LoginCell
            cell.delegate = self
            cell.tag = indexPath.row
            return cell
        case is Emoticon:
            let objectForCell = object as! Emoticon
            var cell = tableView.dequeueReusableCell(withIdentifier: "EmoticonCell") as! EmoticonCell
            if cell == nil {
                cell = EmoticonCell() as! EmoticonCell
            }
            cell = CellConstructor.sharedInstance.returnEmoticonCell(cell) as! EmoticonCell
            cell.delegate = self
            cell.tag = indexPath.row
            return cell
        case is LoadMore:
            let objectForCell = object as! LoadMore
            var cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell") as! LoadMoreCell
            if cell == nil {
                cell = LoadMoreCell() as! LoadMoreCell
            }
            cell = CellConstructor.sharedInstance.returnLoadMoreCell(cell, object: objectForCell) as! LoadMoreCell
            cell.delegate = self
            cell.tag = indexPath.row
            return cell
        case is WebView:
            let objectForcell : WebView = object as! WebView
            if objectForcell.advertisingBanner == true {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "WebViewCell") as! WebViewCell
                cell.tag = indexPath.row
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContentWebViewCell") as! ContentWebViewCell
                cell.tag = indexPath.row
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK: CommentCellDelegate
    
    func shareButtonPressed(_ tableCell: CommentCell, shareButtonPressed shareButton: AnyObject) {
        let text = tableCell.commentLabel.text!
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = []
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func showReplyButtonPressed(_ tableCell: CommentCell, showReplyButtonPressed showReplyButton: AnyObject) {
        var firstLevel = 0
        var secondLevel = 0
        tableCell.showProgress()
        var position = tableCell.tag
        
        closeForms()
        
        if arrayObjectsForCell[position] is CommentsFeed {
            let firstObject = arrayObjectsForCell[position] as! CommentsFeed
            firstLevel = firstObject.level!
        }
        if arrayObjectsForCell[position + 1] is CommentsFeed {
            let secondObject = arrayObjectsForCell[position + 1] as! CommentsFeed
            secondLevel = secondObject.level!
        } else {
            secondLevel = 0
        }
        
        if firstLevel == secondLevel && loadReply == true || firstLevel > secondLevel{
            loadReply = false
            getReplies(index: position , comment: self.arrayObjectsForCell[position] as! CommentsFeed)
            
        } else if firstLevel < secondLevel {
            removeObjectFromSortedArray(indexObject: tableCell.tag)
        }
        tableCell.showReply.setTitle("hide", for: UIControlState.normal)
        setHeight(sender: self)
    }
    
    func upvoteButtonPressed(_ tableCell: CommentCell, upvoteButtonPressed upvoteButton: AnyObject) {
        tableCell.showProgress()
        closeForms()
        let commen = arrayObjectsForCell[tableCell.tag] as! CommentsFeed
        
        if self.defaults.object(forKey: "email") as? String != nil && self.defaults.object(forKey: "email") as? String != "" {
            var mail = ""
            if self.defaults.object(forKey: "\(commen.comment_id)") as? String == nil {
                mail = ParametersConstructor.sharedInstance.encodingString(self.defaults.object(forKey: "email") as! String)
                let name = ParametersConstructor.sharedInstance.encodingString(commen.name!)
                self.defaults.set("\(commen.comment_id)", forKey: "\(commen.comment_id)")
                self.defaults.synchronize()
                
                NetworkManager.sharedInstance.setCommentVote(name, email: mail, comment_id: commen.comment_id!, up_down: "1", completion: { (string , error) in
                    if error == nil {
                        commen.up_votes! += 1
                        let sum = commen.up_votes! - commen.down_votes!
                        tableCell.upvoteCountLabel.text = String(sum)
                        if sum == 0 {
                            tableCell.upvoteCountLabel.textColor = UIColor.lightGray
                        } else if sum < 0{
                            tableCell.upvoteCountLabel.textColor = UIColor.red
                        } else {
                            tableCell.upvoteCountLabel.textColor = ParametersConstructor.sharedInstance.UIColorFromRGB(rgbValue: 0x3487FF)
                        }
                        
                        tableCell.hideProgress()
                    } else {
                        self.defaults.set(nil, forKey: "\(commen.comment_id)")
                        
                        tableCell.hideProgress()
                        
                        // FIXME: New alert with "Send Report" button
                        var urlCommentID = "no_id"
                        
                        if (commen.comment_id != nil) {
                            urlCommentID = commen.comment_id!
                        }
                        
                        let logUrl = "\(Global.baseURL as String)setCommentVote?host=\(Global.host as String)&article_id=\(Global.article_id as String)&api_key=\(Global.api_key as String)&secret_key=\(Global.secret_key as String)&comment_id=\(urlCommentID as! String)&up_down=\("1")&name=\(name as String)&email=\(mail as String)"
                        
                        var logErrDescription = "nil"
                        var logErrFailureReason = "nil"
                        
                        if ((error) != nil) {
                            logErrDescription = (error?.localizedDescription != nil) ? (error?.localizedDescription)! : "nil"
                            logErrFailureReason = (error?.localizedFailureReason != nil) ? (error?.localizedFailureReason)! : "nil"
                        }
                        
                        var logMessage = "URL - \(logUrl).  Type - VoteUP.  Error - localizedDescription: \(logErrDescription), localizedFailureRiason: \(logErrFailureReason)."
                        
                        self.showAlertToSendReport(title: "Error", message: "Please try again later", errorMessage:logMessage)
                    }
                })
            } else {
                ParametersConstructor.sharedInstance.showAlert("You have already voted!", message: "")
                tableCell.hideProgress()
            }
        }else {
            lastAction = .upvote
            lastActionPosition = tableCell.tag
            askToLogin(position: tableCell.tag)
            tableCell.hideProgress()
        }
    }
    
    func downvoteButtonPressed(_ tableCell: CommentCell, downvoteButtonPressed downvoteButton: AnyObject) {
        tableCell.showProgress()
        closeForms()
        
        let commen = arrayObjectsForCell[tableCell.tag] as! CommentsFeed
        
        if  self.defaults.object(forKey: "email") as? String != nil && self.defaults.object(forKey: "email") as? String != "" {
            var mail = ""
            if self.defaults.object(forKey: "\(commen.comment_id)") as? String == nil {
                mail = ParametersConstructor.sharedInstance.encodingString(self.defaults.object(forKey: "email") as! String)
                let name = ParametersConstructor.sharedInstance.encodingString(commen.name!)
                self.defaults.set("\(commen.comment_id)", forKey: "\(commen.comment_id)")
                self.defaults.synchronize()
                NetworkManager.sharedInstance.setCommentVote(name, email: mail, comment_id: commen.comment_id!, up_down: "-1", completion: { (string , error) in
                    if error == nil {
                        commen.up_votes! += -1
                        let sum = commen.up_votes! - commen.down_votes!
                        tableCell.upvoteCountLabel.text = String(sum)
                        if sum == 0 {
                            tableCell.upvoteCountLabel.textColor = UIColor.lightGray
                        } else if sum < 0{
                            tableCell.upvoteCountLabel.textColor = UIColor.red
                        } else {
                            tableCell.upvoteCountLabel.textColor = ParametersConstructor.sharedInstance.UIColorFromRGB(rgbValue: 0x3487FF)
                        }
                        
                        tableCell.hideProgress()
                    } else {
                        self.defaults.set(nil, forKey: "\(commen.comment_id)")
                        
                        tableCell.hideProgress()
                        
                        // FIXME: New alert with "Send Report" button
                        var urlCommentID = "no_id"
                        
                        if (commen.comment_id != nil) {
                            urlCommentID = commen.comment_id!
                        }
                        
                        let logUrl = "\(Global.baseURL as String)setCommentVote?host=\(Global.host as String)&article_id=\(Global.article_id as String)&api_key=\(Global.api_key as String)&secret_key=\(Global.secret_key as String)&comment_id=\(urlCommentID as! String)&up_down=\("-1")&name=\(name as String)&email=\(mail as String)"
                        
                        var logErrDescription = "nil"
                        var logErrFailureReason = "nil"
                        
                        if ((error) != nil) {
                            logErrDescription = (error?.localizedDescription != nil) ? (error?.localizedDescription)! : "nil"
                            logErrFailureReason = (error?.localizedFailureReason != nil) ? (error?.localizedFailureReason)! : "nil"
                        }
                        
                        var logMessage = "URL - \(logUrl).  Type - VoteDOWN.  Error - localizedDescription: \(logErrDescription), localizedFailureRiason: \(logErrFailureReason)."
                        
                        self.showAlertToSendReport(title: "Error", message: "Please try again later", errorMessage:logMessage)
                    }
                })
            } else {
                ParametersConstructor.sharedInstance.showAlert("You have already voted!", message: "")
                tableCell.hideProgress()
            }
        } else {
            lastAction = .downvote
            lastActionPosition = tableCell.tag
            askToLogin(position: tableCell.tag)
            tableCell.hideProgress()
        }
    }
    
    func moreButtonPressed(_ tableCell: CommentCell, moreButtonPressed moreButton: AnyObject) {
        // moreView()
        let user = ParametersConstructor.sharedInstance.getUserInfo()
        let cell = self.arrayObjectsForCell[tableCell.tag] as! CommentsFeed
        if user["isLoggedIn"] == "true" {
            reportComment(user: user, cellId: cell.comment_id!)
        } else {
            lastAction = .report
            lastActionPosition = tableCell.tag
            reportId = cell.comment_id!
            askToLogin(position: tableCell.tag)
            tableCell.hideProgress()
        }
    }
    
    func replyButtonPressed(_ tableCell: CommentCell, replyButtonPressed replyButton: AnyObject) {
        tableCell.showProgress()
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            if self.morePost {
                
                if self.lastReplyID == tableCell.tag + 1 && self.replyOpened {
                    self.replyOpened = false
                    self.closeForms()
                } else {
                    self.closeForms()
                    self.replyOpened = true
                    self.lastReplyID = Int(tableCell.tag + 1)
                    self.arrayObjectsForCell.insert(ReplyForm(), at: tableCell.tag + 1)
                    if tableCell.tag == self.arrayObjectsForCell.count - 2 {
                        self.tableView.reloadData()
                    } else {
                        self.insertCell(position: tableCell.tag + 1)
                    }
                }
            }
            tableCell.hideProgress()
        })
    }
    
    //MARK: Load data
    func refresh(sender: AnyObject) {
        
        getComments()
    }
    
    //MARK: Get comments
    func getComments() {
        
        var indexPaths : [IndexPath] = []
        
        NetworkManager.sharedInstance.getTotalCommentsCount { (totalCount) in
            CellConstructor.sharedInstance.totalComentsCount = totalCount.comments!
        }
        if Global.showEmoticonCell {
            NetworkManager.sharedInstance.getEmoticonRating { (data) in
                ParametersConstructor.sharedInstance.setEmoticonCountVotes(data)
            }
        }
        
        if canGetCommentsFeed == true {
            canGetCommentsFeed = false
            if Global.setYourWebContent == true && Global.articleUrl != ""{
                let webView = WebView()
                webView.advertisingBanner = false
                self.arrayObjectsForCell.removeAll()
                self.arrayObjectsForCell.append(webView)
                indexPaths.append(IndexPath(row: 0, section: 0))
            } else {
                self.arrayObjectsForCell.removeAll()
                
            }
            
            NetworkManager.sharedInstance.getCommentsFeed { (array, error) in
                if error == nil {
                    self.refreshControl?.endRefreshing()
                    self.saveCommentData(array: array!)
                    self.getMostPopularArticles()
                    //self.tableView.reloadData()
                } else {
                    NetworkManager.sharedInstance.getCommentsFeed { (array, error) in
                        self.refreshControl?.endRefreshing()
                        if error == nil {
                            self.saveCommentData(array: array!)
                        } else {
                            print("VuukleComments: server is not responding")
                        }
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    func getReplies(index : Int ,comment : CommentsFeed ) {
        NetworkManager.sharedInstance.getRepliesForComment(comment.comment_id!, parent_id: comment.parent_id! , completion: { (arrayReplies , error) in
            if error == nil {
                let repliesArray = arrayReplies
                self.loadReply = true
                for r in repliesArray! {
                    r.level = comment.level! + 1
                    self.arrayObjectsForCell.insert(r, at: index + 1)
                    self.insertCell(position: index + 1)
                }
                if let cell = self.tableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as? CommentCell {
                    cell.hideProgress()
                }
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
            //arrayObjectsForCell.remove(at: indexObject + 1)
            //tableView.reloadData()
            self.deleteCell(position: indexObject + 1)
            removeObjectFromSortedArray(indexObject: indexObject)
        } else if firstLevel == secondLevel {
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                self.tableView.reloadRows(at: [IndexPath(row: indexObject, section: 0)], with: .none)
            })
            //tableView.reloadData()
        }
    }
    
    //MARK: - AddCommentCellDelegate
    
    func postButtonPressed(tableCell: AddCommentCell, pressed postButton: AnyObject) {
        
        updateIndexes(from: tableCell.tag - 1)
        tableCell.showProgress()
        self.view.endEditing(true)
        
        if arrayObjectsForCell[tableCell.tag] is CommentForm {
            
            let comment = arrayObjectsForCell[tableCell.tag] as! CommentForm
            if comment.addComment == true {
                
                let indexPath = NSIndexPath.init(row: tableCell.tag , section: 0)
                let cell = tableView.cellForRow(at: indexPath as IndexPath) as! AddCommentCell
                
                if ParametersConstructor.sharedInstance.checkFields(cell.nameTextField.text!, email: cell.emailTextField.text!, comment: cell.commentTextView.text) == true {
                    
                    morePost = false
                    
                    let name = ParametersConstructor.sharedInstance.encodingString(cell.nameTextField.text!)
                    let email = ParametersConstructor.sharedInstance.encodingString(cell.emailTextField.text!)
                    let comment = ParametersConstructor.sharedInstance.encodingString(cell.commentTextView.text!)
                    
                    ParametersConstructor.sharedInstance.setUserInfo(name: name, email: email)
                    
                    NetworkManager.sharedInstance.posComment(name, email: email, comment: comment) { (respon , error) in
                        
                        if (error == nil) {
                            
                            self.morePost = true
                            
                            var allow = respon?.isModeration
                            
                            if (allow == "true") {
                                
                                ParametersConstructor.sharedInstance.showAlert("Your comment has been submitted and is under moderation", message: "")
                                tableCell.hideProgress()
                                tableCell.commentTextView.text = ""
                                self.reloadAddCommentField()
                                cell.commentTextView.text = ""
                                
                            } else {
                                
                                if respon?.result == "repeat_comment" {
                                    
                                    self.showSimpleAlert(title: "Repeat comment!", message: nil)
                                    self.closeForms()
                                    tableCell.hideProgress()
                                    tableCell.commentTextView.text = ""
                                    self.reloadAddCommentField()
                                    cell.commentTextView.text = ""
                                    
                                } else {
                                    
                                    ParametersConstructor.sharedInstance.showAlert("Your comment was published", message: "")
                                    
                                    self.closeForms()
                                    self.addLocalCommentObjectToTableView(cell: cell, commentText: comment, nameText: name, emailText: email,commentID: (respon?.comment_id)! , index : tableCell.tag)
                                }
                            }
                            
                        } else {
                            
                            // FIXME: New alert with "Send Report" button
                            let logUrl = "\(Global.baseURL as String)postComment?host=\(Global.host as String)&article_id=\(Global.article_id as String)&api_key=\(Global.api_key as String)&secret_key=\(Global.secret_key as String)&name=\(name as String)&email=\(email as String)&comment=\(comment as String)&tags=\(Global.tag1 as String)&title=\(Global.title as String)&url=\(Global.articleUrl as String)"
                            
                            var logResult = "nil"
                            var logCommentID = "nil"
                            var logIsModeraion = "nil"
                            
                            if ((respon) != nil) {
                                
                                logResult = (respon?.result != nil) ? (respon?.result)! : "nil"
                                logCommentID = (respon?.comment_id != nil) ? (respon?.comment_id)! : "nil"
                                logIsModeraion = (respon?.isModeration != nil) ? (respon?.isModeration)! : "nil"
                            }
                            
                            var logErrDescription = "nil"
                            var logErrFailureReason = "nil"
                            
                            if ((error) != nil) {
                                logErrDescription = (error?.localizedDescription != nil) ? (error?.localizedDescription)! : "nil"
                                logErrFailureReason = (error?.localizedFailureReason != nil) ? (error?.localizedFailureReason)! : "nil"
                            }
                            
                            var logMessage = "URL - \(logUrl).    Response - result: \(logResult), commment_id: \(logCommentID),    isModeration: \(logIsModeraion).    Error - localizedDescription: \(logErrDescription), localizedFailureRiason: \(logErrFailureReason)."
                            
                            self.showAlertToSendReport(title: "Error", message: "Something went wrong", errorMessage:logMessage)
                            
                            self.morePost = true
                            tableCell.hideProgress()
                        }
                    }
                }
                else {
                    tableCell.hideProgress()
                }
            }
        } else if arrayObjectsForCell[tableCell.tag] is ReplyForm {
            
            let commentPosition = tableCell.tag
            let indexPath = NSIndexPath.init(row: tableCell.tag, section: 0)
            let cell = tableView.cellForRow(at: indexPath as IndexPath) as! AddCommentCell
            
            if ParametersConstructor.sharedInstance.checkFields(cell.nameTextField.text!, email: cell.emailTextField.text!, comment: cell.commentTextView.text) == true {
                let nameText = ParametersConstructor.sharedInstance.encodingString(cell.nameTextField.text!)
                let emailText = ParametersConstructor.sharedInstance.encodingString(cell.emailTextField.text!)
                let commentText = ParametersConstructor.sharedInstance.encodingString(cell.commentTextView.text!)
                
                ParametersConstructor.sharedInstance.setUserInfo(name: nameText, email: emailText)
                
                morePost = false
                if let commen = arrayObjectsForCell[tableCell.tag - 1] as? CommentsFeed {
                    var checker = true
                    
                    NetworkManager.sharedInstance.postReplyForComment(nameText, email: emailText, comment: commentText, comment_id: commen.comment_id!) { (responce ,error) in
                        
                        if error == nil  && responce?.result != "repeat_comment" {
                            
                            if checker {
                                checker = false
                                var moderation = responce?.isModeration! as String!
                                moderation = moderation?.lowercased()
                                tableCell.hideProgress()
                                if moderation == "true" {
                                    ParametersConstructor.sharedInstance.showAlert("Your comment has been submitted and is under moderation", message: "")
                                    self.reloadAddCommentField()
                                } else {
                                    ParametersConstructor.sharedInstance.showAlert("Your reply was published", message: "")
                                    self.addLocalPeplyObjectToTableView(cell: cell, commentText: commentText, nameText: nameText, emailText: emailText, index: commentPosition, forObject: commen, commentID: (responce?.result!)!)
                                }
                                self.closeForms()
                            }
                            
                        } else {
                            
                            if checker {
                                
                                if responce?.result == "repeat_comment" {
                                    tableCell.hideProgress()
                                    self.showSimpleAlert(title: "Repeat Comment!", message: nil)
                                    
                                } else {
                                    // FIXME: New alert with "Send Report" button
                                    var urlCommentID = "no_id"
                                    
                                    if (commen.comment_id != nil) {
                                        urlCommentID = commen.comment_id!
                                    }
                                    
                                    let logUrl = "https://vuukle.com/api.asmx/postReply?name=\(nameText)&email=\(emailText)&comment=\(commentText)&host=\(Global.host)&article_id=\(Global.article_id)&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&comment_id=\(urlCommentID as! String)&resource_id=\(Global.resource_id)&url=\(Global.articleUrl)"
                                    
                                    var logResult = "nil"
                                    var logCommentID = "nil"
                                    var logIsModeraion = "nil"
                                    
                                    if ((responce) != nil) {
                                        
                                        logResult = (responce?.result != nil) ? (responce?.result)! : "nil"
                                        logCommentID = (responce?.comment_id != nil) ? (responce?.comment_id)! : "nil"
                                        logIsModeraion = (responce?.isModeration != nil) ? (responce?.isModeration)! : "nil"
                                    }
                                    
                                    var logErrDescription = "nil"
                                    var logErrFailureReason = "nil"
                                    
                                    if ((error) != nil) {
                                        logErrDescription = (error?.localizedDescription != nil) ? (error?.localizedDescription)! : "nil"
                                        logErrFailureReason = (error?.localizedFailureReason != nil) ? (error?.localizedFailureReason)! : "nil"
                                    }
                                    
                                    var logMessage = "URL - \(logUrl).    Response - result: \(logResult), commment_id: \(logCommentID),    isModeration: \(logIsModeraion).    Error - localizedDescription: \(logErrDescription), localizedFailureRiason: \(logErrFailureReason)."
                                    
                                    print("\(logMessage)")
                                    
                                    self.showAlertToSendReport(title: "Error", message: "Something went wrong", errorMessage:logMessage)
                                    
                                    tableCell.hideProgress()
                                    self.morePost = true
                                }
                            }
                        }
                    }
                } else {
                    ParametersConstructor.sharedInstance.showAlert("Error", message: "Error in sending your message, try not to respond yourself :)")
                    self.morePost = true
                    tableView.reloadData()
                }
            } else {
                tableCell.hideProgress()
            }
        }
    }
    
    func logOutButtonPressed(tableCell: AddCommentCell,pressed logOutButton: AnyObject) {
        closeForms()
        tableCell.nameTextField.text = nil
        tableCell.emailTextField.text = nil
        self.defaults.set(nil, forKey: "name")
        self.defaults.set(nil, forKey: "email")
        self.defaults.synchronize()
        Saver.sharedInstance.removeWhenLogOutbuttonPressed()
        NetworkManager.sharedInstance.logOut()
        tableView.reloadRows(at: [IndexPath.init(row: tableCell.tag, section: 0)], with: .none)
    }
    
    
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case MFMailComposeResult.cancelled:
            print("-- Canceled.")
        case MFMailComposeResult.saved:
            print("-- Saved.")
        case MFMailComposeResult.sent:
            print("-- Sent!")
        default:
            break
        }
        self.dismiss(animated: true, completion:nil)
    }
    
    func configureMailComposerViewController (errorMessage: String) -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["fedir@vuukle.com"])
        mailComposerVC.setSubject("[VUUKLE - BUG REPORT]")
        mailComposerVC.setMessageBody(errorMessage, isHTML: false)
        
        return mailComposerVC
    }
    
    
    //MARK: - Alert with "Send Report" button
    func showSimpleAlert(title: String, message: String?) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func showAlertToSendReport(title: String, message: String, errorMessage: String) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let mailComposeVC = configureMailComposerViewController(errorMessage: errorMessage)
        mailComposeVC.modalPresentationStyle = .overCurrentContext
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let sendAction = UIAlertAction(title: "Send bug report", style: .default) { [unowned self] action -> Void in
            
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeVC, animated: true, completion:nil)
            } else {
                self.showSimpleAlert(title: "Can't send report...", message: "Please check device settings and 'Mail' app acount preferences")
            }
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(sendAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    //MARK: - LoadMoreCell delegate
    
    func loginButtonPressed(tableCell: LoginCell, pressed loginButton: AnyObject) {
        
        let name = tableCell.nameField.text!
        let email = tableCell.emailField.text!
        if ParametersConstructor.sharedInstance.checkFields(name, email: email, comment: "JustTesting") {
            ParametersConstructor.sharedInstance.setUserInfo(name: name, email: email)
            self.view.endEditing(true)
            closeForms()
            self.tableView.reloadData()
            continueAction()
        }
    }
    
    //Yeah, Alamofire requests shouldn't be here, but Swift code Optimizer makes crash at that request to NetworkManager, so I had to do this here
    
    func loadMoreButtonPressed(_ tableCell: LoadMoreCell, loadMoreButtonPressed loadMoreButton: AnyObject) {
        
        closeForms()
        
        if canGetCommentsFeed == true {
            
            canGetCommentsFeed = false
            
            from_count += Global.countLoadCommentsInPagination + 1
            to_count += Global.countLoadCommentsInPagination + 1
            
            print("\n From \(from_count)")
            print("\n From \(to_count)")
            
            let url = "\(Global.baseURL)getCommentFeed?host=\(Global.host)&article_id=\(Global.article_id)&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&time_zone=\(Global.secret_key)&from_count=\(from_count)&to_count=\(to_count)"
            
            Alamofire.request(url).responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    var jsonArray = JSON as? NSDictionary
                    
                    let commentFeedArray : NSArray = [jsonArray!["comment_feed"]!]
                    var responseArray = [CommentsFeed]()
                    
                    for feed in commentFeedArray.firstObject as! NSArray {
                        
                        responseArray.append(CommentsFeed.getCommentsFeedWhithArray(pDict: feed as! NSDictionary))
                    }
                    self.addMoreCommentsToArrayOfObjects(array: responseArray)
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                }
            }
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
    
    //MARK: MostPopularArticleCellDelegate
    
    func showArticleButtonPressed(_ tableCell: MostPopularArticleCell, _ showArticle: AnyObject) {
        closeForms()
        var popularArticle = arrayObjectsForCell[tableCell.tag] as! MostPopularArticle
        if let articleUrl = popularArticle.articleUrl {
            UIApplication.shared.openURL(URL(string: articleUrl)!)
        }
        //You can uncomment next fields to change comments
        
        //        Global.articleUrl = popularArticle.articleUrl!
        //        Global.article_id = popularArticle.articleId!
        //        Global.api_key = popularArticle.api_key!
        //        Global.host = popularArticle.host!
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectedPopularArticleNotification"), object: Global.articleUrl)
        //        arrayObjectsForCell.removeAll()
        //        getComments()
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
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
        CellConstructor.sharedInstance.totalComentsCount += 1
    }
    
    func addLocalCommentObjectToTableView(cell : AddCommentCell, commentText : String,nameText : String , emailText : String , commentID : String ,index : Int) {
        closeForms()
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
        CellConstructor.sharedInstance.totalComentsCount += 1
    }
    
    func addMoreCommentsToArrayOfObjects(array : [CommentsFeed]) {
        
        removeMostPopularArticle(array: arrayObjectsForCell as! [CommentsFeed])
        
        if arrayObjectsForCell[arrayObjectsForCell.count - 1] is LoadMore {
            arrayObjectsForCell.remove(at: arrayObjectsForCell.count - 1)
        }
        for object in array {
            self.arrayObjectsForCell.append(object)
        }
        if Global.setMostPopularArticleVisible {
            getMostPopularArticles()
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
            tableView.setContentOffset(CGPoint.zero, animated: false)
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
        tableView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        setHeight(sender: self)
    }
    
    func getMostPopularArticles() {
        
        NetworkManager.sharedInstance.getMostPopularArticle { (array, error) in
            
            if let responseArray = array {
                
                for article in array! {
                    self.arrayObjectsForCell.append(article)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func removeMostPopularArticle (array : [CommentsFeed]) {
        
        if Global.setMostPopularArticleVisible == true {
            
            for object in 1...Global.countLoadMostPopularArticle + 1 {
                
                if self.arrayObjectsForCell.count > 0 {
                    self.arrayObjectsForCell.removeLast()
                }
            }
            
        } else {
            self.arrayObjectsForCell.removeLast()
        }
    }
    
    func setHeight(sender: AnyObject) {
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            let myNumber = NSNumber(value: Float(self.tableView.contentSize.height))
            NSLog("\n \n Vuukle Library: Content Height was changed to \(myNumber) \n \n")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContentHeightDidChaingedNotification"), object: myNumber)
        })
    }
    
    func showAlert(title: String, message: String, redButton: String, blueButton: String, redHandler: @escaping() -> Void, blueHandler: @escaping() -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: redButton, style: UIAlertActionStyle.destructive, handler: { action in
            redHandler()
        }))
        alert.addAction(UIAlertAction(title: blueButton, style: UIAlertActionStyle.cancel, handler: { action in
            blueHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Function, which continues previous action after logination
    
    func continueAction() {
        if lastActionPosition != -1 {
            let cell = arrayObjectsForCell[lastActionPosition] as! CommentsFeed
            switch lastAction {
            case .upvote:
                if self.defaults.object(forKey: "\(cell.comment_id)") as? String == nil {
                    cell.up_votes = cell.up_votes! + 1
                    ParametersConstructor.sharedInstance.showAlert("Success", message: "Thanks for voting")
                } else {
                    ParametersConstructor.sharedInstance.showAlert("You have already voted", message: "")
                }
            case .downvote:
                if self.defaults.object(forKey: "\(cell.comment_id)") as? String == nil {
                    cell.down_votes = cell.down_votes! + 1
                    ParametersConstructor.sharedInstance.showAlert("Success", message: "Thanks for voting")
                } else {
                    ParametersConstructor.sharedInstance.showAlert("You have already voted", message: "")
                }
            case .report:
                reportComment(user: ParametersConstructor.sharedInstance.getUserInfo(), cellId: reportId)
            default:
                break
            }
        }
    }
    
    func askToLogin(position: Int) {
        var newCellPosition = position + 1
        closeForms()
        arrayObjectsForCell.insert(LoginForm(), at: newCellPosition)
        insertCell(position: newCellPosition)
        lastLoginID = newCellPosition
        loginOpened = true
    }
    
    func reportComment(user: [String:String], cellId: String) {
        self.showAlert(title: "Report comment?", message: "Do you really want to report this comment?", redButton: "Report", blueButton: "Cancel"
            , redHandler: {
                
                let name = ParametersConstructor.sharedInstance.encodingString(user["name"]!)
                let email = ParametersConstructor.sharedInstance.encodingString(user["email"]!)
                
                NetworkManager.sharedInstance.reportComment(commentID: cellId, name: name, email: email, completion: { result, error in
                    
                    if result! {
                        ParametersConstructor.sharedInstance.showAlert("Reported!", message: "Comment was successfully reported")
                    } else {
                        
                        // FIXME: New alert with "Send Report" button
                        let logUrl = "\(Global.baseURL)flagCommentOrReply?comment_id=\(cellId)&api_key=\(Global.api_key)&article_id=\(Global.article_id)&resource_id=\(Global.resource_id)&name=\(name)&email=\(email)"
                        
                        var logErrDescription = "nil"
                        var logErrFailureReason = "nil"
                        
                        if ((error) != nil) {
                            logErrDescription = (error?.localizedDescription != nil) ? (error?.localizedDescription)! : "nil"
                            logErrFailureReason = (error?.localizedFailureReason != nil) ? (error?.localizedFailureReason)! : "nil"
                        }
                        
                        var logMessage = "URL - \(logUrl). Error - localizedDescription: \(logErrDescription), localizedFailureRiason: \(logErrFailureReason)."
                        
                        self.showAlertToSendReport(title: "Error", message: "Something went wrong", errorMessage:logMessage)
                    }
                })
        }
            , blueHandler: {
                print("Canceled")
        })
    }
    
    func insertCell(position: Int) {
        tableView.beginUpdates()
        let indexPath = IndexPath.init(row: position, section: 0)
        tableView.insertRows(at: [indexPath], with: .right)
        tableView.endUpdates()
        updateIndexes(from: position)
        //changeHeight()
        //tableView.scrollToRow(at: IndexPath.init(row: position - 1, section: 0), at: .bottom, animated: true)
    }
    
    func deleteCell(position: Int) {
        arrayObjectsForCell.remove(at: position)
        tableView.beginUpdates()
        let indexPath = IndexPath.init(row: position, section: 0)
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.endUpdates()
        updateIndexes(from: position)
        setHeight(sender: self)
    }
    
    //Function, which hide all forms and returns new position to understand, if reply changed position of element
    
    func closeForms() {
        updateIndexes(from: 0)
        
        var excessiveElements : [Int] = []
        //Cell cannot be deleted at this cycle, cause this leads to Index out of range error
        for i in 0..<arrayObjectsForCell.count {
            if arrayObjectsForCell[i] is ReplyForm || arrayObjectsForCell[i] is LoginForm{
                excessiveElements.append(i)
            }
        }
        for value in excessiveElements {
            deleteCell(position: value)
        }
        replyOpened = false
        loginOpened = false
        morePost = true
        setHeight(sender: self)
    }
    
    //Needed to avoid index errors
    
    func updateIndexes(from index: Int) {
        for i in index..<arrayObjectsForCell.count {
            tableView.cellForRow(at: IndexPath.init(row: i, section: 0))?.tag = i
        }
    }
    
    //The add comment field(main form to send comment) will be reloaded
    
    func reloadAddCommentField() {
        if arrayObjectsForCell.count > 2 {
            tableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .none)
        } else {
            print("Vuukle is not found")
        }
    }
}
