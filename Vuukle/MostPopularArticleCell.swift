
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
            if let lImage = imageForCell {
                
                request?.cancel()
                request = NetworkManager.sharedInstance.getImageWhihURL(lImage, completion: { (image) in
                    if let lResponseImage = image {
                        self.articleImage.image = lResponseImage
                    }
                })
                
            }
        }
    }
    
    @IBAction func showArticleButton(_ sender: AnyObject) {
        self.delegate?.showArticleButtonPressed(self, sender)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
