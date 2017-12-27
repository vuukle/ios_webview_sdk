# WebView guide ios

## Getting Started

WKWebView is still not available on Interface Builder. However, it is very easy to add them via code.

### Example:

```
import WebKit

override func viewDidLoad() {
    super.viewDidLoad()

    // MARK: - Create WKWebView with configuration

    let configuration = WKWebViewConfiguration()
    let wkWebView = WKWebView(frame: "your frame", configuration: configuration)
    
    // MARk: - Add WKWebView to main view
    
    self.view.addSubview(wkWebView)
    
    let urlName = "yourUrl"
    
    if let url = URL(string: urlName) {
        wkWebView.load(URLRequest(url: url))
    }
    
}
```

### Example for clear cookie:

```
private func clearAllCookies() {
    let cookieJar = HTTPCookieStorage.shared

    for cookie in cookieJar.cookies! {
        cookieJar.deleteCookie(cookie)
    }
}

private func clearCookiesFromSpecificUrl(yourUrl: String) {
    let cookieStorage: HTTPCookieStorage = HTTPCookieStorage.shared
    let cookies = cookieStorage.cookies(for: URL(string: yourUrl)!)
    for cookie in cookies! {
        cookieStorage.deleteCookie(cookie as HTTPCookie)
    }
}
```

### Full example:

```
import UIKit
import WebKit

final class ViewController: UIViewController {

    @IBOutlet weak var someTextLabel: UILabel!

    private var wkWebViewWithScript: WKWebView!
    private var wkWebViewWithEmoji: WKWebView!
    private let configuration = WKWebViewConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()

        addWKWebViewForScript()
        addWKWebViewForEmoji()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func addWKWebViewForScript() {
        let name = "Ross"
        let email = "email@sda"

        let contentController = WKUserContentController()
        let userScript = WKUserScript(
            source: "signInUser('\(name)', '\(email)')",
            injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
            forMainFrameOnly: true
        )
        contentController.addUserScript(userScript)
        configuration.userContentController = contentController

        let height = self.view.frame.height / 3
        let wkWebViewWithScriptFrame = CGRect(x: 0, y: someTextLabel.frame.maxY, width: self.view.frame.width, height: height)
        wkWebViewWithScript = WKWebView(frame: wkWebViewWithScriptFrame, configuration: configuration)

        self.view.addSubview(wkWebViewWithScript)

        let urlString = "https://cdn.vuukle.com/widgets/index.html?apiKey=c7368a34-dac3-4f39-9b7c-b8ac2a2da575&darkMode=false&host=smalltester.000webhostapp.com&articleId=381&img=https://smalltester.000webhostapp.com/wp-content/uploads/2017/10/wallhaven-303371-825x510.jpg&title=New&post&22&url=https://smalltester.000webhostapp.com/2017/12/new-post-22&emotesEnabled=true&firstImg=&secondImg=&thirdImg=&fourthImg=&fifthImg=&sixthImg=&refHost=smalltester.000webhostapp.com&authors=JTIySlRWQ0pUZENKVEl5Ym1GdFpTVXlNam9sTWpBbE1qSmhaRzFwYmlVeU1pd2xNakFsTWpKbGJXRnBiQ1V5TWpvbE1qSWxNaklzSlRJeWRIbHdaU1V5TWpvbE1qQWxNakpwYm5SbGNtNWhiQ1V5TWlVM1JDVTFSQT09JTIy&tags=&lang=en&l_d=false&totWideImg=false&articlesProtocol=http&color=108ee9&hideArticles=false&d=false&maxChars=3000&commentsToLoad=5&toxicityLimit=80&gr=false&customText=%7B%7D&hideCommentBox=false"

        if let url = URL(string: urlString) {
            wkWebViewWithScript.load(URLRequest(url: url))
        }
    }

    private func addWKWebViewForEmoji() {
        let height = self.view.frame.height / 3
        let wkWebViewForEmojiFrame = CGRect(x: 0, y: wkWebViewWithScript.frame.maxY, width: self.view.frame.width, height: height)
        wkWebViewWithEmoji = WKWebView(frame: wkWebViewForEmojiFrame, configuration: configuration)

        self.view.addSubview(wkWebViewWithEmoji)

        let urlString = "https://cdn.vuukle.com/widgets/emotes.html?apiKey=c7368a34-dac3-4f39-9b7c-b8ac2a2da575&darkMode=false&host=smalltester.000webhostapp.com&articleId=381&img=https://smalltester.000webhostapp.com/wp-content/uploads/2017/10/wallhaven-303371-825x510.jpg&title=New&post&22&url=https://smalltester.000webhostapp.com/2017/12/new-post-22&emotesEnabled=true&firstImg=&secondImg=&thirdImg=&fourthImg=&fifthImg=&sixthImg=&totWideImg=false&articlesProtocol=http&hideArticles=false&disable=[]&iconsSize=70&first=HAPPY&second=INDIFFERENT&third=AMUSED&fourth=EXCITED&fifth=ANGRY&sixth=SAD&customText=%7B%7D"

        if let url = URL(string: urlString) {
            wkWebViewWithEmoji.load(URLRequest(url: url))
        }
    }
}
```
