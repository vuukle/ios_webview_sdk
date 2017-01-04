import UIKit

protocol AddCommentCellDelegate {
  
  func postButtonPressed(tableCell : AddCommentCell ,pressed postButton : AnyObject )
  
  func logOutButtonPressed(tableCell : AddCommentCell ,pressed logOutButton : AnyObject )
  
  func facebookLoginButtonPressed(tableCell : AddCommentCell, pressed facebookLoginButton: AnyObject)
  
  func twitterLoginButtonPressed(tableCell : AddCommentCell, pressed twitterLoginButton: AnyObject)
  
  func googleLoginButtonPressed(tableCell : AddCommentCell, pressed googleLoginButton: AnyObject)
  
  func linkedinLoginButtonPressed(tableCell : AddCommentCell, pressed linkedinLoginButton: AnyObject)
}


class AddCommentCell: UITableViewCell , UITextViewDelegate , UITextFieldDelegate {
  
  var delegate : AddCommentCellDelegate?
  let defaults : UserDefaults = UserDefaults.standard
  
  var isSocialLoginHidden = Bool() {
    willSet {
      
      self.isSocialLoginHidden = newValue
      UserDefaults.standard.set(newValue, forKey: "isSocialLoginHidden")
      
      logInWithLabel.isHidden = newValue
      facebookLogin.isHidden = newValue
      twitterLogin.isHidden = newValue
      //linkedinLogin.isHidden = newValue
    }
  }
  
  var indexRow = 1
  
  @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var commentTextView: UITextView!
  
  @IBOutlet weak var nameTextField: UITextField!
  
  @IBOutlet weak var emailTextField: UITextField!
  
  @IBOutlet weak var background: UIView!
  
  @IBOutlet weak var postButtonOutlet: UIButton!
  
  @IBOutlet weak var leftConstrainSize: NSLayoutConstraint!
  
  @IBOutlet weak var totalCount: UILabel!
  
  @IBOutlet weak var greetingLabel: UILabel!
  
  @IBOutlet weak var totalCountHeight: NSLayoutConstraint!
  
  @IBOutlet weak var logOutButtonHeight: NSLayoutConstraint!
  
  @IBOutlet weak var backgroundHeight: NSLayoutConstraint!
  
  @IBOutlet weak var logOut: UIButton!
  
  @IBOutlet weak var facebookLogin: UIButton!
  
  @IBOutlet weak var twitterLogin: UIButton!
  
  @IBOutlet weak var otherLogin: UIButton!
  
  @IBOutlet weak var linkedinLogin: UIButton!
  
  @IBOutlet weak var logInWithLabel: UILabel!
  
  @IBOutlet weak var chartersCountLabel: UILabel!
  
  @IBAction func postButton(sender: AnyObject) {
    
    postButtonOutlet.isEnabled = false
    self.delegate?.postButtonPressed(tableCell: self, pressed: sender)
    
  }
  
  @IBAction func logOutButton(sender: AnyObject) {
    
    logOut.isEnabled = false
    isSocialLoginHidden = false
    
    self.delegate?.logOutButtonPressed(tableCell: self, pressed: sender)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [unowned self] in
      self.logOut.isEnabled = true
    }
  }
  
  override func awakeFromNib() {
    
    super.awakeFromNib()
    
    otherLogin.isHidden = true
    linkedinLogin.isHidden = true
    
    background.layer.cornerRadius = 5
    postButtonOutlet.layer.cornerRadius = 5
    commentTextView.layer.cornerRadius = 5
    nameTextField.layer.cornerRadius = 5
    emailTextField.layer.cornerRadius = 5
    facebookLogin.layer.cornerRadius = 13
    facebookLogin.layer.masksToBounds = true
    
    commentTextView.layer.borderWidth = 1
    commentTextView.layer.borderColor = UIColor.lightGray.cgColor
    
    nameTextField.layer.borderWidth = 1
    nameTextField.layer.borderColor = UIColor.lightGray.cgColor
    
    emailTextField.layer.borderWidth = 1
    emailTextField.layer.borderColor = UIColor.lightGray.cgColor
    
    background.layer.borderWidth = 1
    background.layer.borderColor = UIColor.lightGray.cgColor
    
    commentTextView.text = "Please write a comment..."
    commentTextView.textColor = UIColor.lightGray
    commentTextView.delegate = self
    
    let user = ParametersConstructor.sharedInstance.getUserInfo()
    
    if user["isLoggedIn"] == "true" {
      addToolbarToTextObjects(arrayTextObjects: [commentTextView])
    } else {
      addToolbarToTextObjects(arrayTextObjects: [commentTextView, nameTextField, emailTextField])
    }
    
    
    nameTextField.delegate = self
    emailTextField.delegate = self
    
    
    commentTextView.returnKeyType = UIReturnKeyType.default
    nameTextField.returnKeyType = UIReturnKeyType.done
    emailTextField.returnKeyType = UIReturnKeyType.done
    
    emailTextField.enablesReturnKeyAutomatically = true
    nameTextField.enablesReturnKeyAutomatically = true
    
    
    chartersCountLabel.text = "1000"
    
    
    logOut.layer.cornerRadius = 5
    logOut.layer.masksToBounds = true
    
    let isHide = UserDefaults.standard.value(forKey: "isSocialLoginHidden") as? Bool
    if (isHide != nil) {
      isSocialLoginHidden = isHide!
    } else {
      isSocialLoginHidden = false
    }
    
    NotificationCenter.default.addObserver(forName: Notification.Name("Set_SocialLogin_Hidden"), object: nil, queue: nil) { [unowned self]
      notification in
      
      self.isSocialLoginHidden = true
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  @IBAction func facebookLoginButton(_ sender: Any) {
    self.delegate?.facebookLoginButtonPressed(tableCell: self, pressed: sender as AnyObject)
  }
  
  @IBAction func twitterLoginButton(_ sender: Any) {
    self.delegate?.twitterLoginButtonPressed(tableCell: self, pressed: sender as AnyObject)
  }
  
  @IBAction func otherLoginButton(_ sender: Any) {
    self.delegate?.googleLoginButtonPressed(tableCell: self, pressed: sender as AnyObject)
  }
  
  @IBAction func linkedinLoginButton(_ sender: Any) {
    self.delegate?.linkedinLoginButtonPressed(tableCell: self, pressed: sender as AnyObject)
  }
  
  
  //MARK: - Handling of keyboard for UITextField
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
    var superView = textField.superview?.superview?.superview?.superview?.superview
    var isСontinueSearch = true
    
    while isСontinueSearch {
      
      if !(superView is UIWindow) {
        
        if superView?.superview is UIScrollView {
          
          isСontinueSearch = false
          superView = superView?.superview
          
          var scrollView = superView as! UIScrollView
          print("\n \(scrollView)")
          
          var pointInScroll: CGPoint = textField.superview!.convert(textField.frame.origin, to: scrollView)
          
          var contentOffset: CGPoint = scrollView.contentOffset
          contentOffset.y  = pointInScroll.y
          
          if let accessoryView = textField.inputAccessoryView {
            
            if (UIDevice.current.orientation.isLandscape) {
              switch UIScreen.main.bounds.height {
              case 375:
                contentOffset.y -= accessoryView.frame.size.height
              case 414:
                contentOffset.y -= accessoryView.frame.size.height + 20
              default:
                contentOffset.y -= accessoryView.frame.size.height
              }
            } else {
              switch UIScreen.main.bounds.width {
              case 320:
                switch UIScreen.main.bounds.height {
                case 480:
                  contentOffset.y -= accessoryView.frame.size.height + 30
                default:
                  contentOffset.y -= accessoryView.frame.size.height + 120
                }
              case 375:
                contentOffset.y -= accessoryView.frame.size.height + 190
              case 414:
                contentOffset.y -= accessoryView.frame.size.height + 230
              default:
                contentOffset.y -= accessoryView.frame.size.height + 100
              }
            }
          }
          scrollView.setContentOffset(contentOffset, animated: true)
          
        } else {
          superView = superView?.superview
        }
      } else {
        print("\n-- Stop...")
        isСontinueSearch = false
      }
    }
    return true
    
  }
  
  //MARK: - Handling of keyboard for UITextView
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    
    var superView = textView.superview?.superview?.superview?.superview?.superview
    var isСontinueSearch = true
    
    while isСontinueSearch {
      
      if !(superView is UIWindow) {
        
        if superView?.superview is UIScrollView {
          
          isСontinueSearch = false
          
          superView = superView?.superview
          
          var scrollView = superView as! UIScrollView
          print("\n \(scrollView)")
          
          var pointInScroll: CGPoint = textView.superview!.convert(textView.frame.origin, to: scrollView)
          
          var contentOffset: CGPoint = scrollView.contentOffset
          contentOffset.y  = pointInScroll.y
          
          if let accessoryView = textView.inputAccessoryView {
            
            if (UIDevice.current.orientation.isLandscape) {
              contentOffset.y -= accessoryView.frame.size.height
            } else {
              switch UIScreen.main.bounds.width {
              case 320:
                switch UIScreen.main.bounds.height {
                case 480:
                  contentOffset.y -= accessoryView.frame.size.height
                default:
                  contentOffset.y -= accessoryView.frame.size.height + 30
                }
              case 375:
                contentOffset.y -= accessoryView.frame.size.height + 50
              case 414:
                contentOffset.y -= accessoryView.frame.size.height + 80
              default:
                contentOffset.y -= accessoryView.frame.size.height
              }
            }
          }
          scrollView.setContentOffset(contentOffset, animated: true)
          
        } else {
          superView = superView?.superview
        }
      } else {
        print("\n-- Stop...")
        isСontinueSearch = false
      }
    }
    return true
  }
  
  //MARK: -
  func doneBtnFromKeyboardClicked(sender : UIBarButtonItem) {
    
    nameTextField.resignFirstResponder()
    emailTextField.resignFirstResponder()
    commentTextView.resignFirstResponder()
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    
    if commentTextView.textColor == UIColor.lightGray {
      commentTextView.text = ""
      commentTextView.textColor = UIColor.black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    
    if commentTextView.text.isEmpty {
      commentTextView.text = "Please write a comment..."
      commentTextView.textColor = UIColor.lightGray
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  override func prepareForReuse() {
    
    let isHide = UserDefaults.standard.value(forKey: "isSocialLoginHidden") as? Bool
    if (isHide != nil) {
      isSocialLoginHidden = isHide!
    } else {
      isSocialLoginHidden = false
    }
    
    commentTextView.text = ""
    commentTextView.text = "Please write a comment..."
    commentTextView.textColor = UIColor.lightGray
    commentTextView.delegate = self
    
    chartersCountLabel.text = "1000"
    
    let user = ParametersConstructor.sharedInstance.getUserInfo()
    if user["isLoggedIn"] == "true" {
      addToolbarToTextObjects(arrayTextObjects: [commentTextView])
    } else {
      addToolbarToTextObjects(arrayTextObjects: [commentTextView, nameTextField, emailTextField])
    }
  }
  
  
  func showProgress() {
    
    self.alpha = 0.4
    progressIndicator.isHidden = false
    progressIndicator.startAnimating()
  }
  
  
  func hideProgress() {

    progressIndicator.isHidden = true
    progressIndicator.stopAnimating()
    self.alpha = 1
  }
  
  
  
  func addToolbarToTextObjects(arrayTextObjects: NSArray) {
    
    let BACK_IMAGE = UIImage(named: "toolbar-back-button", in: Bundle(for: type(of: self)), compatibleWith: nil)
    let NEXT_IMAGE = UIImage(named: "toolbar-next-button", in: Bundle(for: type(of: self)), compatibleWith: nil)
    
    for i in 0..<arrayTextObjects.count {
      
      var lTextObject = arrayTextObjects[i]
      
      let lKeyboardToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
      lKeyboardToolbar.barStyle = .default
      
      var lToolbarItems = [UIBarButtonItem]()
      
      
      var lBarSpacer = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
      var lDoneBarButton = UIBarButtonItem.init(title: "Done", style: .done, target: lTextObject, action: #selector(resignFirstResponder))
      
      lToolbarItems.append(lDoneBarButton)
      lToolbarItems.append(lBarSpacer)
      
      if arrayTextObjects.count > 1 {
        
        var lBackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        lBackButton.setImage(BACK_IMAGE, for: .normal)
        lBackButton.imageEdgeInsets = UIEdgeInsetsMake(15.5, 10, 15.5, 10)
        
        var lNextButton = UIButton(frame: CGRect(x: (44 + 10), y: 0, width: 44, height: 44))
        lNextButton.setImage(NEXT_IMAGE, for: .normal)
        lNextButton.imageEdgeInsets = UIEdgeInsetsMake(15.5, 10, 15.5, 10)
        
        var lBackBarButtonItem = UIBarButtonItem.init(customView: lBackButton)
        var lNextBarButtonItem = UIBarButtonItem.init(customView: lNextButton)
        
        if (i - 1) >= 0 {
          lBackButton.addTarget(arrayTextObjects[i - 1], action: #selector(becomeFirstResponder), for: .touchUpInside)
        } else {
          lBackBarButtonItem.isEnabled = false
        }
        
        if (i + 1) < arrayTextObjects.count {
          lNextButton.addTarget(arrayTextObjects[i + 1], action: #selector(becomeFirstResponder), for: .touchUpInside)
        } else {
          lNextBarButtonItem.isEnabled = false
        }
        
        lToolbarItems.append(lBackBarButtonItem)
        lToolbarItems.append(lNextBarButtonItem)
      }
      
      lKeyboardToolbar.items = lToolbarItems
      
      if lTextObject is UITextField {
        
        var lTextField = lTextObject as! UITextField
        lTextField.inputAccessoryView = lKeyboardToolbar
        
      } else if lTextObject is UITextView {
        
        var lTextView = lTextObject as! UITextView
        lTextView.inputAccessoryView = lKeyboardToolbar
      }
    }
  }
  
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
    return textView.text.characters.count + (text.characters.count - range.length) <= 1000
  }
  
  func textViewDidChange(_ textView: UITextView) {
    
    if let lText = textView.text {
      chartersCountLabel.text = "\(1000 - lText.characters.count)"
    }
  }
  
}
