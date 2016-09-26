

import UIKit
protocol AddCommentCellDelegate {
    
    func postButtonPressed(tableCell : AddCommentCell ,postButtonPressed postButton : AnyObject )
    func logOutButtonPressed(tableCell : AddCommentCell ,logOutButtonPressed logOutButton : AnyObject )
}
class AddCommentCell: UITableViewCell , UITextViewDelegate {
    var delegate : AddCommentCellDelegate?
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
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
        
        if self.defaults.objectForKey("name") as? String == nil {
            self.defaults.setObject("\(nameTextField.text!)", forKey: "name")
            self.defaults.synchronize()
            
        } else {
            
            self.defaults.removeObjectForKey("name")
            self.defaults.setObject("\(nameTextField.text!)", forKey: "name")
            self.defaults.synchronize()
        }
        
        if self.defaults.objectForKey("email") as? String == nil {
            self.defaults.setObject("\(emailTextField.text!)", forKey: "email")
            self.defaults.synchronize()
            
        } else {
            
            self.defaults.removeObjectForKey("email")
            self.defaults.setObject("\(emailTextField.text!)", forKey: "email")
            self.defaults.synchronize()
        }
        
        self.delegate?.postButtonPressed(self ,postButtonPressed : sender)
    }
    
    @IBAction func logOutButton(sender: AnyObject) {
        self.delegate?.logOutButtonPressed(self, logOutButtonPressed: sender)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        background.layer.cornerRadius = 5
        postButtonOutlet.layer.cornerRadius = 5
        commentTextView.layer.cornerRadius = 5
        nameTextField.layer.cornerRadius = 5
        emailTextField.layer.cornerRadius = 5
        
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        background.layer.borderWidth = 1
        background.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        commentTextView.text = "Please write a comment..."
        commentTextView.textColor = UIColor.lightGrayColor()
        commentTextView.delegate = self
        
        let viewForDoneButtonOnKeyboard = UIToolbar()
        viewForDoneButtonOnKeyboard.sizeToFit()
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(AddCommentCell.doneBtnFromKeyboardClicked(_:)))
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
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if commentTextView.textColor == UIColor.lightGrayColor() {
            commentTextView.text = ""
            commentTextView.text = nil
            commentTextView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if commentTextView.text.isEmpty {
            commentTextView.text = "Please write a comment..."
            commentTextView.textColor = UIColor.lightGrayColor()
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
