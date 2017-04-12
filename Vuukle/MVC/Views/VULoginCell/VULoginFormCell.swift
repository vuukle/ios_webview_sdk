//
//  VULoginForm.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit


// MARK: - VULoginFormCellDelegate
protocol VULoginFormCellDelegate {
  
  func keyboardWillShowFor(_ loginFormCell: VULoginFormCell,
                           inputType: VUTextInputType,
                           keyboardHeight: CGFloat)
  
  func loginButtonPressed(_ newCommentCell: VULoginFormCell,
                          userName: String,
                          userEmail: String,
                          postButton: UIButton)
}


// MARK: - VULoginFormCell
class VULoginFormCell: UITableViewCell {
  
  var delegate: VULoginFormCellDelegate?
  var currentInputType: VUTextInputType = .unknown
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var loginButton: VUCustumButton!
  
  @IBOutlet weak var mainContentView: UIView!
  
  
  // MARK: - Lifecycle
  override func awakeFromNib() {
    super.awakeFromNib()
   
    setLoginFormCellDesign()
    
    addObserverForKeyboardDidShowNotification()
    addObserverForNewDesignNotification()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    nameTextField.text = nil
    emailTextField.text = nil
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  
  // MARK: - Button action
  @IBAction func loginButtonAction(_ sender: VUCustumButton) {
    sender.showAnimatedTap(0.94)
    
    if let name = nameTextField.text,
      let email = emailTextField.text {
      
      delegate?.loginButtonPressed(self,
                                   userName: name,
                                   userEmail: email,
                                   postButton: sender)
    }
  }
 
  
  // MARK: - Notifications
  private func addObserverForKeyboardDidShowNotification() {
    
    NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidShow, object: nil, queue: nil) { [weak self] notification in
      
      guard let exSelf = self else {
        return
      }
      
      if let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect,
        let activeTextInput = VUGlobals.activeTextInput as? VULoginFormCell,
        activeTextInput == self {
        
        exSelf.delegate?.keyboardWillShowFor(exSelf,
                                             inputType: exSelf.currentInputType,
                                             keyboardHeight: keyboardSize.height + 44)
      }
    }
  }
  
  private func addObserverForNewDesignNotification() {
    
    NotificationCenter.default.addObserver(forName: VUGlobals.nSetNewDesign, object: nil,  queue: nil) { [weak self] (notification) in
      
      guard let exSelf = self else {
        return
      }
      
      exSelf.setLoginFormCellDesign()
      exSelf.endEditing(true)
    }
  }
  
  
  // MARK: - Design and colors
  func setLoginFormCellDesign() {
    
    
    guard let mainContentView = mainContentView,
      let emailTextField = emailTextField,
      let nameTextField = nameTextField,
      let loginButton = loginButton else {
        return
    }
  
    switch VUDesignHUB.colorsType {
      
    case .dayColors:

      UIToolbar.addKeyboardToolbar([nameTextField, emailTextField])
      
      mainContentView.backgroundColor = VUDesignHUB.loginFormCell.backgroundColor
      
      nameTextField.tintColor   = VUDesignHUB.keyboard.editIndicatorColor
      emailTextField.tintColor  = VUDesignHUB.keyboard.editIndicatorColor
      
      nameTextField.textColor   = VUDesignHUB.loginFormCell.inputFieldsTextColor
      emailTextField.textColor  = VUDesignHUB.loginFormCell.inputFieldsTextColor
      
      nameTextField.backgroundColor = VUDesignHUB.loginFormCell.inputFieldsBackgroundColor
      emailTextField.backgroundColor = VUDesignHUB.loginFormCell.inputFieldsBackgroundColor
      
      nameTextField.keyboardAppearance   = VUDesignHUB.keyboard.keyboardAppearance
      emailTextField.keyboardAppearance  = VUDesignHUB.keyboard.keyboardAppearance
      
      loginButton.setTitleColor(VUDesignHUB.loginFormCell.loginButtonTextColor,
                                for: .normal)
      loginButton.setTitleColor(VUDesignHUB.loginFormCell.loginButtonTextColor,
                                for: .highlighted)
      loginButton.setTitleColor(VUDesignHUB.loginFormCell.loginButtonTextColor,
                                for: .selected)
      
      loginButton.backgroundColor = VUDesignHUB.loginFormCell.loginButtonBackgroundColor
      
    case .nightColors:
      
      UIToolbar.addKeyboardToolbar([nameTextField, emailTextField])
      
      mainContentView.backgroundColor = VUDesignHUB.loginFormCellNight.backgroundColor
      
      nameTextField.tintColor   = VUDesignHUB.keyboardNight.editIndicatorColor
      emailTextField.tintColor  = VUDesignHUB.keyboardNight.editIndicatorColor
      
      nameTextField.textColor   = VUDesignHUB.loginFormCellNight.inputFieldsTextColor
      emailTextField.textColor  = VUDesignHUB.loginFormCellNight.inputFieldsTextColor
      
      nameTextField.backgroundColor = VUDesignHUB.loginFormCellNight.inputFieldsBackgroundColor
      emailTextField.backgroundColor = VUDesignHUB.loginFormCellNight.inputFieldsBackgroundColor
      
      nameTextField.keyboardAppearance   = VUDesignHUB.keyboardNight.keyboardAppearance
      emailTextField.keyboardAppearance  = VUDesignHUB.keyboardNight.keyboardAppearance
      
      loginButton.setTitleColor(VUDesignHUB.loginFormCellNight.loginButtonTextColor,
                                for: .normal)
      loginButton.setTitleColor(VUDesignHUB.loginFormCellNight.loginButtonTextColor,
                                for: .highlighted)
      loginButton.setTitleColor(VUDesignHUB.loginFormCellNight.loginButtonTextColor,
                                for: .selected)
      
      loginButton.backgroundColor = VUDesignHUB.loginFormCellNight.loginButtonBackgroundColor
    }
  }
  
}


// MARK: - UITextFieldDelegate
extension VULoginFormCell: UITextFieldDelegate {
  
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
