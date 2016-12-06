import UIKit

protocol LoginCellDelegate {
    func loginButtonPressed(tableCell: LoginCell, pressed loginButton: AnyObject)
}

class LoginCell: UITableViewCell, UITextViewDelegate, UITextFieldDelegate {
    var delegate : LoginCellDelegate?
    let defaults : UserDefaults = UserDefaults.standard
    
    var indexRow = 1
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    @IBAction func loginButton(_ sender: AnyObject) {
        self.delegate?.loginButtonPressed(tableCell: self, pressed: sender)
        
        loginButtonOutlet.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [unowned self] in
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
        let viewForDoneButtonOnKeyboard = UIToolbar()
        viewForDoneButtonOnKeyboard.sizeToFit()
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done",
                                                style: .plain,
                                                target: self,
                                                action: #selector(doneBtnFromKeyboardClicked(sender:)))
        viewForDoneButtonOnKeyboard.setItems([btnDoneOnKeyboard], animated: false)
        nameField.delegate = self
        emailField.delegate = self
        
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.lightGray.cgColor
        
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        
        nameField.inputAccessoryView = viewForDoneButtonOnKeyboard
        emailField.inputAccessoryView = viewForDoneButtonOnKeyboard
        
        nameField.returnKeyType = UIReturnKeyType.next
        emailField.returnKeyType = UIReturnKeyType.next
        
        nameField.enablesReturnKeyAutomatically = true
        emailField.enablesReturnKeyAutomatically = true
        // Initialization code
    }
    
    //MARK: - Handling of keyboard for UITextField
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let superView = textField.superview?.superview?.superview?.superview?.superview?.superview?.superview?.superview
        
        if superView is UIScrollView {
            
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
        }
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
    
}
