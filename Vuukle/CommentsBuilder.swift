
import Foundation
import UIKit

open class VuukleCommentsBuilder : NSObject {
    
    public override init() { }
    
    /**
     Set true for visible emote rating!
     */
    open func setVuukleEmoteVisible(_ isVisible : Bool) -> VuukleCommentsBuilder {
        Global.showEmoticonCell = isVisible
        return self
    }
    
    /**
     Set true for visible emote rating!
     */
    open func setVuukleMostPopularArticleVisible(_ isVisible : Bool) -> VuukleCommentsBuilder {
        Global.setMostPopularArticleVisible = isVisible
        return self
    }
    
    /**
     Set true for visible Ads!
     */
    open func setVuukleAdsVisible(_ isVisible : Bool) -> VuukleCommentsBuilder {
        Global.setAdsVisible = isVisible
        return self
    }
    
    /**
     Set true for visible refres!
     */
    open func setVuukleRefreshVisible(_ isVisible : Bool) -> VuukleCommentsBuilder {
        Global.showRefreshControl = isVisible
        return self
    }
  
    /**
     Set edge inserts
    */
    open func setVuukleEdgeInserts(_ edgeInserts: UIEdgeInsets) -> VuukleCommentsBuilder {
      Global.edgeInserts = edgeInserts
      return self
    }
  
    /**
     Set true for visible your WebContent from Aticle URL!
     */
    open func addWebViewArticleURL(_ isVisible : Bool) -> VuukleCommentsBuilder {
        Global.setYourWebContent = isVisible
        return self
    }
    
    /**
     Optional field !
     
     Set true for the possibility of scroll Vuukle Table View!
     For example: If you need to add a Vuukle comments on Scroll View near your content set false!
     */
    public func setScrolingVuukleTableView(_ scroll : Bool) -> VuukleCommentsBuilder {
        Global.scrolingTableView = scroll
        return self
    }
    
    
    /**
     Get id from Vuukle site. Every article has unique id!
     */
    open func setVuukleArticleId(_ articleId : String) -> VuukleCommentsBuilder{
        Global.article_id = articleId
        return self
    }
    
    /**
     Required field !
     
     Set host for Api. Host - this is domain of the publisher’s site(e.g. indianexpress.com, thehindu.com etc.).
     
     For example: You are the owner of indianexpress.com and have own app where want’s to setup this library,
     so when library installed on your app, You should paste domain for ‘host’ property without http:// or https:// or www.
     
     */
    open func setVuukleHost(_ host : String) -> VuukleCommentsBuilder{
      
        let host = host.lowercased()
        Global.host = ParametersConstructor.sharedInstance.encodingString(host)
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
    open func setVuukleApiKey(_ apiKey : String) -> VuukleCommentsBuilder{
        Global.api_key = ParametersConstructor.sharedInstance.encodingString(apiKey)
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
    open func setVuukleSecretKey(_ secretKey : String) -> VuukleCommentsBuilder{
        Global.secret_key = ParametersConstructor.sharedInstance.encodingString(secretKey)
        return self
    }
    
    
    /**
     Required field!
     
     Timezone from this resource:
     
     <url>https://en.wikipedia.org/wiki/List_of_tz_database_time_zones</url>
     */
    open func setVuukleTimeZone(_ timeZone : String) -> VuukleCommentsBuilder{
        Global.time_zone = ParametersConstructor.sharedInstance.encodingString(timeZone)
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
    open func firstVuukleTag(_ tag : String) -> VuukleCommentsBuilder{
        Global.tag1 = ParametersConstructor.sharedInstance.encodingString(tag)
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
    @available(*, deprecated: 1.0, obsoleted: 2.0, message: "deprecated !")  open func secondVuukleTag(_ tag : String) -> VuukleCommentsBuilder{
        Global.tag2 = ParametersConstructor.sharedInstance.encodingString(tag)
        return self
    }
    
    /**
     Required field!
     
     For example: "http:vuukle.com/test_files/test48.html"
     */
    @available(*, deprecated: 1.0, obsoleted: 2.0, message: "deprecated !")  open func setVuukleUrl(_ url : String) -> VuukleCommentsBuilder{
        Global.url = ParametersConstructor.sharedInstance.encodingString(url)
        return self
    }
    
    /**
     Required field!
     
     Set your Title.
     */
    open func setVuukleTitle(_ title : String) -> VuukleCommentsBuilder{
        Global.title = ParametersConstructor.sharedInstance.encodingString(title)
        return self
    }
    
    /**
     Required field!
     
     Set your Article Title.
     */
    open func setVuukleArticleTitle (_ articleTitle : String) -> VuukleCommentsBuilder{
        Global.article_title = articleTitle
        return self
    }
    
    /**
     Required field!
     
     Set your application name.
     */
    open func setAppName (_ appName : String) -> VuukleCommentsBuilder{
        Global.appName = ParametersConstructor.sharedInstance.encodingString(appName)
        return self
    }
    
    /**
     Required field!
     
     Set your article url.
     */
    open func setArticleUrl (_ articleUrl : String) -> VuukleCommentsBuilder{
        Global.articleUrl = ParametersConstructor.sharedInstance.encodingString(articleUrl)
        return self
    }
    
    /**
     Required field!
     
     Set your application id.
     */
    open func setAppID (_ appID : String) -> VuukleCommentsBuilder{
        Global.appId = ParametersConstructor.sharedInstance.encodingString(appID)
        return self
    }
    
    /**
     Optional field!
     
     By default, 10 items!
     */
    open func setVuuklePaginationCount(_ paginationCount : Int) -> VuukleCommentsBuilder{
        Global.countLoadCommentsInPagination = paginationCount
        return self
    }
    
    /**
     Optional field!
     
     By default, 10 items!
     */
    open func setVuukleMostPopularArticleCount(_ count : Int) -> VuukleCommentsBuilder{
        Global.countLoadMostPopularArticle = count
        return self
    }
    
    /**
     Required field!
     
     Set your View name!For example: "myView".
     
     ---- or ----
     
     Set : "self.view"
     */
    open func buildVuukle(_ view : UIView){
      
        let bundle = Bundle(for: CommentViewController.self)
        let vc = UIStoryboard.init(name: "Main", bundle: bundle).instantiateViewController(withIdentifier: "CommentViewController")
      
        view.frame = vc.view.frame
        view.addSubview(vc.view)
    }
    
    /*
     Function which returns Height of Vuukle
     
     We recommend to work with notifications!
     */
    
    open static func getHeight() -> CGFloat{
        return VuukleInfo.getCommentsHeight()
    }
    
    /*
     Function which returns count of comments under current article
     */
    
    open static func getCommentsCount() -> Int{
        return VuukleInfo.getCommentsCount()
    }

    
    /*
     Function which allows you to log in users
     
     You can use it when user logs in your application
     */
    
    open static func setUserInfo(name: String, email: String) {
        ParametersConstructor.sharedInstance.setUserInfo(name: name, email: email)
        //CommentViewController.shared?.reloadAddCommentField()
    }
    
    /*
     Function to set OAuth tokens for Twitter
     */
    open static func setTitterOAuth(token: String, verifier: String) {
        
        SocialNetworksTracker.sharedTracker.setTitterOAuth(token: token, verifier: verifier)
    }
    
}
