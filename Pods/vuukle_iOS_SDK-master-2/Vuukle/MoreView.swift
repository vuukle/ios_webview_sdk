

import UIKit

class MoreView: UIView {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.removeFromSuperview()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    static func loadViewFromNib() -> MoreView
    {
        let nib = UINib(nibName: "MoreView", bundle: nil)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! MoreView
        return view
    }
    
}
