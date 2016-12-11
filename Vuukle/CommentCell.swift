

import UIKit
import Alamofire

let STOP_ALL_PROGRESS_KEY = Notification.Name(rawValue: "STOP_ALL_PROGRESS_KEY")


protocol CommentCellDelegate {
    
    func upvoteButtonPressed(_ tableCell : CommentCell ,upvoteButtonPressed upvoteButton : AnyObject )
    func downvoteButtonPressed(_ tableCell : CommentCell ,downvoteButtonPressed downvoteButton : AnyObject )
    func replyButtonPressed(_ tableCell : CommentCell ,replyButtonPressed replyButton : AnyObject )
    func moreButtonPressed(_ tableCell : CommentCell ,moreButtonPressed moreButton : AnyObject )
    func showReplyButtonPressed(_ tableCell : CommentCell ,showReplyButtonPressed showReplyButton : AnyObject )
    func shareButtonPressed(_ tableCell : CommentCell ,shareButtonPressed shareButton : AnyObject )
}

class CommentCell: UITableViewCell {
    
    var delegate : CommentCellDelegate?
    var leftCostraint = 16
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
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
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var upVoteButton: UIButton!
    @IBOutlet weak var downVoteButton: UIButton!
    
    @IBOutlet weak var imageLeftCostraint: NSLayoutConstraint!
    @IBOutlet weak var totalCountLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var upvoteButtonLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var initialsLabelLeftConstraints: NSLayoutConstraint!
    @IBOutlet weak var showButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var countReplyWidth: NSLayoutConstraint!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    
    @IBAction func upvoteButton(_ sender: AnyObject) {
        
        upVoteButton.isEnabled = false
        
        self.delegate?.upvoteButtonPressed(self , upvoteButtonPressed: sender)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            self.upVoteButton.isEnabled = true
        }
    }
    
    @IBAction func downvoteButton(_ sender: AnyObject) {
        
        downVoteButton.isEnabled = false
        
        self.delegate?.downvoteButtonPressed(self , downvoteButtonPressed: sender)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            self.downVoteButton.isEnabled = true
        }
    }
    
    @IBAction func replyButton(_ sender: AnyObject) {
        
        replyButton.isEnabled = false
        
        self.delegate?.replyButtonPressed(self , replyButtonPressed: sender)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            self.replyButton.isEnabled = true
        }
    }
    
    @IBAction func moreButton(_ sender: AnyObject) {
        
        reportButton.isEnabled = false
        
        self.delegate?.moreButtonPressed(self , moreButtonPressed: sender)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            self.reportButton.isEnabled = true
        }
    }
    
    @IBAction func showReplyButton(_ sender: AnyObject) {
        
        showReply.isEnabled = false
        
        self.delegate?.showReplyButtonPressed(self , showReplyButtonPressed: sender)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [unowned self] in
            self.showReply.isEnabled = true
        }
    }
    
    @IBAction func shareButton(_ sender: AnyObject) {
        self.delegate?.shareButtonPressed(self, shareButtonPressed: sender)
    }
    
    var request: Request?
    
    var imageForCell: String? {
        didSet {
            if let lImage = imageForCell {
                
                request?.cancel()
                request = NetworkManager.sharedInstance.getImageWhihURL(lImage, completion: { (image) in
                    if let lResponseImage = image {
                        self.userImage.layer.masksToBounds = true
                        self.userImage.layer.cornerRadius = 22
                        self.userImage.image = lResponseImage
                        
                    }
                })
                
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        upvoteCountLabel.layer.cornerRadius = 5
        replyCount.layer.cornerRadius = 4
        replyCount.layer.masksToBounds = true
        userImage.layer.cornerRadius = 22
        userImage.layer.masksToBounds = true
        initialsLabel.layer.cornerRadius = 22
        initialsLabel.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(forName: STOP_ALL_PROGRESS_KEY, object: nil, queue: nil) { notification in
            
            
            self.hideProgress()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func showProgress() {
        progressIndicator.startAnimating()
        progressIndicator.isHidden = false
        self.alpha = 0.4
    }
    
    func hideProgress() {
        progressIndicator.isHidden = true
        progressIndicator.stopAnimating()
        self.alpha = 1
    }
    
}
