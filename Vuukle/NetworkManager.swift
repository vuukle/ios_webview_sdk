

import Foundation
import Alamofire
import AlamofireImage

class NetworkManager {
    
    
    
    var jsonArray : NSDictionary?
    static let sharedInstance = NetworkManager()
    
    //MARK: Get Replies For Comment
    
    func getRepliesForComment(comment_id : String ,parent_id : String ,completion: ([GetCommentsFeed]?, NSError?) -> Void) {
        
        Alamofire.request(.GET, "\(Global.baseURL)getReplyFeed?host=\(Global.host)&article_id=00048&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&comment_id=\(comment_id)&article_id=\(Global.article_id)&parent_id=\(parent_id)&time_zone=\(Global.time_zone)" )
            .responseJSON { response in
                
                if let JSON = response.result.value as? NSArray{
                    let data : NSArray = JSON
                    var responseArray = [GetCommentsFeed]()
                    
                    for objectDict in data  {
                        responseArray.append(GetCommentsFeed.getCommentsFeedWhithArray(objectDict as! NSDictionary))
                    }
                    
                    completion(responseArray ,nil)
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                    completion(nil,response.result.error)
                }
        }
    }
    
    //MARK: Get Comment Feed
    
    func getCommentsFeed(completion: ([GetCommentsFeed]?, NSError?) -> Void) {

        Alamofire.request(.GET, "\(Global.baseURL)getCommentFeed?host=\(Global.host)&article_id=\(Global.article_id)&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&time_zone=\(Global.time_zone)&from_count=0&to_count=\(Global.countLoadCommentsInPagination)")
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.jsonArray = JSON as? NSDictionary
                    
                    let commentFeedArray : NSArray = [self.jsonArray!["comment_feed"]!]
                    Global.resource_id = "\((self.jsonArray!["resource_id"] as? Int)!)"
                    
                    var responseArray = [GetCommentsFeed]()
                    
                    
                    for feed in commentFeedArray.firstObject as! NSArray {
                        responseArray.append(GetCommentsFeed.getCommentsFeedWhithArray(feed as! NSDictionary))
                    }
                    
                    completion(responseArray, nil)
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                    completion(nil,response.result.error)
                }
                
        }
    }
    
    // MARK: Post Comment
    
    func posComment(name : String ,email : String ,comment : String,completion : (ResponseToComment? , NSError?) -> Void) {
        
        let url = "\(Global.baseURL)postComment?host=\(Global.host)&article_id=\(Global.article_id)&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&name=\(name)&email=\(email)&comment=\(comment)&tags=\(Global.tag1)&title=\(Global.title)&url=\(Global.articleUrl)"
        print(url)
        
        Alamofire.request(.GET, url)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    
                    self.jsonArray = JSON as? NSDictionary
                    
                    let respon = ResponseToComment()
                    respon.result = self.jsonArray!["result"] as? String
                    respon.comment_id = self.jsonArray!["comment_id"] as? String
                    respon.isModeration = self.jsonArray!["isModeration"] as? String
                    
                    
                    completion(respon , nil)
                    print(respon)
                    
                } else {
                    completion(nil,response.result.error)
                    print("Status cod = \(response.response?.statusCode)")
                }
        }
    }
    
    //MARK: Images
    
    func getImageWhihURL(imageURL: NSURL,completion: (UIImage?) -> Void) -> Request? {
        
        return Alamofire.request(.GET, imageURL)
            .responseImage { response in
                
                if let image = response.result.value {
                    
                    completion(image)
                } else {
                    print("Status cod = \(response)")
                }
        }
    }
    //MARK: Post Reply for Comment
    
    func postReplyForComment(name : String ,email : String ,comment : String ,comment_id : String,completion : (ResponseToComment? , NSError?) -> Void) {
        
        let url = "https://vuukle.com/api.asmx/postReply?name=\(name)&email=\(email)&comment=\(comment)&host=\(Global.host)&article_id=\(Global.article_id)&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&comment_id=\(comment_id)&resource_id=\(Global.resource_id)&url=\(Global.articleUrl)"

        Alamofire.request(.GET, url)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    
                    self.jsonArray = JSON as? NSDictionary
                    
                    let respon = ResponseToComment()
                    respon.result = self.jsonArray!["result"] as? String
                    
                    completion(respon , nil)
                    print("ID мого ріплая :\(respon.result!)")
                    
                } else {
                    completion(nil,response.result.error)
                    print("Status cod = \(response.response?.statusCode)")
                }
        }
    }
    //MARK : Set Comment Vote - Up/Down Vote
    
    func setCommentVote(name : String ,email : String ,comment_id : String ,up_down : String,completion : (String? ,NSError?) -> Void) {
        let url = "\(Global.baseURL)setCommentVote?host=\(Global.host)&article_id=\(Global.article_id)&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&comment_id=\(comment_id)&up_down=\(up_down)&name=\(name)&email=\(email)"
        
        let newUrl = url.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        Alamofire.request(.GET, newUrl)
            .responseJSON { response in
                
                
                if let JSON = response.result.value {
                    self.jsonArray = JSON as? NSDictionary
                    let respon = self.jsonArray!["result"] as? String
                    completion(respon! ,nil)
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                    completion(nil,response.result.error)
                }
        }
    }
    
    //MARK: Get More Comment Feed
    
    func getMoreCommentsFeed(from_count : Int ,to_count : Int ,completion: ([GetCommentsFeed]?, NSError?) -> Void) {
        Alamofire.request(.GET, "\(Global.baseURL)getCommentFeed?host=\(Global.host)&article_id=\(Global.article_id)&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&time_zone=\(Global.secret_key)&from_count=\(from_count)&to_count=\(to_count)")
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    self.jsonArray = JSON as? NSDictionary
                    
                    
                    let commentFeedArray : NSArray = [self.jsonArray!["comment_feed"]!]
                    
                    var responseArray = [GetCommentsFeed]()
                    
                    for feed in commentFeedArray.firstObject as! NSArray {
                        responseArray.append(GetCommentsFeed.getCommentsFeedWhithArray(feed as! NSDictionary))
                    }
                    
                    completion(responseArray, nil)
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                    completion(nil,response.result.error)
                }
                if let error  = response.result.error?.code {
                    print("error:\(error)")
                    
                }
        }
    }
    
    //MARK: Get rating
    
    func getEmoticonRating(completion: EmoteRating -> Void) {
        Alamofire.request(.GET, "\(Global.baseURL)getEmoteRating?host=\(Global.host)&api_key=\(Global.api_key)&article_id=\(Global.article_id)")
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    let ratingDictionary = JSON["emotes"]! as! NSDictionary
                    let lRating = EmoteRating.EmoteRatingWhithDictionary(ratingDictionary )
                    
                    completion(lRating)
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                }
                if let error  = response.result.error?.code {
                    print("error:\(error)")
                    
                }
        }
    }
    
    //MARK: Set rating
    
    func setRaring(article_id : String ,emote : Int,completion : ResponseToEmoteRating -> Void) {
        Alamofire.request(.GET, "\(Global.baseURL)setEmoteRating?host=\(Global.host)&api_key=\(Global.api_key)&article_id=\(article_id)&article_title=\(Global.article_title)&article_image=\(Global.article_image)&emote=\(emote)")
            .responseJSON { response in
                
                
                if let JSON = response.result.value {
                    self.jsonArray = JSON as? NSDictionary
                    
                    let respon = ResponseToEmoteRating()
                    respon.result = self.jsonArray!["result"] as? Bool
                    
                    completion(respon)
                    
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                }
                if let error  = response.result.error?.code {
                    print("error:\(error)")
                    
                }
        }
    }
    
    //MARK: Get Comment Feed
    
    func getTotalCommentsCount(completion: TotalCommentsCount -> Void) {
        Alamofire.request(.GET, "\(Global.baseURL)getCommentFeed?host=\(Global.host)&article_id=\(Global.article_id)&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&time_zone=\(Global.time_zone)&from_count=0&to_count=1")
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    self.jsonArray = JSON as? NSDictionary
                    
                    let respon = TotalCommentsCount()
                    
                    respon.comments = self.jsonArray!["comments"] as? Int
                    print(respon)
                    completion(respon)
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                }
                if let error  = response.result.error?.code {
                    print("error:\(error)")
                    
                }
        }
    }
    
    //MARK : Log Out
    
    func logOut(){
        
        Alamofire.request(.GET, "http://vuukle.com/api.asmx/logout")
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                }
                if let error  = response.result.error?.code {
                    print("error:\(error)")
                    
                }
        }
    }
}