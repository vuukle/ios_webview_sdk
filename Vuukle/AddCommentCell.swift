import UIKit

protocol AddCommentCellDelegate {
    
    func postButtonPressed(tableCell : AddCommentCell ,pressed postButton : AnyObject )
    func logOutButtonPressed(tableCell : AddCommentCell ,pressed logOutButton : AnyObject )
}


class AddCommentCell: UITableViewCell , UITextViewDelegate , UITextFieldDelegate {
    var delegate : AddCommentCellDelegate?
    let defaults : UserDefaults = UserDefaults.standard
    
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
    
    @IBAction func postButton(sender: AnyObject) {
        
        self.delegate?.postButtonPressed(tableCell: self ,pressed : sender)
        
        postButtonOutlet.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [unowned self] in
            self.postButtonOutlet.isEnabled = true
        }
    }
    
    @IBAction func logOutButton(sender: AnyObject) {
        
        self.delegate?.logOutButtonPressed(tableCell: self, pressed: sender)
        
        logOut.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [unowned self] in
            self.logOut.isEnabled = true
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        background.layer.cornerRadius = 5
        postButtonOutlet.layer.cornerRadius = 5
        commentTextView.layer.cornerRadius = 5
        nameTextField.layer.cornerRadius = 5
        emailTextField.layer.cornerRadius = 5
        
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
        
        let viewForDoneButtonOnKeyboard = UIToolbar()
        viewForDoneButtonOnKeyboard.sizeToFit()
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done",
                                                style: .plain,
                                                target: self,
                                                action: #selector(doneBtnFromKeyboardClicked(sender:)))
        viewForDoneButtonOnKeyboard.setItems([btnDoneOnKeyboard], animated: false)
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        
        nameTextField.inputAccessoryView = viewForDoneButtonOnKeyboard
        emailTextField.inputAccessoryView = viewForDoneButtonOnKeyboard
        commentTextView.inputAccessoryView = viewForDoneButtonOnKeyboard
        
        commentTextView.returnKeyType = UIReturnKeyType.default
        nameTextField.returnKeyType = UIReturnKeyType.next
        emailTextField.returnKeyType = UIReturnKeyType.next
        
        emailTextField.enablesReturnKeyAutomatically = true
        nameTextField.enablesReturnKeyAutomatically = true
        
        logOut.layer.cornerRadius = 5
        logOut.layer.masksToBounds = true
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
                            contentOffset.y -= accessoryView.frame.size.height + 50
                        default:
                            contentOffset.y -= accessoryView.frame.size.height + 140
                        }
                    case 375:
                        contentOffset.y -= accessoryView.frame.size.height + 210
                    case 414:
                        contentOffset.y -= accessoryView.frame.size.height + 250
                    default:
                        contentOffset.y -= accessoryView.frame.size.height + 120
                    }
                }
            }
            scrollView.setContentOffset(contentOffset, animated: true)
        }
        return true
    }
    
    //MARK: - Handling of keyboard for UITextView
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        let superView = textView.superview?.superview?.superview?.superview?.superview?.superview?.superview?.superview
        
        if superView is UIScrollView {
            
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
                            contentOffset.y -= accessoryView.frame.size.height + 10
                        default:
                            contentOffset.y -= accessoryView.frame.size.height + 40
                        }
                    case 375:
                        contentOffset.y -= accessoryView.frame.size.height + 70
                    case 414:
                        contentOffset.y -= accessoryView.frame.size.height + 100
                    default:
                        contentOffset.y -= accessoryView.frame.size.height + 20
                    }
                }
            }
            scrollView.setContentOffset(contentOffset, animated: true)
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
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        commentTextView.text = ""
    }
    
    func showProgress() {
        self.alpha = 0.4
        progressIndicator.startAnimating()
        progressIndicator.isHidden = false
        //commentTextView.a
    }
    
    func hideProgress() {
        progressIndicator.isHidden = true
        progressIndicator.stopAnimating()
        self.alpha = 1
    }
    
}
