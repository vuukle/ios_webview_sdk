

import UIKit

class WebViewCell: UITableViewCell ,UIWebViewDelegate {
    var delegate : WebViewCell?
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var webViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let frameworkBundle = Bundle(for: WebViewCell.self)
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        
        let url1 = frameworkBundle.url(forResource: "non_secure", withExtension:"html")
        if let htmlUrl = url1 {
            let request = NSURLRequest(url: htmlUrl)
            webView.loadRequest(request as URLRequest)
            webView.delegate = self
            webView.frame = UIScreen.main.bounds
            getDataFromHtml()
        }
        
        if Global.setAdsVisible == true {
            webViewHeight.constant = 120
        } else {
            webViewHeight.constant = 0
        }
    }
    
    func getDataFromHtml () {
        let url1 = Bundle(for: WebViewCell.self).url(forResource: "non_secure", withExtension:"html")
        let myHTMLString = try! NSString(contentsOf: url1!, encoding: String.Encoding.utf8.rawValue)
        let url = "\(myHTMLString)"
        let firstUrl = url.replacingOccurrences(of: "[{PAGEURL}]", with: "\(Global.articleUrl)", options: NSString.CompareOptions.literal, range: nil)
        let secondUrl = firstUrl.replacingOccurrences(of: "[{APPID}]", with: "\(Global.appId)", options: NSString.CompareOptions.literal, range: nil)
        let newUrl = secondUrl.replacingOccurrences(of: "[{APPNAME}]", with: "\(Global.appName)", options: NSString.CompareOptions.literal, range: nil)
        
        let file = "non_secure.html"
        
        let text = "\(newUrl)"
        
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).appendingPathComponent(file)
            
            do {
                try text.write(to: path!, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {}
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            print(request.url!)
            return false
        }
        return true
    }
    
    func htmlToText(encodedString:String) -> String?
    {
        let encodedData = encodedString.data(using: String.Encoding.utf8)!
        do
        {
            return try NSAttributedString(data: encodedData, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:String.Encoding.utf8], documentAttributes: nil).string
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
