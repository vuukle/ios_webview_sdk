//
//  VUCommentCell.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit
import NSDate_TimeAgo


// MARK: - VUCommentCellDelegate
protocol VUCommentCellDelegate {
  
  func upVoteButtonPressed(_ commentCell: VUCommentCell, button: UIButton)
  func downVoteButtonPressed(_ commentCell: VUCommentCell, button: UIButton)
  
  func shareButtonPressed(_ commentCell: VUCommentCell, button: UIButton)
  func reportButtonPressed(_ commentCell: VUCommentCell, button: UIButton)
  
  func showButtonPressed(_ commentCell: VUCommentCell, button: UIButton)
  func replyButtonPressed(_ commentCell: VUCommentCell, button: UIButton)
}


// MARK: - VUCommentCell
class VUCommentCell: UITableViewCell {
  
  var delegate: VUCommentCellDelegate?
  var commentID: String?
  var voteType: VUCommentVoteType = .none
  
  
  // MARK: - Code changeable constraints
  @IBOutlet weak var photoWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var photoContentViewWidthConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var commentContentViewLeftConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var votingContentViewWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var repliesContentViewWidthConstraint: NSLayoutConstraint!
  
  
  // MARK: - @IBOutlets
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userRatingLabel: UILabel!
  @IBOutlet weak var userPhotoImageView: UIImageView!
  @IBOutlet weak var userPhotoConentView: UIView!
  @IBOutlet weak var userInitialsLabel: UILabel!
  @IBOutlet weak var userPhotoDownloadingIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var reportButton: UIButton!
  @IBOutlet weak var shareButton: UIButton!
  
  @IBOutlet weak var commentLabel: UILabel!
  @IBOutlet weak var commentTimeLabel: UILabel!
  @IBOutlet weak var commentRateLabel: UILabel!
  
  @IBOutlet weak var upVoteButton: UIButton!
  @IBOutlet weak var downVoteButton: UIButton!
  
  @IBOutlet weak var replyButton: UIButton!
  @IBOutlet weak var showButton: UIButton!
  
  @IBOutlet weak var repliesContentView: UIView!
  @IBOutlet weak var repliesCountLabel: UILabel!
  
  @IBOutlet weak var cellActivityIndicator: UIActivityIndicatorView!
  
  
  // MARK: - Cell lifecyle
  override func awakeFromNib() {
    super.awakeFromNib()
    
    if let indicator = cellActivityIndicator {
      indicator.isHidden = true
    }
    
    setCommentCellDesign()
    
    addObserverForShowFlags()
    addObserverForRemoveFlags()
    addObserverForNewDesignNotification()
  }
  
  override func prepareForReuse() {
    hideProgress()
    
    if let photoImageView = userPhotoImageView,
      let indicator = cellActivityIndicator {
      
      photoImageView.image = nil
      indicator.isHidden = true
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  
  // MARK: - Public methods
  func setCommentInfo(userName: String,
                      userPhotoURL: String?,
                      userRating: Int,
                      comment: String,
                      commentTime: NSDate,
                      upVotes: Int,
                      downVotes: Int,
                      repliesCount: Int,
                      isRepliesHiden: Bool,
                      isReported: Bool,
                      votedType: VUCommentVoteType,
                      nestingLevel: Int) {
    
    setCommentInfo(userName: userName, comment: comment, commentTime: commentTime)
    setCommentRating(upVotes: upVotes, downVotes: downVotes)
    
    setNestingLevel(nestingLevel)
    
    setUserPhotoFromURL(userPhotoURL)
    setUserRating(userRating)
    
    setRepliesCount(repliesCount)
    setShowButtonTitleHiden(isRepliesHiden)
    setReported(isReported)
    setVotedType(votedType)
  }
  
  func setShowButtonTitleHiden(_ isHiden: Bool) {
    
    if let showButton = showButton {
      
      if isHiden {
        showButton.setTitle("Show", for: .normal)
        showButton.setTitle("Show", for: .highlighted)
        showButton.setTitle("Show", for: .selected)
      } else {
        showButton.setTitle("Hide", for: .normal)
        showButton.setTitle("Hide", for: .highlighted)
        showButton.setTitle("Hide", for: .selected)
      }
    }
  }
  
  
  // MARK: - Button actions
  @IBAction func upVoteButtonAction(_ sender: UIButton) {
    sender.showAnimatedTap(0.8, isShowSelection: true)
    
    delegate?.upVoteButtonPressed(self, button: sender)
  }
  
  @IBAction func downVoteButtonAction(_ sender: UIButton) {
    sender.showAnimatedTap(0.8, isShowSelection: true)
    
    delegate?.downVoteButtonPressed(self, button: sender)
  }
  
  @IBAction func reportButtonAction(_ sender: UIButton) {
    sender.showAnimatedTap(0.8, isShowSelection: true)
    
    delegate?.reportButtonPressed(self, button: sender)
  }
  
  @IBAction func shareButtonAction(_ sender: UIButton) {
    sender.showAnimatedTap(0.8, isShowSelection: true)
    
    if let delegate = delegate {
      showProgress()
      delegate.shareButtonPressed(self, button: sender)
    }
  }
  
  @IBAction func showButtonAction(_ sender: UIButton) {
    sender.showAnimatedTap(0.84)
    
    delegate?.showButtonPressed(self, button: sender)
  }
  
  @IBAction func replyButtonAction(_ sender: UIButton) {
    sender.showAnimatedTap(0.84)
    
    delegate?.replyButtonPressed(self, button: sender)
  }
  
  
  // MARK: - Showing of progress
  func showProgress() {
    
    self.contentView.isUserInteractionEnabled = false
    self.alpha = 0.4
    
    if let indicator = cellActivityIndicator {
      
      indicator.isHidden = false
      indicator.startAnimating()
    }
  }
  
  func hideProgress() {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
      
      guard let exSelf = self else {
        return
      }
      
      exSelf.contentView.isUserInteractionEnabled = true
      exSelf.alpha = 1
      
      if let indicator = exSelf.cellActivityIndicator {
        
        indicator.isHidden = true
        indicator.stopAnimating()
      }
    }
  }
  
  
  // MARK: - Private supporting methods
  private func setCommentInfo(userName: String, comment: String, commentTime: NSDate) {
    
    if let nameLabel = userNameLabel,
      let commentLabel = commentLabel,
      let commentTimeLabel = commentTimeLabel {
      
      nameLabel.text = userName
      commentLabel.text = comment
      commentTimeLabel.text = commentTime.timeAgo()
    }
  }
  
  private func setUserRating(_ rating: Int) {
    
    setNewDynamicWidthFor(rating, contentViewWidth: 52,
                          label: userRatingLabel,
                          contnetViewConstraint: photoContentViewWidthConstraint,
                          widhtAdjustment: 10.0)
  }
  
  private func setCommentRating(upVotes: Int, downVotes: Int) {
    
    let newRating = upVotes - downVotes
    
    switch VUDesignHUB.commentCell.commentVotingStyle {
    
    case .fingerIcons:
      if newRating < 0 {
        
        setNewDynamicWidthFor(newRating, contentViewWidth: 82,
                              label: commentRateLabel,
                              contnetViewConstraint: votingContentViewWidthConstraint,
                              widhtAdjustment: 18.0)
      } else {
        
        setNewDynamicWidthFor(newRating, contentViewWidth: 82,
                              label: commentRateLabel,
                              contnetViewConstraint: votingContentViewWidthConstraint,
                              widhtAdjustment: 12.0)
      }

    case .arrowIcons:
      if newRating < 0 {
        
        setNewDynamicWidthFor(newRating, contentViewWidth: 82,
                              label: commentRateLabel,
                              contnetViewConstraint: votingContentViewWidthConstraint,
                              widhtAdjustment: 14.0)
      } else {
        
        setNewDynamicWidthFor(newRating, contentViewWidth: 82,
                              label: commentRateLabel,
                              contnetViewConstraint: votingContentViewWidthConstraint,
                              widhtAdjustment: 10.0)
      }
    }
    
    setTextColorForRating(newRating)
  }
  
  private func setRepliesCount(_ value: Int) {
    
    if let lRepliesView = repliesContentView, let lConstraint = repliesContentViewWidthConstraint {
      
      if value > 0 {
        
        lRepliesView.isHidden = false
        
        setNewDynamicWidthFor(value, contentViewWidth: 80,
                              label: repliesCountLabel,
                              contnetViewConstraint: repliesContentViewWidthConstraint,
                              widhtAdjustment: 10)
        
      } else if value == 0 {
        
        lRepliesView.isHidden = true
        lConstraint.constant = 0
      }
    }
  }
  
  
  private func setNewDynamicWidthFor(_ newValue: Int,
                                     contentViewWidth: CGFloat,
                                     label: UILabel?,
                                     contnetViewConstraint: NSLayoutConstraint?,
                                     widhtAdjustment: CGFloat) {
    
    var maxValue: Int = 99999
    var maxWidth: CGFloat = 39.0
    
    if UIScreen.main.bounds.width >= 375 && UIDevice.current.userInterfaceIdiom == .phone {
      maxValue = 999999
      maxWidth = 50.0
    }
    
    if let label = label, let contentConstraint = contnetViewConstraint {
      
      if newValue <= maxValue && newValue >= -maxValue {
        
        label.text = "\(newValue)"
        
        let newWidth = (contentViewWidth - widhtAdjustment) + CGFloat(8 * "\(newValue)".characters.count)
        
        contentConstraint.constant = newWidth
        
      } else {
        contentConstraint.constant = maxWidth
      }
    }
  }
  
  private func setTextColorForRating(_ rating: Int) {
    
    switch VUDesignHUB.colorsType {
    
    case .dayColors:
      if let label = commentRateLabel {
        
        if rating > 0 {
          label.textColor = VUDesignHUB.commentCell.totalVotesGreaterZeroTextColor
          
        } else if rating < 0 {
          label.textColor = VUDesignHUB.commentCell.totalVotesLessZeroTextColor
          
        } else {
          label.textColor = VUDesignHUB.commentCell.totalVotesZeroTextColor
        }
      }
      
    case .nightColors:
      if let label = commentRateLabel {
        
        if rating > 0 {
          label.textColor = VUDesignHUB.commentCellNight.totalVotesGreaterZeroTextColor
          
        } else if rating < 0 {
          label.textColor = VUDesignHUB.commentCellNight.totalVotesLessZeroTextColor
          
        } else {
          label.textColor = VUDesignHUB.commentCellNight.totalVotesZeroTextColor
        }
      }
    }
  }

  /* Setting user photo or intials if url nil or request failed */
  private func setUserPhotoFromURL(_ photoURL: String?) {
    
    if let userPhotoURL = photoURL {
 
      if let initialsLabel = userInitialsLabel {
        initialsLabel.text = ""
      }
        
      if let indicator = userPhotoDownloadingIndicator {
        indicator.startAnimating()
      }
      
      downloadAndSetUserPhoto(userPhotoURL)
      
    } else {
      
      if let initialsLabel = userInitialsLabel,
        let userName = userNameLabel.text {
        
        if let userPhotoImageView = userPhotoImageView {
          userPhotoImageView.image = nil
        }
        
        let nameInitials = userName.getInitials()
        
        initialsLabel.isHidden = false
        initialsLabel.text = nameInitials
        
        if nameInitials.characters.count == 1 {
          initialsLabel.font = initialsLabel.font.withSize(20)
          
        } else {
          initialsLabel.font = initialsLabel.font.withSize(18)
        }
      }
    }
  }
  
  private func downloadAndSetUserPhoto(_ url: String) {
    
    VUServerManager.downloadImage(url) { [weak self] responceImage, requestError in
      
      guard let exSelf = self else {
        return
      }
      
      exSelf.userPhotoDownloadingIndicator.stopAnimating()
      
      if let userImage = responceImage,
        let userInitialsLabel = exSelf.userInitialsLabel,
        let photoImageView = exSelf.userPhotoImageView {
        
        userInitialsLabel.isHidden = true
        
        if let resizedUserImage = userImage.resize(newWidth: 48 * UIScreen.main.scale) {
          photoImageView.image = resizedUserImage
          
        } else {
          photoImageView.image = userImage
        }
      } else {
        
        if let initialsLabel = exSelf.userInitialsLabel, let userName = exSelf.userNameLabel.text {
          
          let nameInitials = userName.getInitials()

          initialsLabel.isHidden = false
          initialsLabel.text = nameInitials
          
          if nameInitials.characters.count == 1 {
            initialsLabel.font = initialsLabel.font.withSize(20)
            
          } else {
            initialsLabel.font = initialsLabel.font.withSize(18)
          }
        }
      }
    }
  }
  
  /* Setting of nesting level */
  private func setNestingLevel(_ level: Int) {
    
    switch UIDevice.current.userInterfaceIdiom {
      
    case .phone:
      setNestingLevelForPhone(level)
      
    case .pad:
      setNestingLevelForPad(level)
      
    default: break
    }
  }
  
  private func setNestingLevelForPhone(_ level: Int) {
    
    if let constraint = commentContentViewLeftConstraint {
      
      if level == 0 {
        constraint.constant = 8.0
        
      } else if level > 0 && level < 4 {
        constraint.constant = 14.0 + CGFloat(level * 14)
        
      } else {
        constraint.constant = 56
      }
    }
  }
  
  private func setNestingLevelForPad(_ level: Int) {
    
    if let constraint = commentContentViewLeftConstraint {
      
      if level == 0 {
        constraint.constant = 8.0
        
      } else if level > 0 && level < 6  {
        constraint.constant = 22.0 + CGFloat(level * 22)
        
      } else {
        constraint.constant = 132
      }
    }
  }
  
  private func setReported(_ isReprted: Bool) {
    
    if let reportButton = reportButton {
      
      if isReprted {
        reportButton.setImageTint(VUDesignHUB.commentCell.reportButtonReportedColor)
        
      } else {
        reportButton.setImageTint(VUDesignHUB.commentCell.reportButtonDefaultColor)
      }
    }
  }
  
  private func setVotedType(_ type: VUCommentVoteType) {
  
    voteType = type
    
    
    switch VUDesignHUB.colorsType {
   
    case .dayColors:
      
      if let upVoteButton = upVoteButton,
        let downVoteButton = downVoteButton {
        
        switch type {
          
        case .none:
          upVoteButton.setImageTint(VUDesignHUB.commentCell.upVoteButtonColor)
          downVoteButton.setImageTint(VUDesignHUB.commentCell.downVoteButtonColor)
          
        case .upVote:
          upVoteButton.setImageTint(VUDesignHUB.commentCell.selectedButtonColor)
          downVoteButton.setImageTint(VUDesignHUB.commentCell.downVoteButtonColor)
          
        case .downVote:
          upVoteButton.setImageTint(VUDesignHUB.commentCell.upVoteButtonColor)
          downVoteButton.setImageTint(VUDesignHUB.commentCell.selectedButtonColor)
        }
      }
      
    case .nightColors:
      
      if let upVoteButton = upVoteButton,
        let downVoteButton = downVoteButton {
        
        switch type {
          
        case .none:
          upVoteButton.setImageTint(VUDesignHUB.commentCellNight.upVoteButtonColor)
          downVoteButton.setImageTint(VUDesignHUB.commentCellNight.downVoteButtonColor)
          
        case .upVote:
          upVoteButton.setImageTint(VUDesignHUB.commentCellNight.selectedButtonColor)
          downVoteButton.setImageTint(VUDesignHUB.commentCellNight.downVoteButtonColor)
          
        case .downVote:
          upVoteButton.setImageTint(VUDesignHUB.commentCellNight.upVoteButtonColor)
          downVoteButton.setImageTint(VUDesignHUB.commentCellNight.selectedButtonColor)
        }
      }
    }
  }
  
  
  // MARK: - Setting of design and colors
  private func setCommentCellDesign() {
    
    guard let userInitialsLabel = userInitialsLabel,
      let userDownloadingIndicator = userPhotoDownloadingIndicator,
      let userNameLabel = userNameLabel,
      let userRatingLabel  = userRatingLabel,
      let commentTimeLabel = commentTimeLabel,
      let commentLabel = commentLabel,
      let shareButton = shareButton,
      let reportButton = reportButton,
      let upVoteButton = upVoteButton,
      let downVoteButton = downVoteButton,
      let commentRateLabel = commentRateLabel,
      let replyButton = replyButton,
      let showButton = showButton,
      let repliesCountLabel = repliesCountLabel,
      let cellActivityIndicator = cellActivityIndicator else {
        return
    }
    
    switch VUDesignHUB.colorsType {
      
    case .dayColors:
      
      userInitialsLabel.backgroundColor = VUDesignHUB.commentCell.userAvatarBackgroundColor
      userInitialsLabel.textColor = VUDesignHUB.commentCell.userAvatarInitialsColor
      userDownloadingIndicator.color = VUDesignHUB.commentCell.usetAvatarProgressIndicatorColor
      
      userRatingLabel.backgroundColor = VUDesignHUB.commentCell.userRatingBackgroundColor
      userRatingLabel.textColor = VUDesignHUB.commentCell.userRatingTextColor
      userNameLabel.textColor = VUDesignHUB.commentCell.userNameTextColor
      
      commentTimeLabel.textColor = VUDesignHUB.commentCell.commentTimeTextColor
      commentLabel.textColor = VUDesignHUB.commentCell.commentTextColor
      
      shareButton.setImageTint(VUDesignHUB.commentCell.shareButtonColor)
      reportButton.setImageTint(VUDesignHUB.commentCell.reportButtonDefaultColor)
      upVoteButton.setImageTint(VUDesignHUB.commentCell.upVoteButtonColor)
      downVoteButton.setImageTint(VUDesignHUB.commentCell.downVoteButtonColor)
      
      replyButton.setTitleColor(VUDesignHUB.commentCell.replyButtonColor,
                                for: .normal)
      replyButton.setTitleColor(VUDesignHUB.commentCell.replyButtonColor,
                                for: .highlighted)
      replyButton.setTitleColor(VUDesignHUB.commentCell.replyButtonColor,
                                for: .selected)
      
      showButton.setTitleColor(VUDesignHUB.commentCell.replyButtonColor,
                               for: .normal)
      showButton.setTitleColor(VUDesignHUB.commentCell.replyButtonColor,
                               for: .highlighted)
      showButton.setTitleColor(VUDesignHUB.commentCell.replyButtonColor,
                               for: .selected)
      
      repliesCountLabel.backgroundColor = VUDesignHUB.commentCell.repliesCountBackgroundColor
      repliesCountLabel.textColor = VUDesignHUB.commentCell.repliesCountTextColor
      
      if let text = commentRateLabel.text,
        let totalVotes = Int(text) {
        
        setTextColorForRating(totalVotes)
      }
      
      cellActivityIndicator.color = VUDesignHUB.general.progressIndicatorColor
      setVotedType(voteType)
      
    case .nightColors:
      
      userInitialsLabel.backgroundColor = VUDesignHUB.commentCellNight.userAvatarBackgroundColor
      userInitialsLabel.textColor = VUDesignHUB.commentCellNight.userAvatarInitialsColor
      userDownloadingIndicator.color = VUDesignHUB.commentCellNight.usetAvatarProgressIndicatorColor
      
      userRatingLabel.backgroundColor = VUDesignHUB.commentCellNight.userRatingBackgroundColor
      userRatingLabel.textColor = VUDesignHUB.commentCellNight.userRatingTextColor
      userNameLabel.textColor = VUDesignHUB.commentCellNight.userNameTextColor
      
      commentTimeLabel.textColor = VUDesignHUB.commentCellNight.commentTimeTextColor
      commentLabel.textColor = VUDesignHUB.commentCellNight.commentTextColor
      
      shareButton.setImageTint(VUDesignHUB.commentCellNight.shareButtonColor)
      reportButton.setImageTint(VUDesignHUB.commentCellNight.reportButtonDefaultColor)
      upVoteButton.setImageTint(VUDesignHUB.commentCellNight.upVoteButtonColor)
      downVoteButton.setImageTint(VUDesignHUB.commentCellNight.downVoteButtonColor)
      
      replyButton.setTitleColor(VUDesignHUB.commentCellNight.replyButtonColor,
                                for: .normal)
      replyButton.setTitleColor(VUDesignHUB.commentCellNight.replyButtonColor,
                                for: .highlighted)
      replyButton.setTitleColor(VUDesignHUB.commentCellNight.replyButtonColor,
                                for: .selected)
      
      showButton.setTitleColor(VUDesignHUB.commentCellNight.replyButtonColor,
                               for: .normal)
      showButton.setTitleColor(VUDesignHUB.commentCellNight.replyButtonColor,
                               for: .highlighted)
      showButton.setTitleColor(VUDesignHUB.commentCellNight.replyButtonColor,
                               for: .selected)
      
      repliesCountLabel.backgroundColor = VUDesignHUB.commentCellNight.repliesCountBackgroundColor
      repliesCountLabel.textColor = VUDesignHUB.commentCellNight.repliesCountTextColor
      
      if let text = commentRateLabel.text,
        let totalVotes = Int(text) {
        
        setTextColorForRating(totalVotes)
      }
      
      cellActivityIndicator.color = VUDesignHUB.generalNight.progressIndicatorColor
      setVotedType(voteType)
    }
  }
  
  private func setCommentCellVotingStyle() {
    
    if let upVoteButton = upVoteButton, let downVoteButton = downVoteButton {
      
      switch VUDesignHUB.commentCell.commentVotingStyle {
      
      case .fingerIcons:
        
        upVoteButton.setImage(UIImage.init(assetIdentifier: .upVote),
                              for: .normal)
        upVoteButton.setImage(UIImage.init(assetIdentifier: .upVoteSelected),
                              for: .selected)
        upVoteButton.setImage(UIImage.init(assetIdentifier: .upVoteSelected),
                              for: .highlighted)
        
        downVoteButton.setImage(UIImage.init(assetIdentifier: .downVote),
                                for: .normal)
        downVoteButton.setImage(UIImage.init(assetIdentifier: .downVoteSelected),
                                for: .selected)
        downVoteButton.setImage(UIImage.init(assetIdentifier: .downVoteSelected),
                                for: .highlighted)
        
      case .arrowIcons:
        
        upVoteButton.setImage(UIImage.init(assetIdentifier: .upArrow),
                              for: .normal)
        upVoteButton.setImage(UIImage.init(assetIdentifier: .upArrowSelected),
                              for: .selected)
        upVoteButton.setImage(UIImage.init(assetIdentifier: .upArrowSelected),
                              for: .highlighted)
        
        downVoteButton.setImage(UIImage.init(assetIdentifier: .downArrow),
                                for: .normal)
        downVoteButton.setImage(UIImage.init(assetIdentifier: .downArrowSelected),
                                for: .selected)
        downVoteButton.setImage(UIImage.init(assetIdentifier: .downArrowSelected),
                                for: .highlighted)
      }
    }
  }
  
  
  // MARK: - Notifications
  private func addObserverForRemoveFlags() {
    
    NotificationCenter.default.addObserver(forName: VUGlobals.nLogoutRemoveFlags, object: nil, queue: nil) { [weak self] (notification) in
      
      guard let exSelf = self, let reportButton = exSelf.reportButton else {
        return
      }
    
      reportButton.setImageTint(VUDesignHUB.commentCell.reportButtonDefaultColor)
      exSelf.setVotedType(.none)
    }
  }
  
  private func addObserverForShowFlags() {
    
    NotificationCenter.default.addObserver(forName: VUGlobals.nLoginShowFlags,
                                           object: nil,
                                           queue: nil) { [weak self] (notification) in
      
      guard let exSelf = self, let reportButton = exSelf.reportButton else {
        return
      }
      
      if let currentName = VUCurrentUser.name,
        let currentEmail = VUCurrentUser.email,
        let commentID = exSelf.commentID {
        
        let reportedKey = "\(currentName)\(currentEmail)reported\(commentID)"
        
        if UserDefaults.standard.object(forKey: reportedKey) != nil {
          reportButton.setImageTint(UIColor.vuukleRed)
        }
        
        let votedKey = "\(currentName)\(currentEmail)voted\(commentID)"
        
        if let voteTypeString = UserDefaults.standard.object(forKey: votedKey) as? String {
          
          if voteTypeString == "VUUKLE_UP_VOTE" {
            exSelf.setVotedType(.upVote)
          }
          
          if voteTypeString == "VUUKLE_DOWN_VOTE" {
            exSelf.setVotedType(.downVote)
          }
        }
        
      }
    }
  }
  
  private func addObserverForNewDesignNotification() {
    
    NotificationCenter.default.addObserver(forName: VUGlobals.nSetNewDesign, object: nil,  queue: nil) { [weak self] (notification) in
      
      guard let exSelf = self else {
        return
      }
      
      exSelf.setCommentCellDesign()
    }
  }

}
