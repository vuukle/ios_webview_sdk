

import UIKit

protocol EmoticonCellDelegate {
    
    func firstEmoticonButtonPressed(tableCell : EmoticonCell ,firstEmoticonButtonPressed firstEmoticonButton : AnyObject )
    func secondEmoticonButtonPressed(tableCell : EmoticonCell ,secondEmoticonButtonPressed secondEmoticonButton : AnyObject )
    func thirdEmoticonButtonPressed(tableCell : EmoticonCell ,thirdEmoticonButtonPressed thirdEmoticonButton : AnyObject )
    func fourthEmoticonButtonPressed(tableCell : EmoticonCell ,fourthEmoticonButtonPressed fourthEmoticonButton : AnyObject )
    func fifthEmoticonButtonPressed(tableCell : EmoticonCell ,fifthEmoticonButtonPressed fifthEmoticonButton : AnyObject )
    func sixthEmoticonButtonPressed(tableCell : EmoticonCell ,sixthEmoticonButtonPressed sixthEmoticonButton : AnyObject )
}

class EmoticonCell: UITableViewCell ,UIWebViewDelegate {
    
    var delegate : EmoticonCellDelegate?
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var firstEmoticonImage: UIImageView!
    @IBOutlet weak var secondEmoticonImage: UIImageView!
    @IBOutlet weak var thirdEmoticonImage: UIImageView!
    @IBOutlet weak var fourthEmoticonImage: UIImageView!
    @IBOutlet weak var fifthEmoticonImage: UIImageView!
    @IBOutlet weak var sixthEmoticonImage: UIImageView!
    
    @IBOutlet weak var firstEmoticonLabel: UILabel!
    @IBOutlet weak var secondEmoticonLabel: UILabel!
    @IBOutlet weak var thirdEmoticonLabel: UILabel!
    @IBOutlet weak var fourthEmoticonLabel: UILabel!
    @IBOutlet weak var fifthEmoticonLabel: UILabel!
    @IBOutlet weak var sixthEmoticonLabel: UILabel!
    
    
    @IBOutlet weak var countFirstEmoticonLabel: UILabel!
    @IBOutlet weak var countSecondEmoticonLabel: UILabel!
    @IBOutlet weak var countThirdEmoticonLabel: UILabel!
    @IBOutlet weak var countFourthEmoticonLabel: UILabel!
    @IBOutlet weak var countFifthEmoticonLabel: UILabel!
    @IBOutlet weak var countSixthEmoticonLabel: UILabel!
    
    @IBAction func firstEmoticonButton(sender: AnyObject) {
        self.delegate?.firstEmoticonButtonPressed(self, firstEmoticonButtonPressed: sender)
    }
    @IBAction func secondEmoticonButton(sender: AnyObject) {
        self.delegate?.secondEmoticonButtonPressed(self, secondEmoticonButtonPressed: sender)
    }
    @IBAction func thirdEmoticonButton(sender: AnyObject) {
        self.delegate?.thirdEmoticonButtonPressed(self, thirdEmoticonButtonPressed: sender)
    }
    @IBAction func fourthEmoticonButton(sender: AnyObject) {
        self.delegate?.fourthEmoticonButtonPressed(self, fourthEmoticonButtonPressed: sender)
    }
    @IBAction func fifthEmoticonButton(sender: AnyObject) {
        self.delegate?.fifthEmoticonButtonPressed(self, fifthEmoticonButtonPressed: sender)
    }
    @IBAction func sixthEmoticonButton(sender: AnyObject) {
        self.delegate?.sixthEmoticonButtonPressed(self, sixthEmoticonButtonPressed: sender)
    }
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var firstEmoticonImageHeight: NSLayoutConstraint!
    @IBOutlet weak var secondEmoticonImageHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdEmoticonImageHeight: NSLayoutConstraint!
    @IBOutlet weak var fourthEmoticonImageHeight: NSLayoutConstraint!
    @IBOutlet weak var fifthEmoticonImageHeight: NSLayoutConstraint!
    @IBOutlet weak var sixthEmoticonImageHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
