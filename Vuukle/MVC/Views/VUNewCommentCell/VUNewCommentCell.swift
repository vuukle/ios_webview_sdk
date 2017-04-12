//
//  VUNewCommentCell.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit

// MARK: - VUNewCommentCellDelegate
protocol VUNewCommentCellDelegate {
  
  func keyboardWillShowFor(_ newCommentCell: VUNewCommentCell,
                           inputType: VUTextInputType,
                           keyboardHeight: CGFloat)
  
  func postButtonPressed(_ newCommentCell: VUNewCommentCell,
                         commentText: String,
                         userName: String?,
                         userEmail: String?,
                         postButton: UIButton)
  
  func logOutButtonPressed(_ newCommentCell: VUNewCommentCell,
                           logOutButton: UIButton)
}


// MARK: - VUNewCommentCell
class VUNewCommentCell: UITableViewCell {
  
  var delegate: VUNewCommentCellDelegate?
  var currentInputType: VUTextInputType = .unknown
  var lastSymbolsCount = 4
  
  // MARK: - NSLayoutConstraints
  @IBOutlet weak var mainContentViewLeftConstraint: NSLayoutConstraint!
  @IBOutlet weak var loginConentViewHeightConstraint: NSLayoutConstraint!
 
  @IBOutlet weak var headerContentViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var headrAndCommentSpacingConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var symbolsCountWidthConstraint: NSLayoutConstraint!
  
  
  // MARK: - @IBOutlets
  @IBOutlet weak var totalCommentsCountLabel: UILabel!

  @IBOutlet weak var commentTextView: UITextView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!

  @IBOutlet weak var welcomeUserLabel: UILabel!
  @IBOutlet weak var symbolsCountLabel: UILabel!
  
  @IBOutlet weak var postButton: UIButton!
  @IBOutlet weak var logOutButton: UIButton!
  @IBOutlet weak var commentPlaceholderButton: UIButton!
  
  @IBOutlet weak var cellActivityIndicator: UIActivityIndicatorView!
  
 
  // MARK: - Content views
  @IBOutlet weak var mainContentView: UIView!
  @IBOutlet weak var headerContentView: UIView!
  
  @IBOutlet weak var welcomeContentView: UIView!
  @IBOutlet weak var loginContentView: UIView!

  
  // MARK: - Lifecycle
  override func awakeFromNib() {
    super.awakeFromNib()
    
    guard let cellActivityIndicator = cellActivityIndicator,
      let commentTextView = commentTextView else {
        return
    }
  
    cellActivityIndicator.isHidden = true
    
    commentTextView.layer.borderWidth = 1.0 / UIScreen.main.scale
    commentTextView.layer.borderColor = UIColor.lightGray.cgColor
    commentTextView.textContainerInset = UIEdgeInsetsMake(6, 2, 28, 2)
    
    setNewCommentCellDesign()
    
    addObserverForKeyboardDidShowNotification()
    addObserverForShowProgressNotification()
    addObserverForHideProgressNotification()
    addObserverForTotatCountUpdate()
    addObserverForNewDesignNotification()
  }
  
  override func prepareForReuse() {
    clearInputFields()
    
    if let textView = commentTextView {
      textView.text = nil
      setSymbolsCount("")
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  
  // MARK: - Public methods
  func setParameters(isHeader: Bool, isLogened: Bool, isClearComment: Bool, name: String?, totalCout: Int) {
    
    setUserName(isLogened, name: name)
    setTotalCount(totalCout)
    setIsHeader(isHeader)
    
    if isLogened {
      UIToolbar.addKeyboardToolbar([commentTextView])
    } else {
      UIToolbar.addKeyboardToolbar([commentTextView, nameTextField, emailTextField])
    }
  }
  
  
  // MARK: - Button actions
  @IBAction func postButtonAction(_ sender: UIButton) {
    sender.showAnimatedTap(0.94)
    
    self.endEditing(true)
    
    if let text = commentTextView.text {
      
      delegate?.postButtonPressed(self, commentText: text,
                                  userName: nameTextField.text,
                                  userEmail: emailTextField.text,
                                  postButton: sender)
    }
  }
  
  @IBAction func logOutButton(_ sender: UIButton) {
    sender.showAnimatedTap(0.88)
    
    if let commentTextView = commentTextView {
      commentTextView.resignFirstResponder()
    }
    
    delegate?.logOutButtonPressed(self, logOutButton: sender)
  }
  
  @IBAction func commentPlaceholderButtonAction(_ sender: UIButton) {
    commentTextView.becomeFirstResponder()
  }
  
  
  // MARK: - Show/Hide show progress
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
  
  
  // MARK: - Show/Hide placeholder with animation
  func hidePlaceholder() {
    
    if let placeholder = commentPlaceholderButton, placeholder.isHidden == false {
      
      UIView.animate(withDuration: 0.4, animations: {
        placeholder.alpha = 0
        
      }, completion: { (isCompleted) in
        
        if isCompleted {
          placeholder.isHidden = true
        }
      })
    }
  }
  
  func showPlaceholder() {
    
    if let placeholder = commentPlaceholderButton, placeholder.isHidden {
      
      placeholder.isHidden = false
      
      UIView.animate(withDuration: 0.4) {
        placeholder.alpha = 1
      }
    }
  }
  
  
  // MARK: - Notifications
  private func addObserverForShowProgressNotification() {
    
    NotificationCenter.default.addObserver(forName: VUGlobals.nNewCommentShowProgress, object: nil, queue: nil) { [weak self] (notification) in
      
      guard let exSelf = self,
        let userInfo = notification.object as? [String: Any],
        let index = userInfo["index"] as? Int,
        let comment = userInfo["comment"] as? String else {
          return
      }
      
      if let indexPath = VUCommentsVC.sharedInstance.tableView.indexPath(for: exSelf), index == indexPath.row, let commentTextView = exSelf.commentTextView {
        
        commentTextView.text = comment
        exSelf.setSymbolsCount(comment)
      }
    
      if VUInternetChecker.isOnline {
        exSelf.showProgress()
      }
    }
  }
  
  private func addObserverForHideProgressNotification() {
    
    NotificationCenter.default.addObserver(forName: VUGlobals.nNewCommentHideProgress, object: nil, queue: nil) { [weak self] (lNotification) in
      
      guard let exSelf = self else {
        return
      }
      
      exSelf.commentTextView.text = nil
      exSelf.setSymbolsCount("")
      exSelf.hideProgress()
    }
  }
  
  private func addObserverForKeyboardDidShowNotification() {
    
    NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidShow, object: nil, queue: nil) { [weak self] notification in
      
      guard let exSelf = self else {
        return
      }
      
      if let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect,
        let activeTextInput = VUGlobals.activeTextInput as? VUNewCommentCell,
        activeTextInput == self {
        
        exSelf.delegate?.keyboardWillShowFor(exSelf,
                                             inputType: exSelf.currentInputType,
                                             keyboardHeight: keyboardSize.height + 44)
      }
    }
  }
  
  private func addObserverForTotatCountUpdate() {
   
    NotificationCenter.default.addObserver(forName: VUGlobals.nTotalCountUpdate, object: nil, queue: nil) { [weak self] (notification) in
      
      guard let exSelf = self, let newCount = notification.object as? Int else {
        return
      }
      exSelf.setTotalCount(newCount)
    }
  }
  
  private func addObserverForNewDesignNotification() {
    
    NotificationCenter.default.addObserver(forName: VUGlobals.nSetNewDesign, object: nil,  queue: nil) { [weak self] (notification) in
                                            
      guard let exSelf = self else {
        return
      }
      
      exSelf.setNewCommentCellDesign()
      exSelf.endEditing(true)
    }
  }
  
  // MARK: - Supporting methods
  func setTotalCount(_ count: Int) {
    
    if let totalLabel = totalCommentsCountLabel {
      totalLabel.text = "Total comments: \(count)"
    }
  }
  
  func setSymbolsCount(_ text: String) {
    
    if let symbolsLabel = symbolsCountLabel {
      
      let newValue = 1000 - text.utf8.count
      
      symbolsLabel.text = "\(newValue)"
      setDynamicWidthForSymbolsCount(newValue)
     
      if newValue == 0 {
        
        symbolsLabel.backgroundColor = VUDesignHUB.newCommentCell.symbolsCountZeroBackgroundColor
        enablePostButton()
      
      } else if newValue < 0 {
        
        symbolsLabel.backgroundColor = VUDesignHUB.newCommentCell.symbolsCountOverLimitBackgroundColor
        disablePostButton()
      
      } else {
        
        symbolsLabel.backgroundColor = VUDesignHUB.newCommentCell.symbolsCountBackgroundColor
        enablePostButton()
      }
      
      if newValue == 1000 {
        showPlaceholder()
      } else {
        hidePlaceholder()
      }
    }
  }
  
  private func setDynamicWidthForSymbolsCount(_ value: Int) {
    
    if let widthConstriant = symbolsCountWidthConstraint { 
      
      let count = 4 - "\(value)".characters.count
      
      if lastSymbolsCount != count {
        
        lastSymbolsCount = count
        widthConstriant.constant = CGFloat(40 - count * 8)
      }
    }
  }
  
  private func setUserName(_ isLogined: Bool, name: String?) {
    
    if let higthConstraint = loginConentViewHeightConstraint,
      let loginContentView = loginContentView,
      let welcomeContentView = welcomeContentView,
      let welcomeLabel = welcomeUserLabel,
      let logoutButton = logOutButton {
      
      if isLogined, let lName = name {
        
        higthConstraint.constant = 20.0
        welcomeContentView.isHidden = false
        loginContentView.isHidden = true
        
        welcomeLabel.text = "Welcome, \(lName)!"
        
        logoutButton.isHidden = false
        clearInputFields()
        
      } else {
        
        higthConstraint.constant = 68.0
        welcomeContentView.isHidden = true
        loginContentView.isHidden = false
        
        welcomeLabel.text = nil
        logoutButton.isHidden = true
      }
    }
  }
 
  private func setIsHeader(_ isHeader: Bool) {
    
    if let heightConstraint = headerContentViewHeightConstraint,
      let spacingConstraint = headrAndCommentSpacingConstraint,
      let contetnView = headerContentView {
      
      if isHeader {
        
        heightConstraint.constant = 28.0
        spacingConstraint.constant = 8.0
        contetnView.isHidden = false
  
      } else {
        
        heightConstraint.constant = 0.0
        spacingConstraint.constant = 0.0
        contetnView.isHidden = true
      }
    }
  }
  
  // TODO: • Enable/Disable Post Button
  func enablePostButton() {
    
    if let postButton = postButton {
      postButton.isEnabled = true
      postButton.alpha = 1
    }
  }
  
  func disablePostButton() {
    
    if let postButton = postButton {
      postButton.isEnabled = false
      postButton.alpha = 0.4
    }
  }
  
  
  // TODO: • Clearing of fields
  private func clearInputFields() {
    
    if let nameTextField = nameTextField,
      let emailTextField = emailTextField {
      
      nameTextField.text = nil
      emailTextField.text = nil
    }
  }
  
  // TODO: • Set design
  private func setNewCommentCellDesign() {
    
    guard let mainContentView = mainContentView,
      let commentTextView = commentTextView,
      let nameTextField = nameTextField,
      let emailTextField = emailTextField,
      let totalCountLabel = totalCommentsCountLabel,
      let welcomeUserLabel = welcomeUserLabel,
      let symbolsCountLabel = symbolsCountLabel,
      let commentPlaceholderButton = commentPlaceholderButton,
      let postButton = postButton,
      let logOutButton = logOutButton,
      let cellActivityIndicator = cellActivityIndicator else {
      return
    }
    
    switch VUDesignHUB.colorsType {
      
    case .dayColors:
      
      if VUCurrentUser.isUserLogined {
        UIToolbar.addKeyboardToolbar([commentTextView])
      } else {
        UIToolbar.addKeyboardToolbar([commentTextView, nameTextField, emailTextField])
      }
      
      mainContentView.backgroundColor = VUDesignHUB.newCommentCell.backgroundColor
      totalCountLabel.textColor  = VUDesignHUB.newCommentCell.totalCountTextColor
      welcomeUserLabel.textColor = VUDesignHUB.newCommentCell.welcomeLabelTextColor
      
      commentTextView.backgroundColor = VUDesignHUB.newCommentCell.inputFieldsBackgroundColor
      nameTextField.backgroundColor   = VUDesignHUB.newCommentCell.inputFieldsBackgroundColor
      emailTextField.backgroundColor  = VUDesignHUB.newCommentCell.inputFieldsBackgroundColor
      
      commentPlaceholderButton.setTitleColor(VUDesignHUB.newCommentCell.inputFieldsPlaceholderColor,
                                             for: .normal)
      commentTextView.layer.borderColor = VUDesignHUB.newCommentCell.inputFieldsBorderColor.cgColor
      
      commentTextView.tintColor = VUDesignHUB.keyboard.editIndicatorColor
      nameTextField.tintColor   = VUDesignHUB.keyboard.editIndicatorColor
      emailTextField.tintColor  = VUDesignHUB.keyboard.editIndicatorColor

      commentTextView.textColor = VUDesignHUB.newCommentCell.inputFieldsTextColor
      nameTextField.textColor   = VUDesignHUB.newCommentCell.inputFieldsTextColor
      emailTextField.textColor  = VUDesignHUB.newCommentCell.inputFieldsTextColor
      
      commentTextView.keyboardAppearance = VUDesignHUB.keyboard.keyboardAppearance
      nameTextField.keyboardAppearance   = VUDesignHUB.keyboard.keyboardAppearance
      emailTextField.keyboardAppearance  = VUDesignHUB.keyboard.keyboardAppearance
      
      symbolsCountLabel.textColor = VUDesignHUB.newCommentCell.symbolsCountTextColor
      symbolsCountLabel.backgroundColor = VUDesignHUB.newCommentCell.symbolsCountBackgroundColor

      postButton.setTitleColor(VUDesignHUB.newCommentCell.postButtonTextColor,
                               for: .normal)
      postButton.setTitleColor(VUDesignHUB.newCommentCell.postButtonTextColor,
                               for: .highlighted)
      postButton.setTitleColor(VUDesignHUB.newCommentCell.postButtonTextColor,
                               for: .selected)
      postButton.backgroundColor = VUDesignHUB.newCommentCell.postButtonBackgroundColor
      
      logOutButton.setTitleColor(VUDesignHUB.newCommentCell.logoutButtonTextColor,
                                 for: .normal)
      logOutButton.setTitleColor(VUDesignHUB.newCommentCell.logoutButtonTextColor,
                                 for: .highlighted)
      logOutButton.setTitleColor(VUDesignHUB.newCommentCell.logoutButtonTextColor,
                                 for: .selected)
      logOutButton.backgroundColor = VUDesignHUB.newCommentCell.logoutButtonBackgroundColor
      
      cellActivityIndicator.color = VUDesignHUB.general.progressIndicatorColor
      
    case .nightColors:
      
      if VUCurrentUser.isUserLogined {
        UIToolbar.addKeyboardToolbar([commentTextView])
      } else {
        UIToolbar.addKeyboardToolbar([commentTextView, nameTextField, emailTextField])
      }
      
      mainContentView.backgroundColor = VUDesignHUB.newCommentCellNight.backgroundColor
      totalCountLabel.textColor  = VUDesignHUB.newCommentCellNight.totalCountTextColor
      welcomeUserLabel.textColor = VUDesignHUB.newCommentCellNight.welcomeLabelTextColor
      
      commentTextView.backgroundColor = VUDesignHUB.newCommentCellNight.inputFieldsBackgroundColor
      nameTextField.backgroundColor   = VUDesignHUB.newCommentCellNight.inputFieldsBackgroundColor
      emailTextField.backgroundColor  = VUDesignHUB.newCommentCellNight.inputFieldsBackgroundColor
      
      commentPlaceholderButton.setTitleColor(VUDesignHUB.newCommentCellNight.inputFieldsPlaceholderColor,
                                             for: .normal)
      commentTextView.layer.borderColor = VUDesignHUB.newCommentCellNight.inputFieldsBorderColor.cgColor
      
      commentTextView.tintColor = VUDesignHUB.keyboardNight.editIndicatorColor
      nameTextField.tintColor   = VUDesignHUB.keyboardNight.editIndicatorColor
      emailTextField.tintColor  = VUDesignHUB.keyboardNight.editIndicatorColor
      
      commentTextView.textColor = VUDesignHUB.newCommentCellNight.inputFieldsTextColor
      nameTextField.textColor   = VUDesignHUB.newCommentCellNight.inputFieldsTextColor
      emailTextField.textColor  = VUDesignHUB.newCommentCellNight.inputFieldsTextColor
      
      commentTextView.keyboardAppearance = VUDesignHUB.keyboardNight.keyboardAppearance
      nameTextField.keyboardAppearance   = VUDesignHUB.keyboardNight.keyboardAppearance
      emailTextField.keyboardAppearance  = VUDesignHUB.keyboardNight.keyboardAppearance
      
      symbolsCountLabel.textColor = VUDesignHUB.newCommentCellNight.symbolsCountTextColor
      symbolsCountLabel.backgroundColor = VUDesignHUB.newCommentCellNight.symbolsCountBackgroundColor
      
      postButton.setTitleColor(VUDesignHUB.newCommentCellNight.postButtonTextColor,
                               for: .normal)
      postButton.setTitleColor(VUDesignHUB.newCommentCellNight.postButtonTextColor,
                               for: .highlighted)
      postButton.setTitleColor(VUDesignHUB.newCommentCellNight.postButtonTextColor,
                               for: .selected)
      postButton.backgroundColor = VUDesignHUB.newCommentCellNight.postButtonBackgroundColor
      
      logOutButton.setTitleColor(VUDesignHUB.newCommentCellNight.logoutButtonTextColor,
                                 for: .normal)
      logOutButton.setTitleColor(VUDesignHUB.newCommentCellNight.logoutButtonTextColor,
                                 for: .highlighted)
      logOutButton.setTitleColor(VUDesignHUB.newCommentCellNight.logoutButtonTextColor,
                                 for: .selected)
      logOutButton.backgroundColor = VUDesignHUB.newCommentCellNight.logoutButtonBackgroundColor
      
      cellActivityIndicator.color = VUDesignHUB.generalNight.progressIndicatorColor
    }
  }
  
}


// MARK: - UITextFieldDelegate
extension VUNewCommentCell: UITextFieldDelegate {
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    
    if let nameTextField = nameTextField, textField == nameTextField {
      
      return checkLength(maxValue: 200,
                         newString: string,
                         textField: nameTextField,
                         alertText: "name")
    }
    
    if let emailTextField = emailTextField, textField == emailTextField {
      
      return checkLength(maxValue: 255,
                         newString: string,
                         textField: emailTextField,
                         alertText: "email")
    }
    
    return false
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if textField == nameTextField {
      emailTextField.becomeFirstResponder()
      
    } else {
      textField.resignFirstResponder()
    }
    return true
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
    VUGlobals.activeTextInput = self
    
    if textField == nameTextField {
      currentInputType = .nameTextField
    }
    
    if textField == emailTextField {
      currentInputType = .emailTextField
    }
    return true
  }
  
  // TODO: • Cheking length of Name or Email
  private func checkLength(maxValue: Int,
                           newString: String,
                           textField: UITextField,
                           alertText: String) -> Bool {
    
    if let pasteText = UIPasteboard.general.string, pasteText == newString,
      let currentText = textField.text,
      currentText.utf8.count + newString.utf8.count > maxValue {
     
      VUAlertsHub.showAlert("⚠️ To long \(alertText)", message: "You can't paste text with \(alertText) longer than \(maxValue) charters.")
    
      return false
    }
    
    if let currentText = textField.text,
      currentText.utf8.count + newString.utf8.count <= maxValue {
      
      return true
    }
    
    VUAlertsHub.showAlert("⚠️ To long \(alertText)", message: "You can't use \(alertText) longer than \(maxValue) charters.")
    
    return false
  }

}


// MARK: - UITextViewDelegate
extension VUNewCommentCell: UITextViewDelegate {

  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {

    VUGlobals.activeTextInput = self
    
    if textView == commentTextView {
      currentInputType = .commentTextView
    }
    return true
  }

  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
    if let pasteText = UIPasteboard.general.string, text == pasteText {
      
      if textView.text.utf8.count <= 1000 {
        return true
     
      } else {
        VUAlertsHub.showAlert("⚠️ To long comment", message: "You have already exceeded the limit of 1000 characters, so you can't paste more text.")
       
        return false
      }
    } else {
      
      if text == "" {
        return true
      }
      return textView.text.utf8.count + (text.utf8.count - range.length) <= 1000
    }
  }
  
  func textViewDidChange(_ textView: UITextView) {
    
    if let text = textView.text {
      setSymbolsCount(text)
    }
  }
  
}

