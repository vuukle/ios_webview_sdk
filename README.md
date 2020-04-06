# WebView guide ios

## Getting Started

WKWebView is still not available on Interface Builder. However, it is very easy to add them via code.

You will be working with our iframe URL's

Comment widget iframe looks like this:

https://cdn.vuukle.com/widgets/index.html?apiKey=c7368a34-dac3-4f39-9b7c-b8ac2a2da575&host=smalltester.000webhostapp.com&articleId=381&img=https://smalltester.000webhostapp.com/wp-content/uploads/2017/10/wallhaven-303371-825x510.jpg&title=Newpost&url=https://smalltester.000webhostapp.com/2017/12/new-post-22#1



Required parameters (for comment widget iframe):

1. apiKey - Your API key  (https://docs.vuukle.com/how-to-embed-vuukle-2.0-via-js/)
2. host - your site host (Exclude http:// or www.)
3. articleId -unique article ID
4. img - article image
5. title - article title
6. url - article URL (include http:// or www.)

Emote widget iframe looks like this:

https://cdn.vuukle.com/widgets/emotes.html?apiKey=c7368a34-dac3-4f39-9b7c-b8ac2a2da575&host=smalltester.000webhostapp.com&articleId=381&img=https://smalltester.000webhostapp.com/wp-content/uploads/2017/10/wallhaven-303371-825x510.jpg&title=New%20post%2022&url=https://smalltester.000webhostapp.com/2017/12/new-post-22#1

Required parameters (for emote widget iframe):

1. apiKey - Your API key  (https://docs.vuukle.com/how-to-embed-vuukle-2.0-via-js/)
2. host - your site host (Exclude http:// or www.)
3. articleId -unique article ID
4. img - article image
5. title - article title
6. url - article URL (include http:// or www.)

If you have any additional options to include, please contact support@vuukle.com

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
        let name = "Alex"
        let email = "email@test.com"

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

        let urlString = "https://cdn.vuukle.com/widgets/index.html?apiKey=c7368a34-dac3-4f39-9b7c-b8ac2a2da575&host=smalltester.000webhostapp.com&articleId=381&img=https://smalltester.000webhostapp.com/wp-content/uploads/2017/10/wallhaven-303371-825x510.jpg&title=Newpost&url=https://smalltester.000webhostapp.com/2017/12/new-post-22#1"

        if let url = URL(string: urlString) {
            wkWebViewWithScript.load(URLRequest(url: url))
        }
    }

    private func addWKWebViewForEmoji() {
        let height = self.view.frame.height / 3
        let wkWebViewForEmojiFrame = CGRect(x: 0, y: wkWebViewWithScript.frame.maxY, width: self.view.frame.width, height: height)
        wkWebViewWithEmoji = WKWebView(frame: wkWebViewForEmojiFrame, configuration: configuration)

        self.view.addSubview(wkWebViewWithEmoji)

        let urlString = "https://cdn.vuukle.com/widgets/emotes.html?apiKey=c7368a34-dac3-4f39-9b7c-b8ac2a2da575&host=smalltester.000webhostapp.com&articleId=381&img=https://smalltester.000webhostapp.com/wp-content/uploads/2017/10/wallhaven-303371-825x510.jpg&title=New%20post%2022&url=https://smalltester.000webhostapp.com/2017/12/new-post-22#1"

        if let url = URL(string: urlString) {
            wkWebViewWithEmoji.load(URLRequest(url: url))
        }
    }
}
```
