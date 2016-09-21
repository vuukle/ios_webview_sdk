

import UIKit

class ContentWebViewCell : UITableViewCell ,UIWebViewDelegate{
    
    var delegate : ContentWebViewCell?
    var height : CGFloat = 0
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var webViewCellHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let frameworkBundle = NSBundle(forClass: ContentWebViewCell.self)
        getDataFromURL()

        webView.scrollView.scrollEnabled = false
        webView.scrollView.bounces = false
        
        
    }
    
    func getDataFromURL () {
        let url = NSURL (string: Global.articleUrl);
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
        webView.delegate = self
    }
    
     func webViewDidFinishLoad(webView: UIWebView) {
        
        if let heightString = webView.stringByEvaluatingJavaScriptFromString("document.body.scrollHeight"){
             height = CGFloat(Float(heightString)!)
            print(height)
            self.webViewCellHeight.constant = height
            webView.frame.size = webView.sizeThatFits(CGSizeZero)

            
        }
        
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            print(request.URL!)
            return false
        }
        return true
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}