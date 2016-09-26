

import Foundation

class Global {
    
    static let sharedInstance = Global()
    
    static var baseURL = ""
    static var article_id = ""
    static var host = ""
    static var api_key = ""
    static var secret_key = ""
    static var time_zone = ""
    static var tag1 = ""
    static var title = ""
    static var resource_id = ""
    static var article_title = ""
    static var article_image = "null"
    static var appName = ""
    static var articleUrl = ""
    static var appId = ""
    static var url = ""
    static var tag2 = ""
    static var scrolingTableView = false
    static var setYourWebContent = false
    static var defaultImageUrl = "http://3aa0b40d2aab024f527d-510de3faeb1a65410c7c889a906ce44e.r42.cf6.rackcdn.com/avatar.png"
    static var websiteUrl = "https://vuukle.com"
    
    static var showEmoticonCell = true
    static var showRefreshControl = false
    static var countLoadCommentsInPagination = 20
    static let leftConstrainCommentSize = 16
    static let leftConstrainReplySize = 75
    
    func checkAllParameters() -> Bool{
        if Global.baseURL != "" && Global.article_id != "" && Global.host != "" && Global.api_key != "" && Global.secret_key != "" && Global.time_zone != "" && Global.title != "" && Global.article_title != "" && Global.appName != "" && Global.articleUrl != "" && Global.appId != ""{
            return true
        } else {
            switch "" {
            case Global.baseURL:
                print("You have not specified BaseUrl!")
            case Global.article_id:
                print("You have not specified ArticleId!")
            case Global.host :
                print("You have not specified Host!")
            case Global.api_key:
                print("You have not specified ApiKey!")
            case Global.secret_key:
                print("You have not specified SecretKey!")
            case Global.time_zone:
                print("You have not specified TimeZone!")
            case Global.title :
                print("You have not specified Title!")
            case Global.article_title :
                print("You have not specified ArticleTitle!")
            case Global.appName :
                print("You have not specified AppName!")
            case Global.articleUrl :
                print("You have not specified ArticleUrl!")
            case Global.appId :
                print("You have not specified AppID!")
            default:
                break
            }
            return false
        }
        
    }
    
    
}