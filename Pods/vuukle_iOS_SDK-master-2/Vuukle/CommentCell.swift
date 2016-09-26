

import UIKit
import Alamofire

protocol CommentCellDelegate {
    
    func upvoteButtonPressed(tableCell : CommentCell ,upvoteButtonPressed upvoteButton : AnyObject )
    func downvoteButtonPressed(tableCell : CommentCell ,downvoteButtonPressed downvoteButton : AnyObject )
    func replyButtonPressed(tableCell : CommentCell ,replyButtonPressed replyButton : AnyObject )
    func moreButtonPressed(tableCell : CommentCell ,moreButtonPressed moreButton : AnyObject )
    func showReplyButtonPressed(tableCell : CommentCell ,showReplyButtonPressed showReplyButton : AnyObject )
    func firstShareButtonPressed(tableCell : CommentCell ,shareButtonPressed shareButton : AnyObject )
    func secondShareButtonPressed(tableCell : CommentCell ,shareButtonPressed shareButton : AnyObject )
}

class CommentCell: UITableViewCell {
    
    var delegate : CommentCellDelegate?
    var leftCostraint = 16
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var upvoteCountLabel: UILabel!
    @IBOutlet weak var downvoteCountLabel: UILabel!
    @IBOutlet weak var InitialsLabel: UILabel!
    @IBOutlet weak var replyCount: UILabel!
    @IBOutlet weak var showReply: UIButton!


    @IBOutlet weak var imageLeftCostraint: NSLayoutConstraint!
    @IBOutlet weak var totalCountLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var upvoteButtonLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var initialsLabelLeftConstraints: NSLayoutConstraint!
    @IBOutlet weak var showButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var countReplyWidth: NSLayoutConstraint!
    
    
   
    @IBAction func upvoteButton(sender: AnyObject) {
        self.delegate?.upvoteButtonPressed(self , upvoteButtonPressed: sender)
    }
    @IBAction func downvoteButton(sender: AnyObject) {
        self.delegate?.downvoteButtonPressed(self , downvoteButtonPressed: sender)
    }
    @IBAction func replyButton(sender: AnyObject) {
        self.delegate?.replyButtonPressed(self , replyButtonPressed: sender)
    }
    @IBAction func moreButton(sender: AnyObject) {
        self.delegate?.moreButtonPressed(self , moreButtonPressed: sender)
    }
    @IBAction func showReplyButton(sender: AnyObject) {
        self.delegate?.showReplyButtonPressed(self , showReplyButtonPressed: sender)
    }
    @IBAction func shareButton(sender: AnyObject) {
        self.delegate?.firstShareButtonPressed(self, shareButtonPressed: sender)
    }
    @IBAction func secondShareButton(sender: AnyObject) {
        self.delegate?.secondShareButtonPressed(self, shareButtonPressed: sender)
    }
    
   
    var request: Request?
    
    var imageForCell: String? {
        didSet {
            if let lImage = imageForCell {
                
                request?.cancel()
                request = NetworkManager.sharedInstance.getImageWhihURL(NSURL(string: lImage)!, completion: { (image) in
                    if let lResponseImage = image {
                        self.userImage.image = lResponseImage
                        
                    }
                })

            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        upvoteCountLabel.layer.cornerRadius = 5
        downvoteCountLabel.layer.cornerRadius = 5
        userImage.layer.cornerRadius = 22
        userImage.layer.masksToBounds = true
        InitialsLabel.layer.cornerRadius = 22
        InitialsLabel.layer.masksToBounds = true
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
