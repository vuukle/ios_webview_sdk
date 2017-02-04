import UIKit
import Alamofire
import Social
//import FBSDKCoreKit
//import FBSDKLoginKit
//import STTwitter
import MessageUI

let UPDATE_FLAGS_NOTIFCATION = Notification.Name.init(rawValue: "UPDATE_FLAGS_NOTIFCATION")


class CommentViewController: UIViewController , UITableViewDelegate , UITableViewDataSource ,  UITextFieldDelegate , AddCommentCellDelegate , CommentCellDelegate ,AddLoadMoreCellDelegate , EmoticonCellDelegate , UITextViewDelegate , MostPopularArticleCellDelegate, LoginCellDelegate, MFMailComposeViewControllerDelegate {

  
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
  
  var isLoginFormOpened: Bool?
  var tableCellIndex: Int?
  
  
  //loginInfo
  var loginType : LoginType = .none
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.contentInset = Global.edgeInserts
    self.tableView.isScrollEnabled = Global.scrolingTableView
    
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
                                             selector: #selector(showTopOfTableView(sender:)),
                                             name: NSNotification.Name(rawValue: "webViewLoaded"),
                                             object: nil)
      
      getComments()
    }
    CommentViewController.shared = self
    
    UITextView.appearance().tintColor = UIColor.gray
    UITextField.appearance().tintColor = UIColor.gray
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
        
        let lPrevObject = arrayObjectsForCell[indexPath.row - 1]
        if lPrevObject is CommentForm {
          
          if indexPath.row > 1 {
            
            if let lTableCell = self.tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: 0)), lTableCell is CommentCell {
              
              let lCommentCell = lTableCell as! CommentCell
              
              lCommentCell.showReply.setTitle("  Hide", for: .normal)
            }
          }
        }
        
      } else {
        
        cell = CellConstructor.sharedInstance.returnCommentCell(cell as! CommentCell, comment: objectForCell, date: ParametersConstructor.sharedInstance.setDateInFofmat(objectForCell.ts!) as Date, newComment: ParametersConstructor.sharedInstance.decodingString(objectForCell.comment), newName: ParametersConstructor.sharedInstance.decodingString(objectForCell.name)) as! CommentCell
        
        let lNextObject = arrayObjectsForCell[indexPath.row + 1]
        
        if lNextObject is ReplyForm {
          cell.showReply.setTitle("  Hide", for: .normal)
        }
        
      }
      
      var lname = self.defaults.object(forKey: "name")
      var lemail = self.defaults.object(forKey: "email")
      
      if (self.defaults.object(forKey: "name") != nil && self.defaults.object(forKey: "email") != nil) {
        
        if self.defaults.object(forKey: "\(objectForCell.comment_id!)reported\(self.defaults.object(forKey: "name")!)\(self.defaults.object(forKey: "email")!)") as? String != nil {
          
          print("\nNOT REPORTED!\n")
          
          let image = UIImage(named: "reported_flag", in: Bundle(for: type(of: self)), compatibleWith: nil)
          cell.reportButton.setImage(image, for: .normal)
          
        } else {
          
          print("\nNOT REPORTED!\n")
          
          let image = UIImage(named: "flag-variant", in: Bundle(for: type(of: self)), compatibleWith: nil)
          print("\nIMAGE: \(image)\n")
          cell.reportButton.setImage(image, for: .normal)
        }
      } else {
        
        let image = UIImage(named: "flag-variant", in: Bundle(for: type(of: self)), compatibleWith: nil)
        print("\nIMAGE: \(image)\n")
        cell.reportButton.setImage(image, for: .normal)
      }
      
      cell.cellIndex = indexPath.row
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
      //
      return cell
      
    case is LoginForm:
      
      let objectForCell = object as! LoginForm
      
      var cell = tableView.dequeueReusableCell(withIdentifier: "LoginCell") as! LoginCell
      if cell == nil {
        cell = LoginCell() as! LoginCell
      }
      
      cell.commentCellReference = objectForCell.commetCellReference
      cell = CellConstructor.sharedInstance.returnLoginCell(cell, object: objectForCell) as! LoginCell
      cell.delegate = self
      cell.tag = indexPath.row
      //            var loginButton = FBSDKLoginButton()
      //            loginButton.readPermissions = ["public_profile", "email"]
      //            loginButton.loginBehavior = .systemAccount
      //            loginButton.frame = CGRect(x: 0, y: 0, width: 160, height: 30)
      //            loginButton.delegate = self
      //            cell.fbView.addSubview(loginButton)
      //            cell.fbView.isHidden = true
      
      //loginButton.center = cell.fbView.center
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
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0.0
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.0
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  public func getHeight() -> Float {
    let myNumber = Float(self.tableView.contentSize.height)
    return myNumber
  }
  
  //MARK: CommentCellDelegate
  
  func shareButtonPressed(_ tableCell: CommentCell, shareButtonPressed shareButton: UIButton) {
    
    if let lName = tableCell.userNameLabel.text, let lText = tableCell.commentLabel.text {
      
      print("\n[VUUKLE - UserName]   \(lName)")
      print("\n[VUUKLE - Comment]    \(lText)")
      print("\n[VUUKLE - ArticleURL] \(Global.articleUrl)\n")

      var shareText = "\(lName) commented: \"\(lText))\" on: \(Global.articleUrl)"
      var shareItems = [Any]()
      
      if (shareText != nil) {
        UIPasteboard.general.string = shareText
      }
     
      if let shareURL = ParametersConstructor.sharedInstance.checkTextIsURL(Global.articleUrl) {
        shareItems.append(shareURL)
      }
      
      let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
      
      if (UIDevice.current.userInterfaceIdiom == .phone) {
        
        activityViewController.modalPresentationStyle = .overCurrentContext
        self.present(activityViewController, animated: true, completion: nil)
        
      } else if (UIDevice.current.userInterfaceIdiom == .pad) {
        
        activityViewController.modalPresentationStyle = .popover
        self.present(activityViewController, animated: true, completion: nil)
        
        let popoverPresentationController = activityViewController.popoverPresentationController
        popoverPresentationController?.sourceView = shareButton
        popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: shareButton.frame.size.width, height: shareButton.frame.size.height)
      }
    }
  }
  
  
  func showReplyButtonPressed(_ tableCell: CommentCell, showReplyButtonPressed showReplyButton: AnyObject) {
    
    var firstLevel = 0
    var secondLevel = 0
    
    tableCell.showProgress()
    
    tableCell.showReply.setTitle("  Show", for: .normal)
    closeForms()
    
    updateIndexes(from: 0)
    
    var position = tableCell.tag
    
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
      getReplies(index: position , comment: self.arrayObjectsForCell[position] as! CommentsFeed,cell: tableCell)
      
    } else if firstLevel < secondLevel {
      removeObjectFromSortedArray(indexObject: tableCell.tag, cell: tableCell)
    }
    setHeight(sender: self)
  }
  
  func upvoteButtonPressed(_ tableCell: CommentCell, upvoteButtonPressed upvoteButton: AnyObject) {
    
    tableCell.showProgress()
    closeForms()
    
    if tableCellIndex == nil {
      if let lIndex = tableView.indexPath(for: tableCell) {
        tableCellIndex = lIndex.row
      }
    }
    
    if self.defaults.object(forKey: "email") as? String != nil && self.defaults.object(forKey: "email") as? String != "" {
      
      upvoteComment(tableCell: tableCell)
      
    } else {
      
      if let lIndex = tableCellIndex, let lCurrentIndexPath = tableView.indexPath(for: tableCell) {
        
        if lIndex == lCurrentIndexPath.row {
          
          print("\nIS OPENED = \(loginOpened)\n")
          
          if let isOpened = isLoginFormOpened, isOpened == true {
            
            tableCell.hideProgress()
            isLoginFormOpened = false
            closeForms()
            
          } else {
            
            isLoginFormOpened = true
            
            lastAction = .upvote
            lastActionPosition = tableCell.tag
            askToLogin(position: tableCell.tag, activeCell: tableCell)
            tableCell.hideProgress()
          }
        } else {
          
          tableCellIndex = lCurrentIndexPath.row

          isLoginFormOpened = true
          
          lastAction = .upvote
          lastActionPosition = tableCell.tag
          askToLogin(position: tableCell.tag, activeCell: tableCell)
          tableCell.hideProgress()
        }
      }
      
    }
  }
  
  func upvoteComment(tableCell: CommentCell) {
    
    let commen = arrayObjectsForCell[tableCell.tag] as! CommentsFeed
    var mail = ""
    
    var lName = self.defaults.object(forKey: "name")
    var lemail = self.defaults.object(forKey: "email")
    
    let lKey = "\(commen.comment_id!)voted\(lName!)\(lemail!)"
    
    if self.defaults.object(forKey: lKey) as? String == nil {
      
      mail = ParametersConstructor.sharedInstance.encodingString(self.defaults.object(forKey: "email") as! String)
      
      let name = ParametersConstructor.sharedInstance.encodingString(commen.name!)
      
      self.defaults.set(lKey, forKey: lKey)
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
          self.showSimpleAlert(title: "Successfully voted up!", message: nil)
          
        } else {
          
          self.defaults.removeObject(forKey: lKey)
          tableCell.hideProgress()
          
          // MARK: New alert with "Send Report" button
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
          
          var logMessage = "URL: \(logUrl)\n\nTYPE: Vote Up\n\nERORR: \(logErrDescription)"
          
          self.showAlertToSendReport(title: "Error", message: "Please try again later", errorMessage:logMessage)
        }
      })
    } else {
      ParametersConstructor.sharedInstance.showAlert("You have already voted!", message: "")
      tableCell.hideProgress()
    }
  }
  
  
  
  func downvoteButtonPressed(_ tableCell: CommentCell, downvoteButtonPressed downvoteButton: AnyObject) {
    
    tableCell.showProgress()
    closeForms()
    
    
    if tableCellIndex == nil {
      if let lIndex = tableView.indexPath(for: tableCell) {
        tableCellIndex = lIndex.row
      }
    }
    
    
    if self.defaults.object(forKey: "email") as? String != nil && self.defaults.object(forKey: "email") as? String != "" {
      
      downvoteComment(tableCell: tableCell)
      
    } else {
      
      if let lIndex = tableCellIndex, let lCurrentIndexPath = tableView.indexPath(for: tableCell) {
        
        if lIndex == lCurrentIndexPath.row {
          
          print("\nIS OPENED = \(loginOpened)\n")
          
          if let isOpened = isLoginFormOpened, isOpened == true {
            
            tableCell.hideProgress()
            isLoginFormOpened = false
            closeForms()
            
          } else {
            
            isLoginFormOpened = true
            
            lastAction = .downvote
            lastActionPosition = tableCell.tag
            askToLogin(position: tableCell.tag, activeCell: tableCell)
            tableCell.hideProgress()
          }
        } else {
          
          tableCellIndex = lCurrentIndexPath.row
          
          isLoginFormOpened = true
          
          lastAction = .downvote
          lastActionPosition = tableCell.tag
          askToLogin(position: tableCell.tag, activeCell: tableCell)
          tableCell.hideProgress()
        }
      }
      
    }
  }
  
  func downvoteComment(tableCell: CommentCell) {
    
    let commen = arrayObjectsForCell[tableCell.tag] as! CommentsFeed
    
    var mail = ""
    
    var lName = self.defaults.object(forKey: "name")
    var lemail = self.defaults.object(forKey: "email")
    
    let lKey = "\(commen.comment_id!)voted\(lName!)\(lemail!)"
    
    if UserDefaults.standard.object(forKey: lKey) as? String == nil {
      
      mail = ParametersConstructor.sharedInstance.encodingString(self.defaults.object(forKey: "email") as! String)
      
      let name = ParametersConstructor.sharedInstance.encodingString(commen.name!)
      
      UserDefaults.standard.set(lKey, forKey: lKey)
      
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
          self.showSimpleAlert(title: "Successfully voted down!", message: nil)
          
        } else {
          
          self.defaults.removeObject(forKey: lKey)
          
          tableCell.hideProgress()
          
          // MARK: New alert with "Send Report" button
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
          
          var logMessage = "URL: \(logUrl)\n\nTYPE: Vote Down\n\nERORR: \(logErrDescription)"
          
          self.showAlertToSendReport(title: "Error", message: "Please try again later", errorMessage:logMessage)
        }
      })
    } else {
      ParametersConstructor.sharedInstance.showAlert("You have already voted!", message: "")
      tableCell.hideProgress()
    }
  }
  
  
  func moreButtonPressed(_ tableCell: CommentCell, moreButtonPressed moreButton: AnyObject) {
    
    if tableCellIndex == nil {
      if let lIndex = tableView.indexPath(for: tableCell) {
        tableCellIndex = lIndex.row
      }
    }
    
    let user = ParametersConstructor.sharedInstance.getUserInfo()
    let cell = self.arrayObjectsForCell[tableCell.tag] as! CommentsFeed
    
    if user["isLoggedIn"] == "true" {
      reportComment(user: user, cellId: cell.comment_id!, cell: tableCell)
      
    } else {
      
      if let lIndex = tableCellIndex, let lCurrentIndexPath = tableView.indexPath(for: tableCell) {
        
        if lIndex == lCurrentIndexPath.row {
          
          print("\nIS OPENED = \(loginOpened)\n")
          
          if let isOpened = isLoginFormOpened, isOpened == true {
            
            tableCell.hideProgress()
            isLoginFormOpened = false
            closeForms()
            
          } else {
            
            isLoginFormOpened = true
            
            lastAction = .report
            lastActionPosition = tableCell.tag
            reportId = cell.comment_id!
            askToLogin(position: lastActionPosition, activeCell: tableCell)
            tableCell.hideProgress()
          }
        } else {
          
          closeForms()
          tableCellIndex = lCurrentIndexPath.row
          
          isLoginFormOpened = true
          
          lastAction = .report
          lastActionPosition = tableCell.tag
          reportId = cell.comment_id!
          askToLogin(position: lastActionPosition, activeCell: tableCell)
          tableCell.hideProgress()
        }
      }
      
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
          
          self.getMostPopularArticles(reload: true)
          
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
  
  func getReplies(index: Int , comment: CommentsFeed, cell: CommentCell) {
    
    cell.showReply.setTitle("  Hide", for: .normal)
    cell.showReply.isEnabled = false
    
    NetworkManager.sharedInstance.getRepliesForComment(comment.comment_id!, parent_id: comment.parent_id! , completion: { (arrayReplies , error) in
      
      if error == nil {
        
        cell.showReply.isEnabled = true
        
        let repliesArray = arrayReplies
        self.loadReply = true
        
        for r in repliesArray! {
          
          r.level = comment.level! + 1
          //if index
          self.arrayObjectsForCell.insert(r, at: index + 1)
          self.insertCell(position: index + 1)
        }
        
        if let cell = self.tableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as? CommentCell {
          
          NotificationCenter.default.post(name: STOP_ALL_PROGRESS_KEY, object: nil)
        }
        
      } else {
        
        cell.showReply.isEnabled = true
        
        if let cell = self.tableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as? CommentCell {
          
          NotificationCenter.default.post(name: STOP_ALL_PROGRESS_KEY, object: nil)
          //cell.hideProgress()
          cell.showReply.setTitle("  Show", for: .normal)
          //cell.showReply.isEnabled = true
        }
        //cell.showReply.isEnabled = true
      }
      //self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    })
  }
  
  func removeObjectFromSortedArray (indexObject: Int, cell: CommentCell) {
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
      removeObjectFromSortedArray(indexObject: indexObject, cell: cell)
      
    } else if firstLevel == secondLevel {
      
      let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
      DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
        self.tableView.reloadRows(at: [IndexPath(row: indexObject, section: 0)], with: .none)
      })
      //tableView.reloadData()
    } else {
      //cell.hideProgress()
      NotificationCenter.default.post(name: STOP_ALL_PROGRESS_KEY, object: nil)
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
        
        if (ParametersConstructor.sharedInstance.checkFields(cell.nameTextField.text!, email: cell.emailTextField.text!, comment: cell.commentTextView.text)) == true {
          
          morePost = false
          
          let name = ParametersConstructor.sharedInstance.encodingString(cell.nameTextField.text!)
          let email = ParametersConstructor.sharedInstance.encodingString(cell.emailTextField.text!)
          let comment = ParametersConstructor.sharedInstance.encodingString(cell.commentTextView.text!)
          
          ParametersConstructor.sharedInstance.setUserInfo(name: name, email: email)
          
          NetworkManager.sharedInstance.postComment(name, email: email, comment: comment, cell: tableCell) { (respon , error) in
            
            if (error == nil && respon?.result != "error" && respon?.comment_id != "repeat_comment") {
              
              self.morePost = true
              
              var allow = respon?.isModeration
              
              if (allow == "true") {
                
                ParametersConstructor.sharedInstance.showAlert("Your comment has been submitted and is under moderation", message: "")
                self.reloadAddCommentField()
                
              } else {
                
                ParametersConstructor.sharedInstance.showAlert("Your comment has been published", message: "")
                
                tableCell.isSocialLoginHidden = true
                
                self.closeForms()
                self.addLocalCommentObjectToTableView(cell: cell, commentText: comment, nameText: name, emailText: email,commentID: (respon?.comment_id)! , index : tableCell.tag)
              }
              
            } else {
              
              if (respon?.result == "error" && respon?.comment_id == "repeat_comment") {
                
                tableCell.hideProgress()
                self.closeForms()
                self.showSimpleAlert(title: "Repeat Comment!", message: nil)
                
              } else {
                
                // MARK: New alert with "Send Report" button
                
                var logResult = "nil"
                var logCommentID = "nil"
                var logIsModeraion = "nil"
                
                if (respon != nil) {
                  
                  logResult = (respon?.result != nil) ? (respon?.result)! : "nil"
                  logCommentID = (respon?.comment_id != nil) ? (respon?.comment_id)! : "nil"
                  logIsModeraion = (respon?.isModeration != nil) ? (respon?.isModeration)! : "nil"
                }
                
                var logErrDescription = "nil"
                var logErrFailureReason = "nil"
                
                if (error != nil) {
                  
                  logErrDescription = (error?.localizedDescription != nil) ? (error?.localizedDescription)! : "nil"
                  logErrFailureReason = (error?.localizedFailureReason != nil) ? (error?.localizedFailureReason)! : "nil"
                }
                
                let logURL = (respon?.requestURL != nil) ? (respon?.requestURL)! : "nil"
                
                var logMessage = "URL: \(logURL)\n\nRESULT: \(logResult)\n\nCOMMENT_ID: \(logCommentID)\n\nIS_MODERATION: \(logIsModeraion)\n\nERORR: \(logErrDescription)\nSTATUS_CODE: \(respon?.statusCode)"
                
                self.showAlertToSendReport(title: "Error", message: "Something went wrong", errorMessage:logMessage)
                
                tableCell.hideProgress()
              }
            }
          }
        }
        else {
          
          tableCell.postButtonOutlet.isEnabled = true
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
        
        tableCell.isSocialLoginHidden = true
        
        morePost = false
        //self.arrayObjectsForCell.remove(at: tableCell.tag)
        if let commen = arrayObjectsForCell[tableCell.tag - 1] as? CommentsFeed {
          
          var checker = true
          
          NetworkManager.sharedInstance.postReplyForComment(nameText, email: emailText, comment: commentText, comment_id: commen.comment_id!, cell: tableCell) { (responce ,error) in
            
            if error == nil  && responce?.result != "repeat_comment" {
              
              if checker {
                
                checker = false
                var moderation = responce?.isModeration! as String!
                moderation = moderation?.lowercased()
                tableCell.hideProgress()
                
                if moderation == "true" {
                  
                  ParametersConstructor.sharedInstance.showAlert("Your reply has been submitted and is under moderation", message: "")
                  tableCell.hideProgress()
                  self.reloadAddCommentField()
                  
                } else {
                  
                  ParametersConstructor.sharedInstance.showAlert("Your reply has been published", message: "")
                  
                  tableCell.isSocialLoginHidden = true
                  
                  self.addLocalPeplyObjectToTableView(cell: cell, commentText: commentText, nameText: nameText, emailText: emailText, index: commentPosition, forObject: commen, commentID: (responce?.comment_id!)!)
                  
                }
                self.closeForms()
              }
              
            } else {
              
              if responce?.result == "repeat_comment" {
                
                tableCell.hideProgress()
                self.closeForms()
                self.showSimpleAlert(title: "Repeat Comment!", message: nil)
                
              } else {
                
                // MARK: New alert with "Send Report" button
                var logResult = "nil"
                var logCommentID = "nil"
                var logIsModeraion = "nil"
                
                if (responce != nil) {
                  
                  logResult = (responce?.result != nil) ? (responce?.result)! : "nil"
                  logCommentID = (responce?.comment_id != nil) ? (responce?.comment_id)! : "nil"
                  logIsModeraion = (responce?.isModeration != nil) ? (responce?.isModeration)! : "nil"
                }
                
                var logErrDescription = "nil"
                var logErrFailureReason = "nil"
                
                if (error != nil) {
                  logErrDescription = (error?.localizedDescription != nil) ? (error?.localizedDescription)! : "nil"
                  logErrFailureReason = (error?.localizedFailureReason != nil) ? (error?.localizedFailureReason)! : "nil"
                }
                
                let logURL = (responce?.requestURL != nil) ? (responce?.requestURL)! : "nil"
                
                var logMessage = "URL: \(logURL)\n\nRESULT: \(logResult)\n\nCOMMENT_ID: \(logCommentID)\n\nIS_MODERATION: \(logIsModeraion)\n\nERORR: \(logErrDescription)\nSTATUS_CODE: \(responce?.statusCode)"
                
                print("\(logMessage)")
                
                self.showAlertToSendReport(title: "Error", message: "Something went wrong", errorMessage:logMessage)
                
                tableCell.hideProgress()
              }
            }
          }
        }
      } else {
        
        tableCell.postButtonOutlet.isEnabled = true
        tableCell.hideProgress()
      }
    } else {
      
      tableCell.hideProgress()
      tableCell.postButtonOutlet.isEnabled = true
    }
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
    
    print("\n\(errorMessage)\n")
    
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let mailComposeVC = configureMailComposerViewController(errorMessage: errorMessage)
    mailComposeVC.modalPresentationStyle = .overCurrentContext
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [unowned self] action -> Void in
      alertVC.dismiss(animated: true, completion: nil)
      self.tableView.reloadData()
    }
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
  func loginButtonPressed(tableCell: LoginCell, activeCommentCell: CommentCell, pressed loginButton: AnyObject) {
    
    
    let name = tableCell.nameField.text!
    let email = tableCell.emailField.text!
    
    if ParametersConstructor.sharedInstance.checkFields(name, email: email, comment: "JustTesting") {
      
      ParametersConstructor.sharedInstance.setUserInfo(name: name, email: email)
      self.view.endEditing(true)
      closeForms()
      
      self.tableView.reloadData()
      
      continueAction(commentCell: activeCommentCell)
    }
  }
  
  func loginFacebookPressed(tableCell: LoginCell, activeCommentCell: CommentCell, pressed loginButton: UIButton) {
    
    tableCell.showProgress()
    SocialNetworksTracker.sharedTracker.logInFacebook(successClosure: { (dictionary) in
      
      tableCell.hideProgress()
      
      let name = SocialNetworksUser.sharedInstance.facebookName
      let email = SocialNetworksUser.sharedInstance.facebookEmail
      
      if ParametersConstructor.sharedInstance.checkFields(name, email: email, comment: "JustTesting") {
        
        ParametersConstructor.sharedInstance.setUserInfo(name: name, email: email)
        
        self.view.endEditing(true)
        self.closeForms()
        
        self.tableView.reloadData()
        
        self.continueAction(commentCell: activeCommentCell)
      }
      
    }, errorClosure: { [unowned self] (error) in
      
      tableCell.hideProgress()
      
      let errorReason = error?.localizedDescription
      print(errorReason)
      if (errorReason == "facebook_login_canceled") {
        self.showSimpleAlert(title: "Log in with Facebook was canceled", message: "If you want to share comments with your Facebook name, you have to complete logination.")
      } else {
        self.showSimpleAlert(title: "Error to log in Facebook", message: "Please check Internet connection, device settings and try again.")
      }
    })
    
  }
  
  func loginTwitterPressed(tableCell: LoginCell, activeCommentCell: CommentCell, pressed loginButton: UIButton) {
    
    tableCell.showProgress()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
      tableCell.hideProgress()
    }
    
    SocialNetworksTracker.sharedTracker.logInTwitter(successClosure: { [unowned self] (dict) in
      
      tableCell.hideProgress()
      
      let name = SocialNetworksUser.sharedInstance.twitterName
      let email = SocialNetworksUser.sharedInstance.twitterEmail
      
      if ParametersConstructor.sharedInstance.checkFields(name, email: email, comment: "JustTesting") {
        
        ParametersConstructor.sharedInstance.setUserInfo(name: name, email: email)
        
        self.view.endEditing(true)
        self.closeForms()
        
        self.tableView.reloadData()
        
        self.continueAction(commentCell: activeCommentCell)
      }
      
      }, errorClosure: { [unowned self] (twitterError) in
        
        tableCell.hideProgress()
        
        print(twitterError?.localizedDescription)
        self.showSimpleAlert(title: "Error to log in Twitter", message: "Please check Internet connection, device settings and try again.")
    })
    
  }
  
  
  
  
  //Yeah, Alamofire requests shouldn't be here, but Swift code Optimizer makes crash at that request to
  //NetworkManager, so I had to do this here
  
  func loadMoreButtonPressed(_ tableCell: LoadMoreCell, loadMoreButtonPressed loadMoreButton: AnyObject) {
    
    closeForms()
    
    if canGetCommentsFeed == true {
      
      canGetCommentsFeed = false
      
      from_count += Global.countLoadCommentsInPagination + 1
      to_count += Global.countLoadCommentsInPagination + 1
      
      NetworkManager.sharedInstance.loadMoreComments(fromCount: from_count, toCount: to_count) { [unowned self] (responseArray, error) in
        
        if error == nil && responseArray != nil {
          
          self.addMoreCommentsToArrayOfObjects(responseArray: responseArray!)
          
        } else {
          
          self.showSimpleAlert(title: "Error!", message: "Can't load more comments =(")
          
          tableCell.activityIndicator.isHidden = true
          tableCell.activityIndicator.stopAnimating()
          tableCell.loadMore.isHidden = false
        }
      }
    }
  }
  
  func openVuukleButtonButtonPressed(_ tableCell: LoadMoreCell, openVuukleButtonPressed openVuukleButton: AnyObject) {
    UIApplication.shared.openURL(NSURL(string: Global.websiteUrl)! as URL)
  }
  
  //Mark: EmoticonCellDelegate
  
  func firstEmoticonButtonPressed(_ tableCell: EmoticonCell, firstEmoticonButtonPressed firstEmoticonButton: AnyObject) {
    voteForEmotion(emoteIndex: 1, articleID: Global.article_id)
  }
  
  func secondEmoticonButtonPressed(_ tableCell: EmoticonCell, secondEmoticonButtonPressed secondEmoticonButton: AnyObject) {
    voteForEmotion(emoteIndex: 2, articleID: Global.article_id)
  }
  
  func thirdEmoticonButtonPressed(_ tableCell: EmoticonCell, thirdEmoticonButtonPressed thirdEmoticonButton: AnyObject) {
    voteForEmotion(emoteIndex: 3, articleID: Global.article_id)
  }
  
  func fourthEmoticonButtonPressed(_ tableCell: EmoticonCell, fourthEmoticonButtonPressed fourthEmoticonButton: AnyObject) {
    voteForEmotion(emoteIndex: 4, articleID: Global.article_id)
  }
  
  func fifthEmoticonButtonPressed(_ tableCell: EmoticonCell, fifthEmoticonButtonPressed fifthEmoticonButton: AnyObject) {
    voteForEmotion(emoteIndex: 5, articleID: Global.article_id)
  }
  
  func sixthEmoticonButtonPressed(_ tableCell: EmoticonCell, sixthEmoticonButtonPressed sixthEmoticonButton: AnyObject) {
    voteForEmotion(emoteIndex: 6, articleID: Global.article_id)
  }
  
  
  func voteForEmotion(emoteIndex: Int, articleID: String) {
    
    let lKey = "\(articleID)votedEmotion"
    var lEmotion = ""
    
    if UserDefaults.standard.object(forKey: lKey) as? Int == nil {
      
      switch emoteIndex {
        
      case 1:
        Global.firstEmoticonVotesCount += 1
        UserDefaults.standard.set(1, forKey: lKey)
        lEmotion = "😄"
      case 2:
        Global.secondEmoticonVotesCount += 1
        UserDefaults.standard.set(2, forKey: lKey)
        lEmotion = "😐"
      case 3:
        Global.thirdEmoticonVotesCount += 1
        UserDefaults.standard.set(3, forKey: lKey)
        lEmotion = "😏"
      case 4:
        Global.fourthEmoticonVotesCount += 1
        UserDefaults.standard.set(4, forKey: lKey)
        lEmotion = "😂"
      case 5:
        Global.fifthEmoticonVotesCount += 1
        UserDefaults.standard.set(5, forKey: lKey)
        lEmotion = "😡"
      case 6:
        Global.sixthEmoticonVotesCount += 1
        UserDefaults.standard.set(6, forKey: lKey)
        lEmotion = "☹️"
      default:
        break
      }
      
      NetworkManager.sharedInstance.setRaring(articleID, emote: emoteIndex) { [unowned self] (response, error) in
        
        if error == nil {
          
          self.showSimpleAlert(title: "Voted successfuly for \(lEmotion)!", message: nil)
          self.reloadEmotionCell()
          
        } else {
          UserDefaults.standard.removeObject(forKey: lKey)
        }
      }
    } else {
      showSimpleAlert(title: "You have already voted!", message: nil)
    }
  }
  
  
  //MARK: MostPopularArticleCellDelegate
  
  func showArticleButtonPressed(_ tableCell: MostPopularArticleCell, _ showArticle: AnyObject) {
    closeForms()
    
    var popularArticle = arrayObjectsForCell[tableCell.tag] as! MostPopularArticle
    
    if let articleUrl = popularArticle.articleUrl {
      
      NotificationCenter.default.post(name: Notification.Name("VuukleOpenMostPopularArticle"),
                                      object: articleUrl)
      //UIApplication.shared.openURL(URL(string: articleUrl)!)
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
  func addLocalPeplyObjectToTableView(cell: AddCommentCell, commentText: String, nameText: String , emailText: String , index: Int ,forObject: CommentsFeed , commentID: String) {
    
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
    
    let lObject = arrayObjectsForCell[index - 1]
  
    if lObject is CommentsFeed {
      
      let lCommentObject = lObject as! CommentsFeed
      
      if let lID = lCommentObject.comment_id, let lParentID = lCommentObject.parent_id {
        
        NetworkManager.sharedInstance.getRepliesForComment(lID, parent_id: lParentID) { (arrayReplies , error) in
          
          print("\n\(arrayReplies)\n")
          
          if let lNewReplyObject = arrayReplies?.first {
 
            let lOldObject = self.arrayObjectsForCell[index]
            if lOldObject is CommentsFeed {
              
              let lCurrentReply = lOldObject as! CommentsFeed
              
              if let lNewRating = lNewReplyObject.user_points {
                lCurrentReply.user_points = lNewRating
              }
              
              if let lNewName = lNewReplyObject.name {
                lCurrentReply.name = lNewName
              }
              
              if let lNewUrl = lNewReplyObject.avatar_url {
                lCurrentReply.avatar_url = lNewUrl
              }
              self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
          }
        }
      }
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now()) {
      
      for i in 0...(self.arrayObjectsForCell.count - 2) {
        
        if self.arrayObjectsForCell[i] is CommentsFeed,
          self.arrayObjectsForCell[i + 1] is CommentsFeed {
          
          let lObj1 = self.arrayObjectsForCell[i] as! CommentsFeed
          let lObj2 = self.arrayObjectsForCell[i + 1] as! CommentsFeed
          
          if let level1 = lObj1.level, let level2 = lObj2.level {
            
            if level1 < level2 {
              
              let lIndexPath = IndexPath(row: i, section: 0)
              
              if let lTableCell = self.tableView.cellForRow(at: lIndexPath) {
                
                if lTableCell is CommentCell {
                  
                  let lCommentCell = lTableCell as! CommentCell
                  lCommentCell.showReply.setTitle("  Hide", for: .normal)
                }
              }
            }
          }
          
        }
      }

    }
  
    
    NotificationCenter.default.post(name: UPDATE_FLAGS_NOTIFCATION, object: self.arrayObjectsForCell)
  }
  
  func addLocalCommentObjectToTableView(cell : AddCommentCell, commentText : String, nameText: String , emailText: String , commentID: String , index: Int) {
    
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
  
    
    if index >= 1 {
      
      NetworkManager.sharedInstance.loadMoreComments(fromCount: index - 1, toCount: index - 1) { (responseArray, error) in
        
        if error == nil && responseArray != nil {
          
          if let newObject = responseArray?.first {
            if let lRating = newObject.user_points {
              
              if self.arrayObjectsForCell[index + 1] is CommentsFeed  {
                
                let lCurrentObject = self.arrayObjectsForCell[index + 1] as! CommentsFeed
                lCurrentObject.user_points = lRating
                
                self.tableView.reloadRows(at: [IndexPath(row: index + 1, section: 0)], with: .none)
              }
            }
          }
        }
      }
    }

    
    NotificationCenter.default.post(name: UPDATE_FLAGS_NOTIFCATION, object: self.arrayObjectsForCell)
  }
  
  func addMoreCommentsToArrayOfObjects(responseArray: [CommentsFeed]) {
    
    print("\nCOUNT BEFORE = \(arrayObjectsForCell.count)\n")
    
    removeLoadMoreAndMostPopularArticle()
    print("\nCOUNT REMOVE = \(arrayObjectsForCell.count)\n")
    
    for commentObject in responseArray {
      
      self.arrayObjectsForCell.append(commentObject)
    }
    print("\nCOUNT WITH NEW = \(arrayObjectsForCell.count)\n")
    
    if Global.setMostPopularArticleVisible {
      getMostPopularArticles(reload: true)
    }
    
    print("\nCOUNT MOST = \(arrayObjectsForCell.count)\n")
    
    self.canLoadmore = true
    self.canGetCommentsFeed = true
    
    if responseArray.count >= Global.countLoadCommentsInPagination{
      
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
      
      if Global.setAdsVisible == true {
        self.arrayObjectsForCell.append(WebView())
      }
      if Global.showEmoticonCell == true {
        self.arrayObjectsForCell.append(Emoticon())
      }
      
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
      
      if Global.setAdsVisible == true {
        self.arrayObjectsForCell.append(WebView())
      }
      
      if Global.showEmoticonCell == true {
        self.arrayObjectsForCell.append(Emoticon())
      }
      
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
  
  func getMostPopularArticles(reload: Bool) {
    
    if Global.setMostPopularArticleVisible {
      
      NetworkManager.sharedInstance.getMostPopularArticle { [unowned self] (responArray, error) in
        
        if error == nil, let topArticlesArray = responArray  {
          
          for article in topArticlesArray {
            self.arrayObjectsForCell.append(article)
          }
       
          if reload {
            self.tableView.reloadData()
          }
        } else {
          self.showSimpleAlert(title: "Error to get most popular articles =(", message: nil)
        }
      }
    }
  }
  
  
  func removeLoadMoreAndMostPopularArticle() {
    
    if Global.setMostPopularArticleVisible == true {
      
      var removedCount: Int = 0
      
      for i in 0..<arrayObjectsForCell.count {
        
        if (arrayObjectsForCell[i] is MostPopularArticle || arrayObjectsForCell[i] is LoadMore) {
          removedCount += 1
        }
      }
      for i in 0..<removedCount {
        arrayObjectsForCell.removeLast()
      }
      
    } else {
      
      if arrayObjectsForCell[arrayObjectsForCell.count - 1] is LoadMore {
        
        self.arrayObjectsForCell.removeLast()
      } else {
        
        for i in 0..<arrayObjectsForCell.count {
          
          if (arrayObjectsForCell[i] is LoadMore) {
            self.arrayObjectsForCell.removeLast()
          }
        }
      }
    }
  }
  
  
  func setHeight(sender: AnyObject) {
    
    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    
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
  
  
  //Function, which continues previous action after logination
  
  func continueAction(commentCell: CommentCell) {
    
    commentCell.showProgress()
    
    if lastActionPosition != -1 {
      
      let cell = arrayObjectsForCell[lastActionPosition] as! CommentsFeed
      switch lastAction {
        
      case .upvote:
        upvoteComment(tableCell: commentCell)
      case .downvote:
        downvoteComment(tableCell: commentCell)
      case .report:
        reportComment(user: ParametersConstructor.sharedInstance.getUserInfo(), cellId: reportId, cell: commentCell)
      default:
        break
      }
    }
  }
  
  func askToLogin(position: Int, activeCell: CommentCell) {
    
    var newCellPosition = position + 1
    closeForms()
    
    let loginForm = LoginForm()
    loginForm.commetCellReference = activeCell
    
    arrayObjectsForCell.insert(loginForm, at: newCellPosition)
    
    insertCell(position: newCellPosition)
    lastLoginID = newCellPosition
  }
  
  
  func reportComment(user: [String:String], cellId: String, cell: CommentCell) {
    
    let lKey = "\(cellId)reported\(user["name"]!)\(user["email"]!)"
    
    if (UserDefaults.standard.object(forKey: lKey) as? String == nil) {
      
      self.showAlert(title: "Report comment?", message: "Do you really want to report this comment?", redButton: "Report", blueButton: "Cancel"
        , redHandler: {
          
          if (UserDefaults.standard.object(forKey: lKey) as? String == nil) {
            
            self.defaults.set(lKey, forKey: lKey)
            
            let name = ParametersConstructor.sharedInstance.encodingString(user["name"]!)
            let email = ParametersConstructor.sharedInstance.encodingString(user["email"]!)
            
            cell.showProgress()
            
            NetworkManager.sharedInstance.reportComment(commentID: cellId, name: name, email: email, cell: cell ,completion: { result, error in
              
              if result! {
                
                let image = UIImage(named: "reported_flag", in: Bundle(for: type(of: self)), compatibleWith: nil)
                print("\nIMAGE: \(image)\n")
                
                cell.reportButton.setImage(image, for: .normal)
                
                ParametersConstructor.sharedInstance.showAlert("Reported!", message: "Comment was successfully reported")
                
              } else {
                
                self.defaults.removeObject(forKey: lKey)
                
                // MARK: New alert with "Send Report" button
                let logUrl = "\(Global.baseURL)flagCommentOrReply?comment_id=\(cellId)&api_key=\(Global.api_key)&article_id=\(Global.article_id)&resource_id=\(Global.resource_id)&name=\(name)&email=\(email)"
                
                var logErrDescription = "nil"
                var logErrFailureReason = "nil"
                
                if ((error) != nil) {
                  logErrDescription = (error?.localizedDescription != nil) ? (error?.localizedDescription)! : "nil"
                  logErrFailureReason = (error?.localizedFailureReason != nil) ? (error?.localizedFailureReason)! : "nil"
                }
                
                var logMessage = "URL: \(logUrl)\n\nERORR: \(logErrDescription)"
                
                self.showAlertToSendReport(title: "Error", message: "Something went wrong", errorMessage:logMessage)
              }
            })
          } else {
            self.showSimpleAlert(title: "You have already reported!", message: nil)
          }
      }
        , blueHandler: {
          print("Canceled")
      })
      
    } else {
      self.showSimpleAlert(title: "You have already reported!", message: nil)
    }
  }
  
  func insertCell(position: Int) {
    
    tableView.beginUpdates()
    let indexPath = IndexPath.init(row: position, section: 0)
    tableView.insertRows(at: [indexPath], with: .right)
    tableView.endUpdates()
    updateIndexes(from: position)
    
    UserDefaults.standard.set(true, forKey: "IS_LOGIN_FORM_OPENED")
    //changeHeight()
    //tableView.scrollToRow(at: IndexPath.init(row: position - 1, section: 0), at: .bottom, animated: true)
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
      //updateIndexesFrom(from)
    }
    changeHeight()
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
      
      let index = IndexPath.init(row: i, section: 0)
      tableView.cellForRow(at: index)?.tag = i
      
      if tableView.cellForRow(at: index) is CommentCell {
        
        let lCommentCell = tableView.cellForRow(at: index) as! CommentCell
        lCommentCell.cellIndex = i
      }
    }
  }
  
  func changeHeight() {
    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
      let myNumber = NSNumber(value: Float(self.tableView.contentSize.height))
      NSLog("\n \n Vuukle Library: Content Height was changed to \(myNumber) \n \n")
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContentHeightDidChaingedNotification"), object: myNumber)
    })
  }
  
  func loginUser(name: String, email: String, with: LoginType) {
    ParametersConstructor.sharedInstance.setUserInfo(name: name, email: email)
    login(with: with)
    
  }
  
  
  //MARK: - Methods for Facebook
  func facebookLoginButtonPressed(tableCell: AddCommentCell, pressed facebookLoginButton: AnyObject) {
    
    tableCell.showProgress()
    SocialNetworksTracker.sharedTracker.logInFacebook(successClosure: { (dictionary) in
      
      tableCell.hideProgress()
      tableCell.isSocialLoginHidden = true
      
      ParametersConstructor.sharedInstance.setUserInfo(name: SocialNetworksUser.sharedInstance.facebookName, email: SocialNetworksUser.sharedInstance.facebookEmail)
      self.reloadAddCommentField()
      
    }, errorClosure: { [unowned self] (error) in
      
      tableCell.hideProgress()
      
      let errorReason = error?.localizedDescription
      print(errorReason)
      if (errorReason == "facebook_login_canceled") {
        self.showSimpleAlert(title: "Log in with Facebook was canceled", message: "If you want to share comments with your Facebook name, you have to complete logination.")
      } else {
        self.showSimpleAlert(title: "Error to log in Facebook", message: "Please check Internet connection, device settings and try again.")
      }
    })
    
    
    
    
  }
  
  //MARK: - Methods for Twitter
  func twitterLoginButtonPressed(tableCell : AddCommentCell, pressed twitterLoginButton: AnyObject) {
    
    tableCell.showProgress()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
      tableCell.hideProgress()
    }
    
    SocialNetworksTracker.sharedTracker.logInTwitter(successClosure: { [unowned self] (dict) in
      
      tableCell.hideProgress()
      tableCell.isSocialLoginHidden = true
      
      ParametersConstructor.sharedInstance.setUserInfo(name: SocialNetworksUser.sharedInstance.twitterName, email: SocialNetworksUser.sharedInstance.twitterEmail)
      self.reloadAddCommentField()
      
      }, errorClosure: { [unowned self] (twitterError) in
        
        tableCell.hideProgress()
        
        print(twitterError?.localizedDescription)
        self.showSimpleAlert(title: "Error to log in Twitter", message: "Please check Internet connection, device settings and try again.")
    })
  }
  
  
  func login(with: LoginType) {
    
    loginType = with
    self.view.endEditing(true)
    if arrayObjectsForCell.count > 2 {
      tableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .none)
    } else {
      print("Vuukle is not found")
    }
  }
  
  /*
   //MARK: - Sharing to Facebook/Twitter
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
   }*/
  
  
  func googleLoginButtonPressed(tableCell : AddCommentCell, pressed googleLoginButton: AnyObject) {
    
  }
  
  func linkedinLoginButtonPressed(tableCell : AddCommentCell, pressed linkedinLoginButton: AnyObject){
    
    
  }
  
  func reloadAddCommentField() {
    
    for i in 0..<arrayObjectsForCell.count {
      
      if (arrayObjectsForCell[i] is CommentForm || arrayObjectsForCell[i] is ReplyForm) {
        tableView.reloadRows(at: [IndexPath.init(row: i, section: 0)], with: .none)
      }
    }
  }
  
  func reloadEmotionCell() {
    
    for i in 0..<arrayObjectsForCell.count {
      
      if (arrayObjectsForCell[i] is Emoticon) {
        tableView.reloadRows(at: [IndexPath.init(row: i, section: 0)], with: .none)
        return
      }
    }
  }
  
  //MARK: - Log Out button action
  func logOutButtonPressed(tableCell: AddCommentCell,pressed logOutButton: AnyObject) {
    
    tableCell.nameTextField.text = nil
    tableCell.emailTextField.text = nil
    
    closeForms()
    tableCell.nameTextField.text = nil
    tableCell.emailTextField.text = nil
    self.defaults.removeObject(forKey: "name")
    self.defaults.removeObject(forKey: "email")
    self.defaults.synchronize()
    
    Saver.sharedInstance.removeWhenLogOutbuttonPressed()
    NetworkManager.sharedInstance.logOut()
    
    tableView.reloadRows(at: [IndexPath.init(row: tableCell.tag, section: 0)], with: .none)
    tableView.reloadData()
  }
}
