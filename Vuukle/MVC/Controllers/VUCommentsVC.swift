//
//  VUCommentsTableVC.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit
import MessageUI


class VUCommentsVC: UIViewController {
  
  // Singleton
  static let sharedInstance: VUCommentsVC = UIStoryboard(name: "Vuukle", bundle: Bundle(for: VUCommentsVC.self)).instantiateViewController(withIdentifier: VUIdentifiersUI.VUCommentVC) as! VUCommentsVC

  let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  
  
  // MARK: - @IBOutlets
  @IBOutlet weak var tableView: UITableView!
  

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    registerCellsFromNib()
    setTableViewDesign()
    
    addObserverForNewDesignNotification()
    
    VUModelsFactory.generateObjectsForCells(false, contentView: nil)
  }

  
  // MARK: - Methods for keyboard
  func changeFieldOffsetForKeyboard(_ textField: UITextField, keyboardHeight: CGFloat) {
    
    if let superview = textField.superview, let baseVC = VUCommentsBuilderModel.vBaseVC {
      
      let pointsInScreen = superview.convert(textField.frame.origin,
                                             to: baseVC.view)
      var correctedOffset = pointsInScreen.y
      correctedOffset += offsetCorrectionTextField
      
      let newY = keyboardHeight - (UIScreen.main.bounds.height - correctedOffset)
      
      if VUGlobals.isCommentsScrollEnabled {
        changeTableViewOffsetForKeyboard(newY)
        
      } else {
        changeScrollViewOffsetForKeyboard(newY)
      }
    }
  }
  
  func changeViewOffsetForKeyboard(_ textView: UITextView, keyboardHeight: CGFloat) {
    
    if let superview = textView.superview, let baseVC = VUCommentsBuilderModel.vBaseVC {
      
      let pointsInScreen = superview.convert(textView.frame.origin,
                                             to: baseVC.view)
      var correctedOffset = pointsInScreen.y
      correctedOffset += offsetCorrectionTextView
      
      let newY = keyboardHeight - (UIScreen.main.bounds.height - correctedOffset)
      
      if VUGlobals.isCommentsScrollEnabled {
        changeTableViewOffsetForKeyboard(newY)
        
      } else {
        changeScrollViewOffsetForKeyboard(newY)
      }
    }
  }
  
  var offsetCorrectionTextField: CGFloat {
    
    if UIApplication.shared.statusBarOrientation.isPortrait {
      return 42.0
      
    } else {
      
      switch VUGlobals.currentDeviceType {
        
      case .iPhone6, .iPhonePlus:
        return 34.0
        
      default: break
      }
    }
    return 0
  }
  
  var offsetCorrectionTextView: CGFloat {
    
    if UIApplication.shared.statusBarOrientation.isPortrait {
      
      if VUCurrentUser.isUserLogined {
        return 140.0
      } else {
        return 64.0
      }
    } else {
      
      switch VUGlobals.currentDeviceType {
        
      case .iPhone6:
        return 36.0
        
      case .iPhonePlus:
        return 60.0
        
      default: break
      }
    }
    return 0
  }
  
  func changeTableViewOffsetForKeyboard(_ offset: CGFloat) {
    
    if let tableView = tableView {
      
      var contentOffset = tableView.contentOffset
      contentOffset.y += offset
      
      tableView.setContentOffset(contentOffset, animated: true)
    }
  }
  
  func changeScrollViewOffsetForKeyboard(_ offset: CGFloat) {
    
    if let scrollView = VUCommentsBuilderModel.vScrollView {
      
      var contentOffset = scrollView.contentOffset
      contentOffset.y += offset
      
      scrollView.setContentOffset(contentOffset, animated: true)
    }
  }
  
  
  // MARK: - Supporting methods
  private func registerCellsFromNib() {
    
    if let tableView = tableView {
      
      let nibAdvertising = UINib(nibName: "VUAdvertisingCell",
                                 bundle: Bundle(for: VUCommentsVC.self))
      tableView.register(nibAdvertising,
                         forCellReuseIdentifier: VUIdentifiersUI.VUAdvertisingCell)
      
      let nibEmojiVoting = UINib(nibName: "VUEmojiVotingCell",
                                 bundle: Bundle(for: VUCommentsVC.self))
      tableView.register(nibEmojiVoting,
                         forCellReuseIdentifier: VUIdentifiersUI.VUEmojiVotingCell)
      
      let nibNewComment = UINib(nibName: "VUNewCommentCell",
                                bundle: Bundle(for: VUCommentsVC.self))
      tableView.register(nibNewComment,
                         forCellReuseIdentifier: VUIdentifiersUI.VUNewCommentCell)
      
      let nibComment = UINib(nibName: "VUCommentCell",
                             bundle: Bundle(for: VUCommentsVC.self))
      tableView.register(nibComment,
                         forCellReuseIdentifier: VUIdentifiersUI.VUCommentCell)
      
      let nibLoginForm = UINib(nibName: "VULoginFormCell",
                               bundle: Bundle(for: VUCommentsVC.self))
      tableView.register(nibLoginForm,
                         forCellReuseIdentifier: VUIdentifiersUI.VULoginFormCell)
      
      let nibLoadMore = UINib(nibName: "VULoadMoreCell",
                              bundle: Bundle(for: VUCommentsVC.self))
      tableView.register(nibLoadMore,
                         forCellReuseIdentifier: VUIdentifiersUI.VULoadMoreCell)
      
      let nibTopArticle = UINib(nibName: "VUTopArticleCell",
                                bundle: Bundle(for: VUCommentsVC.self))
      tableView.register(nibTopArticle,
                         forCellReuseIdentifier: VUIdentifiersUI.VUTopArticleCell)
    }
  }
  
  
  // MARK: Design and colors
  private func addObserverForNewDesignNotification() {
    
    NotificationCenter.default.addObserver(forName: VUGlobals.nSetNewDesign, object: nil,  queue: nil) { [weak self] (notification) in
      
      guard let exSelf = self else {
        return
      }
      
      exSelf.setTableViewDesign()
    }
  }
  
  func setTableViewDesign() {
    
    guard let tableView = tableView,
      let mainView = view else {
        return
    }
    
    switch VUDesignHUB.colorsType {
  
    case .dayColors:
      
      mainView.backgroundColor = VUDesignHUB.general.backgroundColor
      tableView.backgroundColor = VUDesignHUB.general.backgroundColor
      tableView.separatorColor = VUDesignHUB.general.separatorColor

    case .nightColors:
      
      mainView.backgroundColor = VUDesignHUB.generalNight.backgroundColor
      tableView.backgroundColor = VUDesignHUB.generalNight.backgroundColor
      tableView.separatorColor = VUDesignHUB.generalNight.separatorColor
    }

    tableView.estimatedRowHeight = 180
  }
  
}


// MARK: - UITableViewDataSource
extension VUCommentsVC: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return VUModelsFactory.modelsArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let model = VUModelsFactory.modelsArray[indexPath.row]
    
    switch model {
     
    // TODO: • Advertising Cell
    case is VUAdvertisingModel:
      
      let cell = tableView.dequeueReusableCell(withIdentifier: VUIdentifiersUI.VUAdvertisingCell) as? VUAdvertisingCell ?? VUAdvertisingCell()
      
      return cell
      
    // TODO: • Emoji Voting Cell
    case is VUEmojiVotingModel:
      
      let emojiVotingModel = model as! VUEmojiVotingModel
      
      let cell = tableView.dequeueReusableCell(withIdentifier: VUIdentifiersUI.VUEmojiVotingCell) as? VUEmojiVotingCell ?? VUEmojiVotingCell()
      
      cell.delegate = self
      cell.setInfo(emojiVotingModel)
      
      return cell
     
    // TODO: • New Comment Cell
    case is VUNewCommentModel:
      
      let cell = tableView.dequeueReusableCell(withIdentifier: VUIdentifiersUI.VUNewCommentCell) as? VUNewCommentCell ?? VUNewCommentCell()
      
      cell.delegate = self
      
      cell.setParameters(isHeader: true,
                         isLogened: VUCurrentUser.isUserLogined,
                         isClearComment: false,
                         name: VUCurrentUser.name,
                         totalCout: VUGlobals.totalCommentsCount)
      
      return cell
     
    // TODO: • New Reply Cell
    case is VUNewReplyModel:
      
      let cell = tableView.dequeueReusableCell(withIdentifier: VUIdentifiersUI.VUNewCommentCell) as? VUNewCommentCell ?? VUNewCommentCell()
      
      cell.delegate = self
      
      cell.setParameters(isHeader: false,
                         isLogened: VUCurrentUser.isUserLogined,
                         isClearComment: true,
                         name: VUCurrentUser.name,
                         totalCout: VUGlobals.totalCommentsCount)
      
      return cell
      
    // TODO: • Comment Cell
    case is VUCommentModel:
     
      let commentModel = model as! VUCommentModel
      
      let cell = tableView.dequeueReusableCell(withIdentifier: VUIdentifiersUI.VUCommentCell) as? VUCommentCell ?? VUCommentCell()
      
      cell.delegate = self
      cell.commentID = commentModel.commentID
      
      cell.setCommentInfo(userName: commentModel.userName,
                          userPhotoURL: commentModel.userPhotoURL,
                          userRating: commentModel.userRating,
                          comment: commentModel.comment,
                          commentTime: commentModel.commentDate,
                          upVotes: commentModel.upVotes,
                          downVotes: commentModel.downVotes,
                          repliesCount: commentModel.repliesCount,
                          isRepliesHiden: commentModel.isRepliesHiden,
                          isReported: commentModel.isReported,
                          votedType:  commentModel.votedType,
                          nestingLevel: commentModel.nestingLevel)
      return cell
    
    // TODO: • Login Cell
    case is VULoginFormModel:
      
      let cell = tableView.dequeueReusableCell(withIdentifier: VUIdentifiersUI.VULoginFormCell) as? VULoginFormCell ?? VULoginFormCell()
      
      cell.delegate = self
      
      return cell
      
    // TODO: • Load More Cell
    case is VULoadMoreModel:
     
      let loadMoreModel = model as! VULoadMoreModel
    
      let cell = tableView.dequeueReusableCell(withIdentifier: VUIdentifiersUI.VULoadMoreCell) as? VULoadMoreCell ?? VULoadMoreCell()

      cell.delegate = self
      
      cell.setLoadMoreButtonVisible(loadMoreModel.isAbleLoadComments,
                                    loadedCount: VUGlobals.loadedCommetsCount,
                                    totalCount: VUGlobals.totalCommentsCount)
      
      checkRowUpdateHeight(indexPath)
      
      return cell
      
    // TODO: • Top Article Cell
    case is VUTopArticleModel:
      
      let topArticleModel = model as! VUTopArticleModel
      
      let cell = tableView.dequeueReusableCell(withIdentifier: VUIdentifiersUI.VUTopArticleCell) as? VUTopArticleCell ?? VUTopArticleCell()

      cell.delegate = self
      
      cell.setArticle(title: topArticleModel.articleTitle,
                      date: topArticleModel.articleDate,
                      commentsCount: topArticleModel.commentsCount,
                      imageURL: topArticleModel.imageURL)
    
      checkRowUpdateHeight(indexPath)
      
      return cell
     
    // Default
    default:
      
      let cell = tableView.dequeueReusableCell(withIdentifier: VUIdentifiersUI.VUCommentCell) as? VUCommentCell ?? VUCommentCell()
   
      return cell
    }
  }
  
  private func checkRowUpdateHeight(_ indexPath: IndexPath) {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      
      if indexPath.row == VUModelsFactory.modelsArray.count - 1 {
        VUCommentsBuilderModel.updateTableViewHeight()
      }
    }
  }
  
}


// MARK: - UITableViewDelegate
extension VUCommentsVC: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
}


// MARK: - UIWebViewDelegate
extension VUCommentsVC: UIWebViewDelegate {
  
  func webViewDidFinishLoad(_ webView: UIWebView) {
    
    if let webView = VUCommentsBuilderModel.vWebView,
      let heightConstraint = VUCommentsBuilderModel.vWebViewHeightConstraint {
      
      VUCommentsBuilder.updateWebViewHeight(webView: webView,
                                            heightConstraint: heightConstraint)
    }
    
    VUCommentsBuilderModel.updateTableViewHeight()
    activityIndicator.stopAnimating()
  }
  
  func webViewDidStartLoad(_ webView: UIWebView) {
    
    activityIndicator.startAnimating()
    activityIndicator.color = UIColor.darkGray
    activityIndicator.frame = CGRect(x: (UIScreen.main.bounds.width - 100) / 2, y: 100, width: 100, height: 100)
    
    if let webView = VUCommentsBuilderModel.vWebView {
      
      webView.addSubview(activityIndicator)
      webView.bringSubview(toFront: activityIndicator)
    }
  }
  
}


// MARK: - MFMailComposeViewControllerDelegate
extension VUCommentsVC: MFMailComposeViewControllerDelegate {
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    
    switch result {
      
    case MFMailComposeResult.cancelled:
      vuuklePrint("⚠️ BUG Report - Canceled.")
      
    case MFMailComposeResult.saved:
      vuuklePrint("💾 BUG Report - Saved.")
      
    case MFMailComposeResult.sent:
      VUAlertsHub.showHUD("Thank you, bug report",
                          image: .hudSuccessIcon,
                          details: "has been sent 📮")

    
    default: break
    }
    controller.dismiss(animated: true, completion:nil)
  }
}


// MARK: - VUEmojiVotingCellDelegate
extension VUCommentsVC: VUEmojiVotingCellDelegate {
 
  func didSelectEmoji(_ emojiVotingCell: VUEmojiVotingCell,
                      atIndex: Int,
                      emojiModel: VUEmojiModel) {
    
    VUModelsFactory.voteForEmoji(atIndex,
                                 emojiVotingCell: emojiVotingCell)
  }
  
}


// MARK: - VUNewCommentCellDelegate
extension VUCommentsVC: VUNewCommentCellDelegate {

  func keyboardWillShowFor(_ newCommentCell: VUNewCommentCell,
                           inputType: VUTextInputType,
                           keyboardHeight: CGFloat) {
    switch inputType {
    
    case .commentTextView:
      if let textView = newCommentCell.commentTextView {
        changeViewOffsetForKeyboard(textView, keyboardHeight: keyboardHeight)
      }
  
    case .nameTextField:
      if let textField = newCommentCell.nameTextField {
        changeFieldOffsetForKeyboard(textField, keyboardHeight: keyboardHeight)
      }
      
    case .emailTextField:
      if let textField = newCommentCell.emailTextField {
        changeFieldOffsetForKeyboard(textField, keyboardHeight: keyboardHeight)
      }
      
    default: break
    }
  }
  
  // TODO: • Post Button action
  func postButtonPressed(_ newCommentCell: VUNewCommentCell,
                         commentText: String,
                         userName: String?,
                         userEmail: String?,
                         postButton: UIButton) {
    
    var comment = commentText
    
    if let indexPath = self.tableView.indexPath(for: newCommentCell) {
      
      if VUCurrentUser.isUserLogined {
        
        if VUParametersChecker.checkComment(&comment) {
            
            guard let emojiComment = comment.encodeEmojis else {
                return
            }
            
          VUModelsFactory.postNewComment(comment: emojiComment,
                                         index: indexPath.row,
                                         newCommentCell: newCommentCell)
        }
      } else {
        
        if var name = userName,
          var email = userEmail,
          VUParametersChecker.checkUser(name: &name, email: &email) {
          
          if VUParametersChecker.checkComment(&comment) {
            
            guard let emojiComment = comment.encodeEmojis else {
                return
            }
            
            VUModelsFactory.loginAndPostComment(emojiComment,
                                                name: name,
                                                email: email,
                                                index: indexPath.row,
                                                cell: newCommentCell)
          }
        }
      }
    }
  }
    
  // TODO: • Log Out action
  func logOutButtonPressed(_ newCommentCell: VUNewCommentCell, logOutButton: UIButton) {
    
    VUModelsFactory.logoutUser(newCommentCell)
  }
}


// MARK: - VUCommentCellDelegate
extension VUCommentsVC: VUCommentCellDelegate {

  // TODO: • Up/Down Vote actions
  func upVoteButtonPressed(_ commentCell: VUCommentCell, button: UIButton) {
    
    if let indexPath = self.tableView.indexPath(for: commentCell) {
     
      if VUCurrentUser.isUserLogined {
        
        VUModelsFactory.voteForComment(indexPath.row,
                                       voteType: .upVote,
                                       commentCell: commentCell)
      } else {
        VUModelsFactory.showHideLoginForm(indexPath.row,
                                          commentCell: commentCell,
                                          actionType: .upVote)
        
      }
    }
  }
  
  func downVoteButtonPressed(_ commentCell: VUCommentCell, button: UIButton) {
    
    if let indexPath = self.tableView.indexPath(for: commentCell) {
      
      if VUCurrentUser.isUserLogined {
        
        VUModelsFactory.voteForComment(indexPath.row,
                                       voteType: .downVote,
                                       commentCell: commentCell)
      } else {
        VUModelsFactory.showHideLoginForm(indexPath.row,
                                          commentCell: commentCell,
                                          actionType: .downVote)
      }
    }
  }
  
  
  // TODO: • Share/Report actions
  func shareButtonPressed(_ commentCell: VUCommentCell, button: UIButton) {
    
    if let lName = commentCell.userNameLabel.text,
      let lComment = commentCell.commentLabel.text {
     
      let shareVC = VUShareConfigurator.configure(name: lName,
                                                  comment: lComment,
                                                  url: VUGlobals.requestParametes.articleURL)
      
      if (UIDevice.current.userInterfaceIdiom == .phone) {
        VUShareConfigurator.presentShareKitAsPhone(shareVC, cell: commentCell)
        
      } else if (UIDevice.current.userInterfaceIdiom == .pad) {
        VUShareConfigurator.presentShareKitAsPad(shareVC, button: button, cell: commentCell)
      }
    }
  }
  
  func reportButtonPressed(_ commentCell: VUCommentCell, button: UIButton) {
    
    if let indexPath = self.tableView.indexPath(for: commentCell) {
      
      if VUCurrentUser.isUserLogined {
        
        VUModelsFactory.reportComment(indexPath.row,
                                      commentCell: commentCell)
      } else {
        VUModelsFactory.showHideLoginForm(indexPath.row,
                                          commentCell: commentCell,
                                          actionType: .reportComment)
      }
    }
  }
  
  
  // TODO: • Show/Hide replies action
  func showButtonPressed(_ commentCell: VUCommentCell, button: UIButton) {
  
    if let indexPath = self.tableView.indexPath(for: commentCell) {
      
      VUModelsFactory.showHideReplies(indexPath.row,
                                      cell: commentCell)
    }
  }
  
  
  // TODO: • New Reply action
  func replyButtonPressed(_ commentCell: VUCommentCell, button: UIButton) {
    
    if let indexPath = self.tableView.indexPath(for: commentCell) {
      
      VUModelsFactory.showHideReplyForm(indexPath.row,
                                        commentCell: commentCell)
    }
  }
  
}


// MARK: - VULoginFormCellDelegate
extension VUCommentsVC: VULoginFormCellDelegate {

  func keyboardWillShowFor(_ loginFormCell: VULoginFormCell,
                           inputType: VUTextInputType,
                           keyboardHeight: CGFloat) {
    switch inputType {

    case .nameTextField:
      
      if let textField = loginFormCell.nameTextField {
        changeFieldOffsetForKeyboard(textField, keyboardHeight: keyboardHeight)
      }
      
    case .emailTextField:
      
      if let textField = loginFormCell.emailTextField {
        changeFieldOffsetForKeyboard(textField, keyboardHeight: keyboardHeight)
      }
      
    default: break
    }
  }
  
  // TODO: • Log in action
  func loginButtonPressed(_ newCommentCell: VULoginFormCell,
                          userName: String,
                          userEmail: String,
                          postButton: UIButton) {
   
    var name = userName, email = userEmail
    
    if VUParametersChecker.checkUser(name: &name,
                                     email: &email) {
  
      VUModelsFactory.loginUser(name: name,
                                email: email)
    }
  }
  
}


// MARK: - VUTopArticleCellDelegate
extension VUCommentsVC: VUTopArticleCellDelegate {
  
  func openTopArticle(_ topArticleCell: VUTopArticleCell, button: UIButton) {
    
    if let indexPath = tableView.indexPath(for: topArticleCell) {
      VUModelsFactory.openTopArticle(indexPath.row)
    }
  }
  
}


// MARK: - VULoadMoreCellDelegate
extension VUCommentsVC: VULoadMoreCellDelegate {

  func loadMoreButtonPressed(_ cell: VULoadMoreCell, button: UIButton) {
    
    VUModelsFactory.loadMoreComments(cell)
  }
  
  func openVuukleButtonPressed(_ cell: VULoadMoreCell, button: UIButton) {
    
  }
  
}
