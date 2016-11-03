import UIKit
import Alamofire
import Social


class CommentViewController: UIViewController , UITableViewDelegate , UITableViewDataSource ,  UITextFieldDelegate , AddCommentCellDelegate , CommentCellDelegate ,AddLoadMoreCellDelegate , EmoticonCellDelegate , UITextViewDelegate , MostPopularArticleCellDelegate, LoginCellDelegate {
    
    static let sharedInstance = Global()
    static var shared : CommentViewController?
    var arrayObjectsForCell = [AnyObject]()
    var rating = EmoteRating()
    var showRepleiCell = -1
    let defaults : UserDefaults = UserDefaults.standard
    var savedMail = ""
    var savedName = ""
    var inserReplieindex = -1
    var refreshControl:UIRefreshControl!
    var from_count = 0
    var removed = 0
    var to_count = Global.countLoadCommentsInPagination
    var canLoadmore = true
    var canGetCommentsFeed = true
    var totalComentsCount = 0
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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let vuuklebundle = Bundle(identifier: "org.cocoapods.Vuukle")!
//        let version = vuuklebundle.infoDictionary![kCFBundleVersionKey] as! String
//        print("222333 \(version)")
        
        if Global.sharedInstance.checkAllParameters() == true {
            let bundleCommentCell = Bundle(for: CommentCell.self)
            let bundleAddCommentCell = Bundle(for: CommentCell.self)
            let bundleEmoticonCell = Bundle(for: CommentCell.self)
            let bundleLoadMoreCell = Bundle(for: CommentCell.self)
            let bundleLoginCell = Bundle(for: CommentCell.self)
            //let bundleLoginView = Bundle(for: AddLoadMore)
            
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
            
            NotificationCenter.default.addObserver(self,
                                                             selector: #selector(CommentViewController.keyboardWillShow(sender:)),
                                                             name: NSNotification.Name.UIKeyboardWillShow,
                                                             object: nil)
            NotificationCenter.default.addObserver(self,
                                                             selector: #selector(CommentViewController.keyboardWillHide(sender:)),
                                                             name: NSNotification.Name.UIKeyboardWillHide,
                                                             object: nil)

            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(showTopOfTableView(sender:)),
                                                   name: NSNotification.Name(rawValue: "webViewLoaded"),
                                                   object: nil)
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
        case is MostPopularArticle:
            let  cell : MostPopularArticleCell = CellConstructor.sharedInstance.returnCellForRow(arrayObjectsForCell[indexPath.row], tableView: tableView) as! MostPopularArticleCell
            cell.delegate = self
            cell.tag = indexPath.row
            return cell
        case is LoginForm:
            let cell : LoginCell = CellConstructor.sharedInstance.returnCellForRow(arrayObjectsForCell[indexPath.row], tableView: tableView) as! LoginCell
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
    
    public func getHeight() -> Float {
        let myNumber = Float(self.tableView.contentSize.height)
        return myNumber
    }
    
    //MARK: CommentCellDelegate
    
    func firstShareButtonPressed(_ tableCell: CommentCell, shareButtonPressed shareButton: AnyObject) {
        //shareComment(index: tableCell.tag, shareTo: "Twitter")
        let text = tableCell.commentLabel.text!
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook, UIActivityType.postToTwitter, UIActivityType.postToFlickr, UIActivityType.mail, UIActivityType.message ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func showReplyButtonPressed(_ tableCell: CommentCell, showReplyButtonPressed showReplyButton: AnyObject) {
        var firstLevel = 0
        var secondLevel = 0
        tableCell.showProgress()
        var position = tableCell.tag
        
        position = hideForms(position: position)
        
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
                        ParametersConstructor.sharedInstance.showAlert("Error", message: "Try again later")
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
                        ParametersConstructor.sharedInstance.showAlert("Error", message: "Try again later")
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
        
//        if arrayObjectsForCell[tableCell.tag] is CommentsFeed {
//            var position = tableCell.tag
            
            if lastReplyID == tableCell.tag + 1 && replyOpened {
                replyOpened = false
                closeForms()
            } else {
                closeForms()
                replyOpened = true
                lastReplyID = Int(tableCell.tag + 1)
                arrayObjectsForCell.insert(ReplyForm(), at: tableCell.tag + 1)
                insertCell(position: tableCell.tag + 1)
            }
            
        
    }
    
    //MARK: Load data
    func refresh(sender: AnyObject) {
        
        getComments()
    }
    
    //CHECK AT INDIAEXPRESS
    
    func showTopOfTableView(sender: AnyObject){
        tableView.setContentOffset(CGPoint.zero, animated: true)
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
                    self.tableView.reloadData()
                } else {
                    NetworkManager.sharedInstance.getCommentsFeed { (array, error) in
                        self.refreshControl?.endRefreshing()
                        self.saveCommentData(array: array!)
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
                    //if index
                    self.arrayObjectsForCell.insert(r, at: index + 1)
                    self.insertCell(position: index + 1)
                }
                if let cell = self.tableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as? CommentCell {
                    cell.hideProgress()
                }
                //self.insertCellArray(from: <#T##Int#>, to: <#T##Int#>)
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
        
        tableCell.showProgress()
        self.view.endEditing(true)
        
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
                        
                        ParametersConstructor.sharedInstance.setUserInfo(name: name, email: email)
                        
                        NetworkManager.sharedInstance.posComment(name, email: email, comment: comment) { (respon , error) in
                            if (error == nil) {
                                self.morePost = true
                                let allow = respon!.isModeration! as String
                                if allow == "true" {
                                    ParametersConstructor.sharedInstance.showAlert("Your comment has been submitted and is under moderation", message: "")
                                    tableCell.hideProgress()
                                    cell.commentTextView.text = ""
                                } else {
                                    ParametersConstructor.sharedInstance.showAlert("Your comment was published", message: "")
                                    self.addLocalCommentObjectToTableView(cell: cell, commentText: comment, nameText: name, emailText: email,commentID: (respon?.comment_id)! , index : tableCell.tag)
                                }
                            } else {
                                NetworkManager.sharedInstance.posComment(name, email: email, comment: comment) { (respon , error) in
                                    if (error == nil) {
                                        let allow = respon!.isModeration! as String
                                        if allow == "true" {
                                            ParametersConstructor.sharedInstance.showAlert("Your comment has been submitted and is under moderation", message: "")
                                        } else {
                                            ParametersConstructor.sharedInstance.showAlert("Your comment was published", message: "")
                                        self.addLocalCommentObjectToTableView(cell: cell, commentText: comment, nameText: name, emailText: email,commentID: (respon?.comment_id)! , index : tableCell.tag)
                                        }
                                    } else {
                                        self.morePost = true
                                    }
                                }
                            }
                        }
                        self.hideForms()
                        tableView.reloadData()
                    }
                    else {
                        tableCell.hideProgress()
                    }
                }
            }
        } else if arrayObjectsForCell[tableCell.tag] is ReplyForm {
            let commentPosition = tableCell.tag
            if morePost == true {
                let indexPath = NSIndexPath.init(row: tableCell.tag, section: 0)
                let cell = tableView.cellForRow(at: indexPath as IndexPath) as! AddCommentCell
                
                if ParametersConstructor.sharedInstance.checkFields(cell.nameTextField.text!, email: cell.emailTextField.text!, comment: cell.commentTextView.text) == true {
                    let nameText = ParametersConstructor.sharedInstance.encodingString(cell.nameTextField.text!)
                    let emailText = ParametersConstructor.sharedInstance.encodingString(cell.emailTextField.text!)
                    let commentText = ParametersConstructor.sharedInstance.encodingString(cell.commentTextView.text!)
                    
                    ParametersConstructor.sharedInstance.setUserInfo(name: nameText, email: emailText)
                    
                    morePost = false
                    self.arrayObjectsForCell.remove(at: tableCell.tag)
                    if let commen = arrayObjectsForCell[tableCell.tag - 1] as? CommentsFeed {
                    //tok
                    var checker = true
                    
                    NetworkManager.sharedInstance.postReplyForComment(nameText, email: emailText, comment: commentText, comment_id: commen.comment_id!) { (responce ,error) in
                        if error == nil  && responce?.result != "repeat_comment" {
                            if checker {
                                checker = false
                                var moderation = responce?.isModeration! as String!
                                moderation = moderation?.lowercased()
                                
                                if moderation == "true" {
                                    ParametersConstructor.sharedInstance.showAlert("Your comment has been submitted and is under moderation", message: "")
                                } else {
                                    ParametersConstructor.sharedInstance.showAlert("Your reply was published", message: "")
                                    self.addLocalPeplyObjectToTableView(cell: cell, commentText: commentText, nameText: nameText, emailText: emailText, index: commentPosition, forObject: commen, commentID: (responce?.result!)!)
                                }
                            }
                        } else {
                             ParametersConstructor.sharedInstance.showAlert("Something went wrong", message: "")
//                            NetworkManager.sharedInstance.postReplyForComment(nameText, email: emailText, comment: commentText, comment_id: commen.comment_id!) { (responce ,error) in
//                                self.addLocalPeplyObjectToTableView(cell: cell, commentText: commentText, nameText: nameText, emailText: emailText, index: tableCell.tag, forObject: commen, commentID: (responce?.result!)!)
//                            }
                        }
                    }
                    tableView.reloadData()
                    } else {
                        ParametersConstructor.sharedInstance.showAlert("Error", message: "Error in sending your message, try not to response yourself :)")
                        tableView.reloadData()
                    }
                } else {
                    tableCell.hideProgress()
                }
            }
        }
//        tableView.reloadData()
    }
    
    func logOutButtonPressed(tableCell: AddCommentCell,pressed logOutButton: AnyObject) {
        tableCell.nameTextField.text = nil
        tableCell.emailTextField.text = nil
        self.defaults.set("", forKey: "name")
        self.defaults.set("", forKey: "email")
        self.defaults.synchronize()
        
        Saver.sharedInstance.removeWhenLogOutbuttonPressed()
        NetworkManager.sharedInstance.logOut()
        
        tableView.reloadData()
    }
    
    //MARK : LoadMoreCell delegate
    
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
    
    //Yeah, Alamofire requests shouldn't be here, but Swift code Optimizer makes crash at that request to
    //NetworkManager, so I had to do this here
    
    func loadMoreButtonPressed(_ tableCell: LoadMoreCell, loadMoreButtonPressed loadMoreButton: AnyObject) {
        closeForms()
        if canGetCommentsFeed == true {
            canGetCommentsFeed = false
            from_count += Global.countLoadCommentsInPagination + 1
            to_count += Global.countLoadCommentsInPagination + 1
            
            Alamofire.request("\(Global.baseURL)getCommentFeed?host=\(Global.host)&article_id=\(Global.article_id)&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&time_zone=\(Global.secret_key)&from_count=\(from_count)&to_count=\(to_count)")
                .responseJSON { response in
                    
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
        //Global.articleUrl = popularArticle.articleUrl!
//        Global.article_id = popularArticle.articleId!
//        Global.api_key = popularArticle.api_key!
//        Global.host = popularArticle.host!
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectedPopularArticleNotification"), object: Global.articleUrl)
//        arrayObjectsForCell.removeAll()
//        getComments()
        
    }
    
    //MARK: Keyboard (Show/Hide/Dismiss)
    
    func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = -(keyboardSize.height/2)
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
        if indexPath.row == tableView.indexPathsForVisibleRows?.last?.row {
            let myNumber = NSNumber(value: Float(tableView.contentSize.height))
            //VuukleInfo.commentsHeight = tableView.contentSize.height
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContentHeightDidChaingedNotification"), object: myNumber)
        }
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
            //addMoreCommentsToArrayOfObjects(array: array)
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
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: redButton, style: UIAlertActionStyle.destructive, handler: { action in
            redHandler()
        }))
        alert.addAction(UIAlertAction(title: blueButton, style: UIAlertActionStyle.cancel, handler: { action in
            blueHandler()
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //Function, which hide all forms and returns new position to understand, if reply changed position of element
    
    func hideForms(position: Int) -> Int{
        if replyOpened {
            replyOpened = false
            deleteCell(position: lastReplyID)
            //arrayObjectsForCell.remove(at: lastReplyID)
            if lastReplyID < position {
                return position - 1
            }
        }
        
        if loginOpened {
            loginOpened = false
            deleteCell(position: lastLoginID)
            //arrayObjectsForCell.remove(at: lastLoginID)
            if lastLoginID < position {
                return position - 1
            }
            lastAction = .unknown
        }
        return position
    }
    
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
                print("nothing")
            }
        }
    }
    
    func hideForms() {
        var formsPositions : [Int] = []
        var formsIndexes : [IndexPath] = []
        for i in 0..<arrayObjectsForCell.count {
            if arrayObjectsForCell[i] is LoginForm || arrayObjectsForCell[i] is ReplyForm {
                formsPositions.append(i)
                let indexPath = IndexPath.init(row: i, section: 0)
                formsIndexes.append(indexPath)
            }
        }
        for value in formsPositions {
            arrayObjectsForCell.remove(at: value)
        }
        tableView.beginUpdates()
        tableView.deleteRows(at: formsIndexes, with: .fade)
        tableView.endUpdates()
        replyOpened = false
        loginOpened = false
    }
    
    func askToLogin(position: Int) {
        var newCellPosition = position + 1
        closeForms()
        arrayObjectsForCell.insert(LoginForm(), at: newCellPosition)
        insertCell(position: newCellPosition)
        lastLoginID = newCellPosition
        loginOpened = true
//      tableView.reloadData()
    }
    
    func reportComment(user: [String:String], cellId: String) {
        self.showAlert(title: "Report comment?", message: "Do you really want to report this comment?", redButton: "Report", blueButton: "Cancel"
            , redHandler: {
                
                let name = ParametersConstructor.sharedInstance.encodingString(user["name"]!)
                let email = ParametersConstructor.sharedInstance.encodingString(user["email"]!)
                NetworkManager.sharedInstance.reportComment(commentID: cellId/*cell.comment_id!*/, name: name, email: email, completion: { result, error in
                    if result! {
                        ParametersConstructor.sharedInstance.showAlert("Reported!", message: "Comment was successfully reported")
                    } else {
                        if let errorDescription = error {
                            ParametersConstructor.sharedInstance.showAlert("Error!", message: "\(errorDescription)")
                        } else {
                            ParametersConstructor.sharedInstance.showAlert("Error!", message: "Something went wrong")
                        }
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
        updateIndexesFrom(position)
        changeHeight()
    }
    
    func insertCellArray(from: Int, to: Int) {
        tableView.beginUpdates()
        var indexPathes : [IndexPath] = []
        if from <= to {
            for index in from...to {
                indexPathes.append(IndexPath.init(row: index, section: 0))
            }
            tableView.beginUpdates()
            tableView.insertRows(at: indexPathes, with: .right)
            tableView.endUpdates()
            updateIndexesFrom(from)
        }
        changeHeight()
    }
    
    func deleteCell(position: Int) {
        arrayObjectsForCell.remove(at: position)
        tableView.beginUpdates()
        let indexPath = IndexPath.init(row: position, section: 0)
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.endUpdates()
        updateIndexesFrom(position)
        changeHeight()
    }
    
    func closeForms() {
        var excessiveElements : [Int] = []
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
        changeHeight()
    }
    
    func updateIndexes() {
        for i in 0..<arrayObjectsForCell.count {
            tableView.cellForRow(at: IndexPath.init(row: i, section: 0))?.tag = i
        }
    }
    
    func updateIndexesFrom(_ index: Int) {
        for i in index..<arrayObjectsForCell.count {
            tableView.cellForRow(at: IndexPath.init(row: i, section: 0))?.tag = i
        }
    }
    
    func changeHeight() {
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            let myNumber = NSNumber(value: Float(self.tableView.contentSize.height))
            NSLog("\n \n Vuukle Library: Content Height was changed to \(myNumber) \n \n")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContentHeightDidChaingedNotification"), object: myNumber)
        })
    }
    
    
}
