

import Foundation
import Alamofire
import AlamofireImage

class NetworkManager {
    
    
    
    var jsonArray : NSDictionary?
    static let sharedInstance = NetworkManager()
    
    //MARK: Get Replies For Comment
    
    func getRepliesForComment(_ comment_id : String ,parent_id : String ,completion: @escaping ([CommentsFeed]?, NSError?) -> Void) {
        
        Alamofire.request("\(Global.baseURL)getReplyFeed?host=\(Global.host)&article_id=00048&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&comment_id=\(comment_id)&article_id=\(Global.article_id)&parent_id=\(parent_id)&time_zone=\(Global.time_zone)" )
            .responseJSON { response in
                
                if let JSON = response.result.value as? NSArray{
                    let data : NSArray = JSON
                    var responseArray = [CommentsFeed]()
                    
                    for objectDict in data  {
                        responseArray.append(CommentsFeed.getCommentsFeedWhithArray(pDict: objectDict as! NSDictionary))
                    }
                    
                    completion(responseArray ,nil)
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                    completion(nil,response.result.error as NSError?)
                }
        }
    }
    
    //MARK: Get Comment Feed
    
    func getCommentsFeed(_ completion: @escaping ([CommentsFeed]?, NSError?) -> Void) {
        Alamofire.request("\(Global.baseURL)getCommentFeed?host=\(Global.host)&article_id=\(Global.article_id)&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&time_zone=\(Global.time_zone)&from_count=0&to_count=\(Global.countLoadCommentsInPagination)")
            .responseJSON { response in
                if let result = response.result.value {
                    let JSON = result
                    self.jsonArray = JSON as? NSDictionary
                    
                    let commentFeedArray : NSArray = [self.jsonArray!["comment_feed"]!]
                    Global.resource_id = "\((self.jsonArray!["resource_id"] as? Int)!)"
                    
                    var responseArray = [CommentsFeed]()
                    
                    for feed in commentFeedArray.firstObject as! NSArray {
                        responseArray.append(CommentsFeed.getCommentsFeedWhithArray(pDict: feed as! NSDictionary))
                    }
                    
                    
                    
                    completion(responseArray, nil)
                    
                } else {
                    if let statusCode = response.response?.statusCode {
                        print("Status cod = \(response.response?.statusCode)")
                        completion(nil,response.result.error as NSError?)
                    }
                    else {
                        completion([CommentsFeed](), nil)
                    }
                }
                
        }
    }
    
    // MARK: Post Comment
    
    func posComment(_ name : String ,email : String ,comment : String,completion : @escaping (ResponseToComment? , NSError?) -> Void) {
        
        let url = "\(Global.baseURL)postComment?host=\(Global.host)&article_id=\(Global.article_id)&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&name=\(name)&email=\(email)&comment=\(comment)&tags=\(Global.tag1)&title=\(Global.title)&url=\(Global.articleUrl)"
        
        Alamofire.request(url)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    
                    self.jsonArray = JSON as? NSDictionary
                    
                    let respon = ResponseToComment()
                    respon.result = self.jsonArray!["result"] as? String
                    respon.comment_id = self.jsonArray!["comment_id"] as? String
                    respon.isModeration = self.jsonArray!["isModeration"] as! String
                    let notOptionalResponse = respon.isModeration!
                    respon.isModeration = notOptionalResponse
                    completion(respon , nil)
                    
                } else {
                    completion(nil,response.result.error as NSError?)
                    print("Status cod = \(response.response?.statusCode)")
                }
        }
    }
    
    //MARK: Images
    
    func getImageWhihURL(_ imageURL: String,completion: @escaping (UIImage?) -> Void) -> Request? {
        
       // return Alamofire.request(imageURL as! NSURL as! URLRequestConvertible).responseImage { response in
            return Alamofire.request(imageURL).responseImage { response in
                if let image = response.result.value {
                    completion(image)
                } else {
                    print("Status cod = \(response)")
                }
        }
    }
    //MARK: Post Reply for Comment
    
    func postReplyForComment(_ name : String ,email : String ,comment : String ,comment_id : String,completion : @escaping (ResponseToComment? , NSError?) -> Void) {
        
        let url = "https://vuukle.com/api.asmx/postReply?name=\(name)&email=\(email)&comment=\(comment)&host=\(Global.host)&article_id=\(Global.article_id)&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&comment_id=\(comment_id)&resource_id=\(Global.resource_id)&url=\(Global.articleUrl)"
        
        Alamofire.request(url)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    
                    self.jsonArray = JSON as? NSDictionary
                    
                    let respon = ResponseToComment()
                    respon.result = self.jsonArray!["result"] as? String
                    let res = self.jsonArray?["isModeration"]
                    respon.isModeration = self.jsonArray!["isModeration"] as? String
                    if let notOptionalResponse = respon.isModeration?.lowercased() {
                        respon.isModeration = notOptionalResponse
                    } else {
                        respon.isModeration = "false"
                    }
                    completion(respon , nil)
                    print(respon)
                    
                    completion(respon , nil)
                    print("Reply ID :\(respon.result!)")
                } else {
                    completion(nil,response.result.error as NSError?)
                    print("Status cod = \(response.response?.statusCode)")
                }
        }
    }
    //MARK : Set Comment Vote - Up/Down Vote
    
    func setCommentVote(_ name : String ,email : String ,comment_id : String ,up_down : String,completion : @escaping (String? ,NSError?) -> Void) {
        let url = "\(Global.baseURL)setCommentVote?host=\(Global.host)&article_id=\(Global.article_id)&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&comment_id=\(comment_id)&up_down=\(up_down)&name=\(name)&email=\(email)"
        
        let newUrl = url.replacingOccurrences(of: " ", with: "")
        
        Alamofire.request( newUrl)
            .responseJSON { response in
                
                
                if let JSON = response.result.value {
                    self.jsonArray = JSON as? NSDictionary
                    let respon = self.jsonArray!["result"] as? String
                    completion(respon! ,nil)
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                    completion(nil,response.result.error as NSError?)
                }
        }
    }
    
    //MARK: Get More Comment Feed
    
    func getMoreCommentsFeed(_ from_count : Int ,to_count : Int ,completion: @escaping ([CommentsFeed]?, NSError?) -> Void) {
        
        var url = "\(Global.baseURL)getCommentFeed?host=\(Global.host)&article_id=\(Global.article_id)&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&time_zone=\(Global.secret_key)&from_count=\(from_count)&to_count=\(to_count)"
        Alamofire.request("\(Global.baseURL)getCommentFeed?host=\(Global.host)&article_id=\(Global.article_id)&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&time_zone=\(Global.secret_key)&from_count=\(from_count)&to_count=\(to_count)")
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    self.jsonArray = JSON as? NSDictionary
                    
                    
                    let commentFeedArray : NSArray = [self.jsonArray!["comment_feed"]!]
                    
                    var responseArray = [CommentsFeed]()
                    
                    for feed in commentFeedArray.firstObject as! NSArray {
                        responseArray.append(CommentsFeed.getCommentsFeedWhithArray(pDict: feed as! NSDictionary))
                    }
                    
                    completion(responseArray, nil)
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                    completion(nil,response.result.error as NSError?)
                }
        }
    }
    
    //MARK: Get rating
    
    func getEmoticonRating(_ completion: @escaping (EmoteRating) -> Void) {
        Alamofire.request("\(Global.baseURL)getEmoteRating?host=\(Global.host)&api_key=\(Global.api_key)&article_id=\(Global.article_id)")
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    self.jsonArray = JSON as? NSDictionary
                    
                    let ratingDictionary = self.jsonArray!["emotes"]!
                    let lRating = EmoteRating.EmoteRatingWhithDictionary((ratingDictionary as? NSDictionary)!)
                    
                    completion(lRating)
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                }
        }
    }
    
    //MARK: Set rating
    
    func setRaring(_ article_id : String ,emote : Int,completion : @escaping (ResponseToEmoteRating) -> Void) {
        
        Alamofire.request("\(Global.baseURL)setEmoteRating?host=\(Global.host)&api_key=\(Global.api_key)&article_id=\(article_id)&article_title=\(Global.article_title)&article_image=\(Global.article_image)&emote=\(emote)&url=\(Global.articleUrl)")
            .responseJSON { response in
                
                
                if let JSON = response.result.value {
                    self.jsonArray = JSON as? NSDictionary
                    
                    let respon = ResponseToEmoteRating()
                    respon.result = self.jsonArray!["result"] as? Bool
                    
                    completion(respon)
                    
                } else {
                    print("Status cod = \(response.response!.statusCode)")
                }
                
        }
    }
    
    //MARK: Get Comment Feed
    
    func getTotalCommentsCount(_ completion: @escaping (TotalCommentsCount) -> Void) {
        Alamofire.request("\(Global.baseURL)getCommentFeed?host=\(Global.host)&article_id=\(Global.article_id)&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&time_zone=\(Global.time_zone)&from_count=0&to_count=1")
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    self.jsonArray = JSON as? NSDictionary
                    
                    let respon = TotalCommentsCount()
                    
                    respon.comments = self.jsonArray!["comments"] as? Int
                    VuukleInfo.totalCommentsCount = respon.comments!
                    completion(respon)
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                }
        }
    }
    
    //MARK : Log Out
    
    func logOut(){
        
        Alamofire.request( "http://vuukle.com/api.asmx/logout")
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                }
                
        }
    }
    
    //MARK : Get most popular article
    
    
    func getMostPopularArticle(_ completion: @escaping ([MostPopularArticle]?, NSError?) -> Void) {
        //if Global.setMostPopularArticleVisible {
        Alamofire.request("https://vuukle.com/api.asmx/getRecentMostCommentedByHostByTime?bizId=\(Global.api_key)&host=\(Global.host)&tag=&hours=24&count=\(Global.countLoadMostPopularArticle)")
            .responseJSON { response in
                
                if let JSON = response.result.value {

                    let array = JSON as? NSArray

                    
                    var responseArray = [MostPopularArticle]()
                    
                    for feed in array! {
                        //First Entrance
                        responseArray.append(MostPopularArticle.getMostPopularArticleArray(pDict: feed as! NSDictionary))
                    }
                    
                    if !Global.setMostPopularArticleVisible {
                        responseArray = []
                    }
                    
                    completion(responseArray, nil)

                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                    completion(nil,response.result.error as NSError?)
                }
            }
    }
    
    func reportComment(commentID: String, name: String, email: String, completion: @escaping(Bool?, NSError?) -> Void) {
        var result = false
        
                Alamofire.request("\(Global.baseURL)flagCommentOrReply?comment_id=\(commentID)&api_key=\(Global.api_key)&article_id=\(Global.article_id)&resource_id=\(Global.resource_id)&name=\(name)&email=\(email)")
            .responseJSON { response in
                if let JSON = response.result.value {
                    self.jsonArray = JSON as? NSDictionary
                    print("\(self.jsonArray!["result"])")
                    let respon = self.jsonArray!["result"] as! String
                    
                    if respon == "true" {
                        completion(true, nil)
                    } else {
                        completion(false , nil)
                    }
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                    completion(false, response.result.error as NSError?)
                }
        }
    }
}
