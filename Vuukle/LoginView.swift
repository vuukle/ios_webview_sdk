import UIKit

class LoginView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    static func loadViewFromNib() -> LoginView
    {
        let nib = UINib(nibName: "LoginView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! LoginView
        return view
    }
    
}
