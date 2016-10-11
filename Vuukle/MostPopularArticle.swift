

import Foundation

class MostPopularArticle {
    
    var articleId : String?
    var count : String?
    var heading : String?
    var imgUrl : String?
    var articleUrl : String?
    var ts : String?
    var api_key : String?
    var host : String?
    var seoURL : String?
    
    static func getMostPopularArticleArray(pDict : NSDictionary) -> MostPopularArticle {
        
        let lMostPopularArticle = MostPopularArticle()
        lMostPopularArticle.api_key = pDict["api_key"] as? String ?? ""
        lMostPopularArticle.count = pDict["count"] as? String ?? ""
        lMostPopularArticle.articleId = pDict["articleId"] as? String ?? ""
        lMostPopularArticle.heading = pDict["heading"] as? String ?? ""
        lMostPopularArticle.imgUrl = pDict["img"] as? String ?? ""
        lMostPopularArticle.articleUrl = pDict["url"] as? String ?? ""
        lMostPopularArticle.ts = pDict["ts"] as? String ?? ""
        lMostPopularArticle.host = pDict["host"] as? String ?? ""
        lMostPopularArticle.seoURL = pDict["seoURL"] as? String ?? ""
        
        return lMostPopularArticle
    }
    
}
