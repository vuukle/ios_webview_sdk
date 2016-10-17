
import UIKit

class ContentWebViewCell : UITableViewCell ,UIWebViewDelegate{
    
    var delegate : ContentWebViewCell?


    
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var webViewCellHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let frameworkBundle = Bundle(for: ContentWebViewCell.self)
      
        
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getDataFromURL),
                                               name: NSNotification.Name(rawValue: "selectedPopularArticleNotification"),
                                               object: nil)
        

        
        getDataFromURL()
    }

    
    func getDataFromURL () {

        let url = URL (string: Global.articleUrl)
        let requestObj = URLRequest(url: url! as URL)
        webView.loadRequest(requestObj as URLRequest)
        webView.delegate = self
        
        // var timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: Selector("setWebViewFrame"), userInfo: nil, repeats: false)
        
        //        let date = Date().addingTimeInterval(5)
        //        let time = Timer(fireAt: date, interval: 5, target: self, selector: #selector(setWebViewFrame), userInfo: nil, repeats: false)
        //        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }

    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
//    let webV : UIWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//        self.view.addSubview(webV)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {

        
        

        
        var frame : CGRect = webView.frame
        frame.size.height = 1
        webView.frame = frame
        let fittingSize = webView.sizeThatFits(CGSize.zero)
        var size = webView.scrollView.contentSize.height

        
        webView.frame = CGRect(x: 0, y: 0, width: webView.frame.size.width, height: size)
        webViewCellHeight.constant = size
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "webViewLoaded"), object: nil)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
