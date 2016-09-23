

import UIKit
protocol AddCommentCellDelegate {
    
    func postButtonPressed(tableCell : AddCommentCell ,postButtonPressed postButton : AnyObject )
    func logOutButtonPressed(tableCell : AddCommentCell ,logOutButtonPressed logOutButton : AnyObject )
}
class AddCommentCell: UITableViewCell , UITextViewDelegate {
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
            self.defaults.synchronize()
            
        } else {
            
            self.defaults.removeObject(forKey: "name")
            self.defaults.set("\(nameTextField.text!)", forKey: "name")
            self.defaults.synchronize()
        }
        
        if self.defaults.object(forKey: "email") as? String == nil {
            self.defaults.set("\(emailTextField.text!)", forKey: "email")
            self.defaults.synchronize()
            
        } else {
            
            self.defaults.removeObject(forKey: "email")
            self.defaults.set("\(emailTextField.text!)", forKey: "email")
            self.defaults.synchronize()
        }
        
        self.delegate?.postButtonPressed(tableCell: self ,postButtonPressed : sender)
    }
    
    @IBAction func logOutButton(sender: AnyObject) {
        self.delegate?.logOutButtonPressed(tableCell: self, logOutButtonPressed: sender)
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
        
        nameTextField.inputAccessoryView = viewForDoneButtonOnKeyboard
        emailTextField.inputAccessoryView = viewForDoneButtonOnKeyboard
        commentTextView.inputAccessoryView = viewForDoneButtonOnKeyboard
    }
    
    func doneBtnFromKeyboardClicked(sender : UIBarButtonItem) {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        commentTextView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if commentTextView.textColor == UIColor.lightGray {
            commentTextView.text = ""
            commentTextView.text = nil
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
