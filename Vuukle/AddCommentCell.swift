

import UIKit
protocol AddCommentCellDelegate {
    
    func postButtonPressed(tableCell : AddCommentCell ,pressed postButton : AnyObject )
    func logOutButtonPressed(tableCell : AddCommentCell ,pressed logOutButton : AnyObject )
}
class AddCommentCell: UITableViewCell , UITextViewDelegate , UITextFieldDelegate {
    var delegate : AddCommentCellDelegate?
    let defaults : UserDefaults = UserDefaults.standard
    
    var indexRow = 1
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var postButtonOutlet: UIButton!
    
    @IBOutlet weak var leftConstrainSize: NSLayoutConstraint!
    
    @IBOutlet weak var totalCount: UILabel!
    
    @IBOutlet weak var totalCountHeight: NSLayoutConstraint!
    
    @IBOutlet weak var logOutButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var logOut: UIButton!
    
    @IBAction func postButton(sender: AnyObject) {
        
        if self.defaults.object(forKey: "name") as? String == nil {
            self.defaults.set("\(nameTextField.text!)", forKey: "name")
        } else {
            self.defaults.removeObject(forKey: "name")
            self.defaults.set("\(nameTextField.text!)", forKey: "name")
        }
        
        if self.defaults.object(forKey: "email") as? String == nil {
            self.defaults.set("\(emailTextField.text!)", forKey: "email")
        } else {
            
            self.defaults.removeObject(forKey: "email")
            self.defaults.set("\(emailTextField.text!)", forKey: "email")
        }
        self.defaults.synchronize()
        self.delegate?.postButtonPressed(tableCell: self ,pressed : sender)
    }
    
    @IBAction func logOutButton(sender: AnyObject) {
        self.delegate?.logOutButtonPressed(tableCell: self, pressed: sender)
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
    }
    
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
    
}
