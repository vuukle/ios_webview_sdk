
import UIKit
import Alamofire

protocol MostPopularArticleCellDelegate {
    
    func showArticleButtonPressed(_ tableCell : MostPopularArticleCell , _ showArticle : AnyObject )
    
}

class MostPopularArticleCell: UITableViewCell {
    
    var delegate : MostPopularArticleCellDelegate?
    
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var aboutArticleLabel: UILabel!
    
    @IBOutlet weak var showButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.commentsCount.layer.masksToBounds = true
        self.commentsCount.layer.cornerRadius = 5
        self.articleImage.layer.masksToBounds = true
        self.articleImage.layer.cornerRadius = 15
        // Initialization code
    }
    
    var request: Request?
    
    var imageForCell: String? {
        didSet {
            if let lImageURL = imageForCell {
                
                NetworkManager.sharedInstance.getImageWhihURL(lImageURL, completion: { (image, error) in
                    
                    if error == nil && image != nil {
                      
                      self.articleImage.image = image
                      self.articleImage.layer.cornerRadius = 6
                      self.articleImage.layer.masksToBounds = true
                      
                    } else {
                      self.articleImage.image = UIImage(named: "PlaceholderArticle", in: Bundle(for: CommentViewController.self), compatibleWith: nil)
                      self.articleImage.layer.cornerRadius = 6
                      self.articleImage.layer.masksToBounds = true
                  }
                })
            }
        }
    }
    
    @IBAction func showArticleButton(_ sender: AnyObject) {
        self.delegate?.showArticleButtonPressed(self, sender)
        
        showButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [unowned self] in
            self.showButton.isEnabled = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
