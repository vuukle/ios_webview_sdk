

import Foundation

class Global {
    
    static let sharedInstance = Global()
    
    static var baseURL = "https://vuukle.com/api.asmx/"
    static var article_id = "00048"
    static var host = "vuukle.com"
    static var api_key = "777854cd-9454-4e9f-8441-ef0ee894139e"
    static var secret_key = "07115720-6848-11e5-9bc9-002590f371ee"
    static var time_zone = "Europe/Kiev"
    static var tag1 = "articleTag1"
    static var tag2 = "articleTag2"
    static var url = "http://vuukle.com/test_files/test48.html"
    static var title = "Title"
    static var resource_id = ""
    static var article_title = "myArticleTitle"
    static var article_image = "null"
    static var appName = "111"
    static var articleUrl = "http://vuukle.com"
    static var appId = "111"
    static var defaultImageUrl = "http://3aa0b40d2aab024f527d-510de3faeb1a65410c7c889a906ce44e.r42.cf6.rackcdn.com/avatar.png"
    static var websiteUrl = "https://vuukle.com"
    
    static var showEmoticonCell = true
    static var countLoadCommentsInPagination = 9
    static let leftConstrainCommentSize = 16
    static let leftConstrainReplySize = 75
    
    func checkAllParameters() -> Bool{
        if Global.baseURL != "" && Global.article_id != "" && Global.host != "" && Global.api_key != "" && Global.secret_key != "" && Global.time_zone != "" && Global.tag1 != "" && Global.tag2 != "" && Global.url != "" && Global.title != "" && Global.article_title != "" && Global.appName != "" && Global.articleUrl != "" && Global.appId != ""{
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
            case Global.tag1 :
                print("You have not specified firstTag!")
            case Global.tag2 :
                print("You have not specified secondTag!")
            case Global.url:
                print("You have not specified Url!")
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