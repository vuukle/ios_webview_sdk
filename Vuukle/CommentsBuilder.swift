
import Foundation
import UIKit




public class VuukleCommentsBuilder : NSObject {
    

   public override init() {
    super.init()
    
    }
    
    
    /**
     Set true for visible emote rating!
     */
    public func setVuukleEmoteVisible(isVisible : Bool) -> VuukleCommentsBuilder {
        Global.showEmoticonCell = isVisible
        
        return self
    }
    
    /**
     Set true for visible refres!
     */
    public func setVuukleRefreshVisible(isVisible : Bool) -> VuukleCommentsBuilder {
        Global.showRefreshControl = isVisible
        return self
    }
    
    /**
     Set true for visible your WebContent from Aticle URL!
     */
    public func addWebViewArticleURL(isVisible : Bool) -> VuukleCommentsBuilder {
        Global.setYourWebContent = isVisible
        return self
    }
    
    public func scrolingTableView(scrol : Bool) -> VuukleCommentsBuilder {
        Global.scrolingTableView = scrol
        return self
    }
    
    /**
     Required field !
     
     For example: "https://vuukle.com/api.asmx/"
     */
    public func setVuukleBaseUrl(url : String) -> VuukleCommentsBuilder {
        Global.baseURL = url
        return self
    }
    
    /**
     Get id from Vuukle site. Every article has unique id!
     */
    public func setVuukleArticleId(articleId : String) -> VuukleCommentsBuilder{
        Global.article_id = articleId
        return self
    }
    
    /**
     Required field !
     
     Set host for Api. Host - this is domain of the publisher’s site(e.g. indianexpress.com, thehindu.com etc.).
     
     For example: You are the owner of indianexpress.com and have own app where want’s to setup this library,
     so when library installed on your app, You should paste domain for ‘host’ property without http:// or https:// or www.
     
     */
    public func setVuukleHost(host : String) -> VuukleCommentsBuilder{
        Global.host = host
        return self
    }
    
    /**
     Required field!
     
     Set your API key for API. To get API KEY you need :
     
     1) Sign in to dashboard thouth vuukle.com
     2) Navigate to domain from home page of dashboard (first page after signing in)
     3) Choose in menu Integration, then API Docs from the dropdown
     4) Then you will be able to see API and secret keys
     
     ---- or ----
     
     1) Sign in to dashboard thouth vuukle.com
     2) after signing in, in header you can find ‘Integration’ click -> choose API docs in the drop-down.
     
     */
    public func setVuukleApiKey(apiKey : String) -> VuukleCommentsBuilder{
        Global.api_key = apiKey
        return self
    }
    
    /**
     Required field!
     
     Set your API key for API. To get SECRET KEY you need :
     
     1) Sign in to dashboard through vuukle.com
     2) Navigate to domain from home page of dashboard (first page after signing in)
     3) Choose in menu Integration, then API Docs from the dropdown
     4) Then you will be able to see api and SECRET keys
     
     ---- or ----
     
     1) Sign in to dashboard thouth vuukle.com
     2) after signing in, in header you can find ‘Integration’ click -> choose API docs in the drop-down.
     
     */
    public func setVuukleSecretKey(secretKey : String) -> VuukleCommentsBuilder{
        Global.secret_key = secretKey
        return self
    }
    
    
    /**
     Required field!
     
     Timezone from this resource:
     
     <url>https://en.wikipedia.org/wiki/List_of_tz_database_time_zones</url>
     */
    public func setVuukleTimeZone(timeZone : String) -> VuukleCommentsBuilder{
        Global.time_zone = timeZone
        return self
    }
    
    /**
     Optional field!
     
     First Tag will be unique for each page where comment box opens.
     
     These properties You need to fill by yourself.
     
     For example: You are on the main app page with articles list ->
     you are choosing article ->
     it opens and our library should have unique properties
     for each article like URL, TAGS, TITLE.
     */
    public func firstVuukleTag(tag : String) -> VuukleCommentsBuilder{
        Global.tag1 = tag.stringByReplacingOccurrencesOfString(" ", withString: "").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        return self
    }
    
    /**
     Required field!
     
     Second Tag will be unique for each page where comment box opens.
     
     These properties You need to fill by yourself.
     
     For example: You are on the main app page with articles list ->
     you are choosing article ->
     it opens and our library should have unique properties
     for each article like URL, TAGS, TITLE.
     */
    @available(*, deprecated=1.0, obsoleted=2.0, message="deprecated !")  public func secondVuukleTag(tag : String) -> VuukleCommentsBuilder{
        Global.tag2 = tag.stringByReplacingOccurrencesOfString(" ", withString: "").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        return self
    }
    
    /**
     Required field!
     
     For example: "http:vuukle.com/test_files/test48.html"
     */
    @available(*, deprecated=1.0, obsoleted=2.0, message="deprecated !")  public func setVuukleUrl(url : String) -> VuukleCommentsBuilder{
        Global.url = url
        return self
    }
    
    /**
     Required field!
     
     Set your Title.
     */
    public func setVuukleTitle(title : String) -> VuukleCommentsBuilder{
        Global.title = title.stringByReplacingOccurrencesOfString(" ", withString: "").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        return self
    }
    
    /**
     Required field!
     
     Set your Article Title.
     */
    public func setVuukleArticleTitle (articleTitle : String) -> VuukleCommentsBuilder{
        Global.article_title = articleTitle.stringByReplacingOccurrencesOfString(" ", withString: "").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        return self
    }
    
    /**
     Required field!
     
     Set your application name.
     */
    public func setAppName (appName : String) -> VuukleCommentsBuilder{
        Global.appName = appName.stringByReplacingOccurrencesOfString(" ", withString: "").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        return self
    }
    
    /**
     Required field!
     
     Set your article url.
     */
    public func setArticleUrl (articleUrl : String) -> VuukleCommentsBuilder{
        Global.articleUrl = articleUrl
        return self
    }
    
    /**
     Required field!
     
     Set your application id.
     */
    public func setAppID (appID : String) -> VuukleCommentsBuilder{
        Global.appId = appID
        return self
    }
    
    /**
     Optional field!
     
     By default, 10 items!
     */
    public func setVuuklePaginationCount(paginationCount : Int) -> VuukleCommentsBuilder{
        Global.countLoadCommentsInPagination = paginationCount
        return self
    }
    
    /**
     Required field!
     
     Set your View name!For example: "myView".
     
     ---- or ----
     
     Set : "self.view"
     */
    public func buildVuukle(view : UIView) {
        let bundle = NSBundle(forClass: CommentViewController.self)
        let vc = UIStoryboard.init(name: "Main", bundle: bundle).instantiateViewControllerWithIdentifier("CommentViewController") as! CommentViewController
        view.frame = vc.view.frame
        
        
        
        view.addSubview(vc.view)

        
    }
    
 
}