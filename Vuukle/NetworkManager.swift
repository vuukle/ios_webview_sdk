

import Foundation
import Alamofire
import AlamofireImage

class NetworkManager {
  
  var counter = 0
  var jsonArray : NSDictionary?
  static let sharedInstance = NetworkManager()
  
  //MARK: Get Replies For Comment
  
  func getRepliesForComment(_ comment_id : String ,parent_id : String ,completion: @escaping ([CommentsFeed]?, NSError?) -> Void) {
    
    let url = "\(Global.baseURL as String)getReplyFeed?host=\(Global.host as String)&article_id=00048&api_key=\(Global.api_key as String)&secret_key=\(Global.secret_key as String)&comment_id=\(comment_id as String)&article_id=\(Global.article_id as String)&parent_id=\(parent_id as String)&time_zone=\(Global.time_zone as String)"
    
    print("\n\(url)\n")
    
    Alamofire.request(url).responseJSON { response in
      
      if let JSON = response.result.value as? NSArray{
        
        let data : NSArray = JSON
        var responseArray = [CommentsFeed]()
        
        for objectDict in data  {
          
          responseArray.append(CommentsFeed.getCommentsFeedWhithArray(pDict: objectDict as! NSDictionary))
        }
        responseArray = responseArray.reversed()
        
        completion(responseArray ,nil)
      } else {
        print("Status cod = \(response.response?.statusCode)")
        completion(nil,response.result.error as NSError?)
      }
    }
  }
  
  //MARK: Get Comment Feed
  
  func getCommentsFeed(_ completion: @escaping ([CommentsFeed]?, NSError?) -> Void) {
    
    Alamofire.request("\(Global.baseURL as String)getCommentFeed?host=\(Global.host as String)&article_id=\(Global.article_id as String)&api_key=\(Global.api_key as String)&secret_key=\(Global.secret_key as String)&time_zone=\(Global.time_zone)&from_count=0&to_count=\(Global.countLoadCommentsInPagination)")
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
  
  func postComment(_ name : String, email : String, comment : String, cell: AddCommentCell,completion : @escaping (ResponseToComment? , NSError?) -> Void) {
    
    let lTitle = ParametersConstructor.sharedInstance.encodingString(Global.title)
    
    let url = "\(Global.baseURL as String)postComment?host=\(Global.host as String)&article_id=\(Global.article_id as String)&api_key=\(Global.api_key)&secret_key=\(Global.secret_key as String)&name=\(name as String)&email=\(email as String)&comment=\(comment as String)&tags=\(Global.tag1 as String)&title=\(lTitle as String)&url=\(Global.articleUrl as String)"
    
    
    print("\n\(url)\n")
    
    Alamofire.request(url).responseJSON { response in
      
      let lStatusCode = response.response?.statusCode
      print(lStatusCode)
      
      if let JSON = response.result.value {
        
        cell.postButtonOutlet.isEnabled = true
        
        self.jsonArray = JSON as? NSDictionary
        
        let respon = ResponseToComment()
        respon.result = self.jsonArray!["result"] as? String
        respon.comment_id = self.jsonArray!["comment_id"] as? String
        respon.statusCode = lStatusCode
        respon.requestURL = url
        
        var moderationAnswer = self.jsonArray!["isModeration"] as? String
        
        if moderationAnswer != nil {
          respon.isModeration = moderationAnswer?.lowercased()
          print("\n \(moderationAnswer)")
        } else {
          respon.isModeration = "false" as? String
        }
        completion(respon , nil)
        
      } else {
        
        cell.postButtonOutlet.isEnabled = true
        
        let respon = ResponseToComment()
        respon.statusCode = lStatusCode
        respon.requestURL = url
        
        var lErrorResult = ""
        
        if let lData = response.data {
          lErrorResult = String(data: lData, encoding: .utf8)!
        }
        
        let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString(lErrorResult, comment: lErrorResult)]
        
        let requestError = NSError(domain: "vuukle",
                                   code: 500,
                                   userInfo: userInfo)
        
        completion(respon, requestError)
      }
    }
  }
  
  
  //MARK: Images
  
  func getImageWhihURL(_ imageURL: String, completion: @escaping (UIImage?, NSError?) -> Void) {
    
    Alamofire.request(imageURL).response { responce in
      
      if responce.error == nil, let data = responce.data {
        
        if data.count < 1000000 {
          
          let image = UIImage(data: data, scale: 1)
          completion(image, nil)
        }
      } else {
        completion(nil, responce.error as NSError?)
      }
    }
  }
  
  
  //MARK: Post Reply for Comment
  
  func postReplyForComment(_ name : String, email : String, comment : String, comment_id : String, cell: AddCommentCell, completion : @escaping (ResponseToComment? , NSError?) -> Void) {
    
    if (comment_id != nil) {
      
      let url = "\(Global.baseURL as String)postReply?name=\(name as String)&email=\(email as String)&comment=\(comment as String)&host=\(Global.host as String)&article_id=\(Global.article_id as String)&api_key=\(Global.api_key as String)&secret_key=\(Global.secret_key as String)&comment_id=\(comment_id as! String)&resource_id=\(Global.resource_id as String)&url=\(Global.articleUrl as String)"
      
      print("\n \(url)")
      
      Alamofire.request(url).responseJSON { response in
        
        let lStatusCode = response.response?.statusCode
        print(lStatusCode)
        
        if let JSON = response.result.value {
          
          cell.postButtonOutlet.isEnabled = true
          self.jsonArray = JSON as? NSDictionary
          
          let respon = ResponseToComment()
          respon.result = self.jsonArray!["result"] as? String
          respon.comment_id = self.jsonArray!["comment_id"] as? String
          respon.statusCode = lStatusCode
          respon.requestURL = url
          
          var moderationAnswer = self.jsonArray?["isModeration"] as? String
          
          if moderationAnswer != nil {
            respon.isModeration = moderationAnswer?.lowercased()
          } else {
            respon.isModeration = "false"
          }
          
          completion(respon , nil)
          print("Reply ID :\(respon.result!)")
          
        } else {
          
          cell.postButtonOutlet.isEnabled = true
          
          let respon = ResponseToComment()
          respon.statusCode = lStatusCode
          respon.requestURL = url
          
          var lErrorResult = ""
          
          if let lData = response.data {
            lErrorResult = String(data: lData, encoding: .utf8)!
          }
          
          let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString(lErrorResult, comment: lErrorResult)]
          
          let requestError = NSError(domain: "vuukle",
                                     code: 500,
                                     userInfo: userInfo)
          
          completion(respon, requestError)
        }
      }
    } else {
      
      cell.postButtonOutlet.isEnabled = true
      let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("comment_id_nil", comment: "comment_id_nil")]
      let canceledError = NSError(domain: "vuukle",
                                  code: 100502,
                                  userInfo: userInfo)
      completion(nil, canceledError)
    }
  }
  
  
  //MARK : Set Comment Vote - Up/Down Vote
  
  func setCommentVote(_ name : String ,email : String ,comment_id : String ,up_down : String,completion : @escaping (String? ,NSError?) -> Void) {
    
    if (comment_id != nil) {
      
      let url = "\(Global.baseURL as String)setCommentVote?host=\(Global.host as String)&article_id=\(Global.article_id as String)&api_key=\(Global.api_key as String)&secret_key=\(Global.secret_key as String)&comment_id=\(comment_id as! String)&up_down=\(up_down as String)&name=\(name as String)&email=\(email as String)"
      
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
    } else {
      
      let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("comment_id_nil", comment: "comment_id_nil")]
      let canceledError = NSError(domain: "vuukle",
                                  code: 100501,
                                  userInfo: userInfo)
      completion(nil, canceledError)
    }
  }
  
  //MARK: Get More Comment Feed
  
  func getMoreCommentsFeed(_ from_count : Int ,to_count : Int ,completion: @escaping ([CommentsFeed]?, NSError?) -> Void) {
    
    var url = "\(Global.baseURL as String)getCommentFeed?host=\(Global.host as String)&article_id=\(Global.article_id as String)&api_key=\(Global.api_key as String)&secret_key=\(Global.secret_key as String)&time_zone=\(Global.secret_key as String)&from_count=\(from_count)&to_count=\(to_count)"
    
    Alamofire.request(url).responseJSON { response in
      
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
    Alamofire.request("\(Global.baseURL as String)getEmoteRating?host=\(Global.host as String)&api_key=\(Global.api_key as String)&article_id=\(Global.article_id as String)")
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
  
  func setRaring(_ article_id : String ,emote : Int,completion : @escaping (ResponseToEmoteRating?, NSError?) -> Void) {
    
    let lTitle = ParametersConstructor.sharedInstance.encodingString(Global.title)
    
    let url = "\(Global.baseURL as String)setEmoteRating?host=\(Global.host as String)&api_key=\(Global.api_key as String)&article_id=\(article_id as String)&article_title=\(lTitle as String)&article_image=\(Global.article_image as String)&emote=\(emote)&url=\(Global.articleUrl as String)"
    
    print("\n\(url)\n")
    
    Alamofire.request(url).responseJSON { response in
      
      if let JSON = response.result.value {
        
        self.jsonArray = JSON as? NSDictionary
        
        let respon = ResponseToEmoteRating()
        respon.result = self.jsonArray!["result"] as? Bool
        
        completion(respon, nil)
        
      } else {
        
        completion(nil, response.result.error as NSError?)
        print("Status cod = \(response.response!.statusCode)")
      }
    }
  }
  
  //MARK: Get Comment Feed
  
  func getTotalCommentsCount(_ completion: @escaping (TotalCommentsCount) -> Void) {
    
    Alamofire.request("\(Global.baseURL as String)getCommentFeed?host=\(Global.host as String)&article_id=\(Global.article_id as String)&api_key=\(Global.api_key as String)&secret_key=\(Global.secret_key as String)&time_zone=\(Global.time_zone as String)&from_count=0&to_count=1")
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
    
    Alamofire.request("\(Global.baseURL as String)logoutUser").responseJSON { response in
      
      if let JSON = response.result.value {
        
        self.jsonArray = JSON as? NSDictionary
      } else {
        print("Status cod = \(response.response?.statusCode)")
      }
      
    }
  }
  
  //MARK : Get most popular article
  
  
  func getMostPopularArticle(_ completion: @escaping ([MostPopularArticle]?, NSError?) -> Void) {
    
    let url = "\(Global.baseURL as String)getRecentMostCommentedByHostByTime?bizId=\(Global.api_key as String)&host=\(Global.host as String)&tag=&hours=24&count=\(Global.countLoadMostPopularArticle)"
    
    print("\n[VUUKLE - TopArticle URL] \(url)\n")
    
    Alamofire.request(url).responseJSON { response in
      
      if let JSON = response.result.value {
        
        let array = JSON as? NSArray
        var responseArray = [MostPopularArticle]()
        
        for mostPopular in array! {
          responseArray.append(MostPopularArticle.getMostPopularArticleArray(pDict: mostPopular as! NSDictionary))
        }
        print("\n[VUUKLE - TopArticle Responce] \(responseArray)\n")
        
        completion(responseArray, nil)
        
      } else {
        print("Status cod = \(response.response?.statusCode)")
        completion(nil,response.result.error as NSError?)
      }
    }
  }
  
  func reportComment(commentID: String, name: String, email: String, cell: CommentCell, completion: @escaping(Bool?, NSError?) -> Void) {
    var result = false
    
    Alamofire.request("\(Global.baseURL as String)flagCommentOrReply?comment_id=\(commentID)&api_key=\(Global.api_key as String)&article_id=\(Global.article_id)&resource_id=\(Global.resource_id as String)&name=\(name)&email=\(email)")
      .responseJSON { response in
        if let JSON = response.result.value {
          self.jsonArray = JSON as? NSDictionary
          print("\(self.jsonArray!["result"])")
          let respon = self.jsonArray!["result"] as! String
          
          if respon == "true" {
            cell.hideProgress()
            completion(true, nil)
          } else {
            cell.hideProgress()
            completion(false , nil)
          }
        } else {
          print("Status cod = \(response.response?.statusCode)")
          completion(false, response.result.error as NSError?)
          cell.hideProgress()
        }
    }
  }
  
  
  func loadMoreComments(fromCount: Int, toCount: Int, completion: @escaping([CommentsFeed]?, NSError?) -> Void) {
    
    let url = "\(Global.baseURL)getCommentFeed?host=\(Global.host)&article_id=\(Global.article_id)&api_key=\(Global.api_key)&secret_key=\(Global.secret_key)&time_zone=\(Global.secret_key)&from_count=\(fromCount)&to_count=\(toCount)"
    
    Alamofire.request(url).responseJSON { response in
      
      if let JSON = response.result.value {
        
        var jsonArray = JSON as? NSDictionary
        
        let commentFeedArray : NSArray = [jsonArray!["comment_feed"]!]
        var responseArray = [CommentsFeed]()
        
        for feed in commentFeedArray.firstObject as! NSArray {
          
          responseArray.append(CommentsFeed.getCommentsFeedWhithArray(pDict: feed as! NSDictionary))
        }
        completion(responseArray, nil)
        
      } else {
        
        print("Status cod = \(response.response?.statusCode)")
        completion(nil, response.result.error as NSError?)
      }
    }
  }
}
