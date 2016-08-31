

import UIKit

protocol EmoticonCellDelegate {
    
    func firstEmoticonButtonPressed(tableCell : EmoticonCell ,firstEmoticonButtonPressed firstEmoticonButton : AnyObject )
    func secondEmoticonButtonPressed(tableCell : EmoticonCell ,secondEmoticonButtonPressed secondEmoticonButton : AnyObject )
    func thirdEmoticonButtonPressed(tableCell : EmoticonCell ,thirdEmoticonButtonPressed thirdEmoticonButton : AnyObject )
    func fourthEmoticonButtonPressed(tableCell : EmoticonCell ,fourthEmoticonButtonPressed fourthEmoticonButton : AnyObject )
    func fifthEmoticonButtonPressed(tableCell : EmoticonCell ,fifthEmoticonButtonPressed fifthEmoticonButton : AnyObject )
    func sixthEmoticonButtonPressed(tableCell : EmoticonCell ,sixthEmoticonButtonPressed sixthEmoticonButton : AnyObject )
}

class EmoticonCell: UITableViewCell ,UIWebViewDelegate {
    
    var delegate : EmoticonCellDelegate?
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var firstEmoticonImage: UIImageView!
    @IBOutlet weak var secondEmoticonImage: UIImageView!
    @IBOutlet weak var thirdEmoticonImage: UIImageView!
    @IBOutlet weak var fourthEmoticonImage: UIImageView!
    @IBOutlet weak var fifthEmoticonImage: UIImageView!
    @IBOutlet weak var sixthEmoticonImage: UIImageView!
    
    @IBOutlet weak var firstEmoticonLabel: UILabel!
    @IBOutlet weak var secondEmoticonLabel: UILabel!
    @IBOutlet weak var thirdEmoticonLabel: UILabel!
    @IBOutlet weak var fourthEmoticonLabel: UILabel!
    @IBOutlet weak var fifthEmoticonLabel: UILabel!
    @IBOutlet weak var sixthEmoticonLabel: UILabel!
    
    
    @IBOutlet weak var countFirstEmoticonLabel: UILabel!
    @IBOutlet weak var countSecondEmoticonLabel: UILabel!
    @IBOutlet weak var countThirdEmoticonLabel: UILabel!
    @IBOutlet weak var countFourthEmoticonLabel: UILabel!
    @IBOutlet weak var countFifthEmoticonLabel: UILabel!
    @IBOutlet weak var countSixthEmoticonLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    
    @IBAction func firstEmoticonButton(sender: AnyObject) {
        self.delegate?.firstEmoticonButtonPressed(self, firstEmoticonButtonPressed: sender)
        
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            print(request.URL!)
            return false
        }
        return true
    }
    
    func htmlToText(encodedString:String) -> String?
    {
        let encodedData = encodedString.dataUsingEncoding(NSUTF8StringEncoding)!
        do
        {
            return try NSAttributedString(data: encodedData, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil).string
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    @IBAction func secondEmoticonButton(sender: AnyObject) {
        self.delegate?.secondEmoticonButtonPressed(self, secondEmoticonButtonPressed: sender)
    }
    @IBAction func thirdEmoticonButton(sender: AnyObject) {
        self.delegate?.thirdEmoticonButtonPressed(self, thirdEmoticonButtonPressed: sender)
    }
    @IBAction func fourthEmoticonButton(sender: AnyObject) {
        self.delegate?.fourthEmoticonButtonPressed(self, fourthEmoticonButtonPressed: sender)
    }
    @IBAction func fifthEmoticonButton(sender: AnyObject) {
        self.delegate?.fifthEmoticonButtonPressed(self, fifthEmoticonButtonPressed: sender)
    }
    @IBAction func sixthEmoticonButton(sender: AnyObject) {
        self.delegate?.sixthEmoticonButtonPressed(self, sixthEmoticonButtonPressed: sender)
    }
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var firstEmoticonImageHeight: NSLayoutConstraint!
    @IBOutlet weak var secondEmoticonImageHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdEmoticonImageHeight: NSLayoutConstraint!
    @IBOutlet weak var fourthEmoticonImageHeight: NSLayoutConstraint!
    @IBOutlet weak var fifthEmoticonImageHeight: NSLayoutConstraint!
    @IBOutlet weak var sixthEmoticonImageHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let frameworkBundle = NSBundle(forClass: EmoticonCell.self)
        
        let url1 = frameworkBundle.URLForResource("non_secure", withExtension:"html")
        if let htmlUrl = url1 {
            let request = NSURLRequest(URL: htmlUrl)
            webView.loadRequest(request)
            webView.delegate = self
            webView.frame = UIScreen.mainScreen().bounds
            getDataFromHtml()
        }
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        let w = webView
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        let error = error
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func getDataFromHtml () {
        
        let url1 = NSBundle(forClass: EmoticonCell.self).URLForResource("non_secure", withExtension:"html")
        
        let request = NSURLRequest(URL: url1!)
        webView.loadRequest(request)
        
        if let myURL = url1 {
            var error: NSError?
            let myHTMLString = try! NSString(contentsOfURL: myURL, encoding: NSUTF8StringEncoding)
            
            if let error = error {
                print("Error : \(error)")
            } else {
                print("HTML : \(myHTMLString)")
                let url = "\(myHTMLString)"
                let firstUrl = url.stringByReplacingOccurrencesOfString("[{PAGEURL}]", withString: "\(Global.articleUrl)", options: NSStringCompareOptions.LiteralSearch, range: nil)
                let secondUrl = firstUrl.stringByReplacingOccurrencesOfString("[{APPID}]", withString: "\(Global.appId)", options: NSStringCompareOptions.LiteralSearch, range: nil)
                let newUrl = secondUrl.stringByReplacingOccurrencesOfString("[{APPNAME}]", withString: "\(Global.appName)", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                let file = "non_secure.html" //this is the file. we will write to and read from it
                
                let text = "\(newUrl)" //just a text
                
                if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
                    let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
                    
                    do {
                        try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                        print(path)
                        let request = NSURLRequest(URL: path)
                        webView.loadRequest(request)
                    }
                    catch {}
                }
                
            }
        } else {
            print("Error: \(url1) doesn't  URL")
        }
    }
}
