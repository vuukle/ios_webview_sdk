

import UIKit

protocol AddLoadMoreCellDelegate {
    
    func loadMoreButtonPressed(_ tableCell : LoadMoreCell ,loadMoreButtonPressed loadMoreButton : AnyObject )
    func openVuukleButtonButtonPressed(_ tableCell : LoadMoreCell ,openVuukleButtonPressed openVuukleButton : AnyObject )
}

class LoadMoreCell: UITableViewCell {
    var delegate : AddLoadMoreCellDelegate?
    
    @IBOutlet weak var loadMore: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var heightButton: NSLayoutConstraint!
    @IBOutlet weak var heightActivitiIndicator: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        loadMore.layer.cornerRadius = 5
        
    }
    
    @IBAction func openVuukleButton(_ sender: AnyObject) {
        self.delegate?.openVuukleButtonButtonPressed(self, openVuukleButtonPressed: sender)
    }
    
    @IBAction func loadMoreButton(_ sender: AnyObject) {
        
        self.delegate?.loadMoreButtonPressed(self, loadMoreButtonPressed: sender)
        activityIndicator.isHidden = false
        activityIndicator.color? = UIColor.gray
        activityIndicator.startAnimating()
        
        loadMore.isHidden = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
