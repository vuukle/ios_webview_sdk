
import UIKit

class ContentWebViewCell : UITableViewCell ,UIWebViewDelegate{
    
    var delegate : ContentWebViewCell?
    var height : CGFloat = 0
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var webViewCellHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let frameworkBundle = Bundle(for: ContentWebViewCell.self)
        getDataFromURL()
        
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        
        
    }
    
    func getDataFromURL () {
        let url = URL (string: Global.articleUrl);
        let requestObj = URLRequest(url: url! as URL);
        webView.loadRequest(requestObj as URLRequest);
        webView.delegate = self
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        if let heightString = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight"){
            height = CGFloat(Float(heightString)!)
            print(height)
            self.webViewCellHeight.constant = height
            webView.frame.size = webView.sizeThatFits(CGSize.zero)
        }
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            print(request.url!)
            return false
        }
        return true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
