

import UIKit
import Alamofire

protocol CommentCellDelegate {
    
    func upvoteButtonPressed(_ tableCell : CommentCell ,upvoteButtonPressed upvoteButton : AnyObject )
    func downvoteButtonPressed(_ tableCell : CommentCell ,downvoteButtonPressed downvoteButton : AnyObject )
    func replyButtonPressed(_ tableCell : CommentCell ,replyButtonPressed replyButton : AnyObject )
    func moreButtonPressed(_ tableCell : CommentCell ,moreButtonPressed moreButton : AnyObject )
    func showReplyButtonPressed(_ tableCell : CommentCell ,showReplyButtonPressed showReplyButton : AnyObject )
    func firstShareButtonPressed(_ tableCell : CommentCell ,shareButtonPressed shareButton : AnyObject )
    func secondShareButtonPressed(_ tableCell : CommentCell ,shareButtonPressed shareButton : AnyObject )
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
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var replyCount: UILabel!
    @IBOutlet weak var showReply: UIButton!
    
    
    @IBOutlet weak var imageLeftCostraint: NSLayoutConstraint!
    @IBOutlet weak var totalCountLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var upvoteButtonLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var initialsLabelLeftConstraints: NSLayoutConstraint!
    @IBOutlet weak var showButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var countReplyWidth: NSLayoutConstraint!
    
    
    
    @IBAction func upvoteButton(_ sender: AnyObject) {
        self.delegate?.upvoteButtonPressed(self , upvoteButtonPressed: sender)
    }
    @IBAction func downvoteButton(_ sender: AnyObject) {
        self.delegate?.downvoteButtonPressed(self , downvoteButtonPressed: sender)
    }
    @IBAction func replyButton(_ sender: AnyObject) {
        self.delegate?.replyButtonPressed(self , replyButtonPressed: sender)
    }
    @IBAction func moreButton(_ sender: AnyObject) {
        self.delegate?.moreButtonPressed(self , moreButtonPressed: sender)
    }
    @IBAction func showReplyButton(_ sender: AnyObject) {
        self.delegate?.showReplyButtonPressed(self , showReplyButtonPressed: sender)
    }
    @IBAction func shareButton(_ sender: AnyObject) {
        self.delegate?.firstShareButtonPressed(self, shareButtonPressed: sender)
    }
    @IBAction func secondShareButton(_ sender: AnyObject) {
        self.delegate?.secondShareButtonPressed(self, shareButtonPressed: sender)
    }
    
    
    var request: Request?
    
    var imageForCell: String? {
        didSet {
            if let lImage = imageForCell {
                
                request?.cancel()
                request = NetworkManager.sharedInstance.getImageWhihURL(URL(string: lImage)! as NSURL, completion: { (image) in
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
        initialsLabel.layer.cornerRadius = 22
        initialsLabel.layer.masksToBounds = true
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
