

import UIKit

protocol AddLoadMoreCellDelegate {
    
    func loadMoreButtonPressed(tableCell : LoadMoreCell ,loadMoreButtonPressed loadMoreButton : AnyObject )
    func openVuukleButtonButtonPressed(tableCell : LoadMoreCell ,openVuukleButtonPressed openVuukleButton : AnyObject )
}

class LoadMoreCell: UITableViewCell {
    var delegate : AddLoadMoreCellDelegate?
    
    @IBOutlet weak var loadMore: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var heightButton: NSLayoutConstraint!
    @IBOutlet weak var heightActivitiIndicator: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
        loadMore.layer.cornerRadius = 5
        
    }
    
    @IBAction func openVuukleButton(sender: AnyObject) {
        self.delegate?.openVuukleButtonButtonPressed(self, openVuukleButtonPressed: sender)
    }
    
    @IBAction func loadMoreButton(sender: AnyObject) {
        
        self.delegate?.loadMoreButtonPressed(self, loadMoreButtonPressed: sender)
        activityIndicator.hidden = false
        activityIndicator.color? = UIColor.grayColor()
        activityIndicator.startAnimating()
        
        loadMore.hidden = true
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
