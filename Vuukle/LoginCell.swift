import UIKit

protocol LoginCellDelegate {
  
  func loginButtonPressed(tableCell: LoginCell, activeCommentCell: CommentCell, pressed loginButton: AnyObject)

  func loginTwitterPressed(tableCell: LoginCell, activeCommentCell: CommentCell, pressed loginButton: UIButton)
  
  func loginFacebookPressed(tableCell: LoginCell, activeCommentCell: CommentCell, pressed loginButton: UIButton)
}

class LoginCell: UITableViewCell, UITextViewDelegate, UITextFieldDelegate {
  var delegate : LoginCellDelegate?
  let defaults : UserDefaults = UserDefaults.standard
  
  var indexRow = 1
  
  var commentCellReference: CommentCell?
  
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var background: UIView!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
  
  @IBOutlet weak var loginButtonOutlet: UIButton!
  
  @IBOutlet weak var facebookLoginButton: UIButton!
  @IBOutlet weak var twitterLoginButton: UIButton!
  
  
  @IBAction func loginButton(_ sender: AnyObject) {
    
    endEditing(true)
    self.nameField.resignFirstResponder()
    self.emailField.resignFirstResponder()
    
    self.delegate?.loginButtonPressed(tableCell: self, activeCommentCell: commentCellReference!, pressed: sender)
    
    loginButtonOutlet.isEnabled = false
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
      self.loginButtonOutlet.isEnabled = true
    }
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    background.layer.cornerRadius = 5
    background.layer.borderWidth = 1
    background.layer.borderColor = UIColor.lightGray.cgColor
    loginButtonOutlet.layer.cornerRadius = 5
    nameField.layer.cornerRadius = 5
    emailField.layer.cornerRadius = 5
    
    addToolbarToTextObjects(arrayTextObjects: [nameField, emailField])
    
    nameField.delegate = self
    emailField.delegate = self
    
    nameField.returnKeyType = UIReturnKeyType.done
    emailField.returnKeyType = UIReturnKeyType.done
    
    nameField.enablesReturnKeyAutomatically = true
    emailField.enablesReturnKeyAutomatically = true
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
                contentOffset.y -= accessoryView.frame.size.height + 20
              case 414:
                contentOffset.y -= accessoryView.frame.size.height + 40
              default:
                contentOffset.y -= accessoryView.frame.size.height
              }
            } else {
              switch UIScreen.main.bounds.width {
              case 320:
                switch UIScreen.main.bounds.height {
                case 480:
                  contentOffset.y -= accessoryView.frame.size.height + 40
                default:
                  contentOffset.y -= accessoryView.frame.size.height + 100
                }
              case 375:
                contentOffset.y -= accessoryView.frame.size.height + 170
              case 414:
                contentOffset.y -= accessoryView.frame.size.height + 210
              default:
                contentOffset.y -= accessoryView.frame.size.height + 80
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
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    textField.resignFirstResponder()
    return true
  }
  
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if nameField.text == "name" {
      nameField.text = ""
    }
    if emailField.text == "email" {
      emailField.text = ""
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if (nameField.text?.isEmpty)! {
      nameField.text = "name"
    }
    if (emailField.text?.isEmpty)! {
      emailField.text = "email"
    }
  }
  
  func doneBtnFromKeyboardClicked(sender : UIBarButtonItem) {
    nameField.resignFirstResponder()
    emailField.resignFirstResponder()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override func prepareForReuse() {
    nameField.text = ""
    emailField.text = ""
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
  
  @IBAction func facebookLoginButtonAction(_ sender: UIButton) {
    
    self.delegate?.loginFacebookPressed(tableCell: self, activeCommentCell: commentCellReference!, pressed: sender)
    
    facebookLoginButton.isEnabled = false
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
      self.facebookLoginButton.isEnabled = true
    }
    
  }
  
  @IBAction func twitterLoginButtonAction(_ sender: UIButton) {
    
    self.delegate?.loginTwitterPressed(tableCell: self, activeCommentCell: commentCellReference!, pressed: sender)
    
    twitterLoginButton.isEnabled = false
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
      self.twitterLoginButton.isEnabled = true
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
  
}
