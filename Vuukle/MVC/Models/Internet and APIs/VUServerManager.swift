//
//  VUServerManager.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit
import Alamofire

class VUServerManager {
  
  static let sharedManager = VUControllSum()
  
  //MARK: - GET: Comments and Replies
  static func getComments(from: Int,
                          to: Int,
                          completion: @escaping([Any]?, Error?) -> Void) {
    
    var requestURL = "\(VUGlobals.vuukleBaseURL)getCommentFeed"
    
    requestURL.append("?host=\(VUGlobals.requestParametes.vuukleHost)")
    requestURL.append("&article_id=\(VUGlobals.requestParametes.articleID)")
    requestURL.append("&api_key=\(VUGlobals.requestParametes.vuukleApiKey)")
    requestURL.append("&secret_key=\(VUGlobals.requestParametes.vuukleSecretKey)")
    requestURL.append("&time_zone=\(VUGlobals.requestParametes.vuukleTimeZone)")
    
    requestURL.append("&from_count=\(from)")
    requestURL.append("&to_count=\(to)")
    
    vuuklePrint("[GET Comment] URL: \(requestURL)")
    
    Alamofire.request(requestURL).responseJSON { alamofireResponse in
      
      let statusCode = getStatusCode(alamofireResponse.response,
                                     error: alamofireResponse.result.error)
      
      vuuklePrint("[GET Comment] Status Code: \(statusCode)")
      
      if let JSON = alamofireResponse.result.value as? NSDictionary,
        let responceCommentsArray = JSON["comment_feed"] as? [NSDictionary] {
        
        var commentsArray = [Any]()
        
        if let totatCount = JSON["comments"] as? Int {
          VUGlobals.totalCommentsCount = totatCount
        }
        
        if let resourceID = JSON["resource_id"] as? Int {
          VUGlobals.requestParametes.resourceID = resourceID
        }
        
        for commentInfo in responceCommentsArray {
          commentsArray.append(VUCommentModel(info: commentInfo))
        }
        completion(commentsArray, nil)
        
      } else {
        
        printErrorReason("[GET Comments] Error:",
                         data: alamofireResponse.data,
                         error: alamofireResponse.result.error)
        
        completion(nil, alamofireResponse.result.error)
      }
    }
  }

  static func getReplies(_ commentID: String,
                         parentID: String,
                         parentNestingLevel: Int,
                         completion: @escaping([Any]?, Error?) -> Void) {
    
    var requestURL = "\(VUGlobals.vuukleBaseURL)getReplyFeed"
    
    requestURL.append("?host=\(VUGlobals.requestParametes.vuukleHost)")
    requestURL.append("&article_id=\(VUGlobals.requestParametes.articleID)")
    requestURL.append("&api_key=\(VUGlobals.requestParametes.vuukleApiKey)")
    requestURL.append("&secret_key=\(VUGlobals.requestParametes.vuukleSecretKey)")
    requestURL.append("&time_zone=\(VUGlobals.requestParametes.vuukleTimeZone)")
    
    requestURL.append("&comment_id=\(commentID)")
    requestURL.append("&parent_id=\(parentID)")
  
    vuuklePrint("[GET Replies] URL: \(requestURL)")
    
    Alamofire.request(requestURL).responseJSON { alamofireResponse in
      
      let statusCode = getStatusCode(alamofireResponse.response,
                                     error: alamofireResponse.result.error)
      
      vuuklePrint("[GET Replies] Status Code: \(statusCode)")
      
      if let responceRepliesArray = alamofireResponse.result.value as? [NSDictionary]  {
        
        var repliesArray = [Any]()
        
        for commentInfo in responceRepliesArray {
          
          let commentModel = VUCommentModel(info: commentInfo)
          commentModel.nestingLevel = parentNestingLevel + 1
          
          repliesArray.append(commentModel)
        }
        completion(repliesArray, nil)
        
      } else {
        vuuklePrint("[GET Replies] Error: \(alamofireResponse.result.error?.localizedDescription)")
        completion(nil, alamofireResponse.result.error)
      }
    }
  }
  
  
  // MARK: - GET: Top Articles
  static func getTopArticles(_ completion: @escaping([Any]?, Error?) -> Void) {
    
    var requestURL = "\(VUGlobals.vuukleBaseURL)getRecentMostCommentedByHostByTime"
    
    requestURL.append("?bizId=\(VUGlobals.requestParametes.vuukleApiKey)")
    
    requestURL.append("&host=\(VUGlobals.requestParametes.vuukleHost)")
    requestURL.append("&tag=")
    requestURL.append("&hours=\(VUGlobals.topArticlesHours)")
    requestURL.append("&count=\(VUGlobals.topArticlesCount)")
    
    vuuklePrint("[GET Top Articles] URL: \(requestURL)")
    
    Alamofire.request(requestURL).responseJSON { (alamofireResponse) in
      
      let statusCode = getStatusCode(alamofireResponse.response,
                                     error: alamofireResponse.result.error)
      
      vuuklePrint("[GET Top Articles] Status Code: \(statusCode)")
      
      if let JSON = alamofireResponse.result.value as? [NSDictionary] {
        
        var articlesArray = [Any]()
        
        for articleInfo in JSON {
          articlesArray.append(VUTopArticleModel(articleInfo))
        }
        
        completion(articlesArray, nil)
        
      } else {
        
        printErrorReason("[GET Top Articles] Error:",
                         data: alamofireResponse.data,
                         error: alamofireResponse.result.error)
        
        completion(nil, alamofireResponse.result.error)
      }
    }
  }
  
  
  // MARK: - GET: Emoji Voting
  static func getEmojiRating(_ completion: @escaping(VUEmojiVotingModel?, Error?) -> Void) {
    
    let articleID = VUGlobals.requestParametes.articleID
    
    var requestURL = "\(VUGlobals.vuukleBaseURL)getEmoteRating"
    
    requestURL.append("?host=\(VUGlobals.requestParametes.vuukleHost)")
    requestURL.append("&api_key=\(VUGlobals.requestParametes.vuukleApiKey)")
    requestURL.append("&article_id=\(articleID)")
  
    Alamofire.request(requestURL).responseJSON { (alamofireResponse) in
      
      let statusCode = getStatusCode(alamofireResponse.response,
                                     error: alamofireResponse.result.error)
      
      vuuklePrint("[GET Emoji Rating] Status Code: \(statusCode)")
      
      if let JSON = alamofireResponse.result.value as? NSDictionary {
        
        let emojiVotingModel = VUEmojiVotingModel.init(articleID)
        emojiVotingModel.setCommentRatingInfo(JSON)
        
        completion(emojiVotingModel, nil)
        
      } else {
        
        printErrorReason("[GET Emoji Rating] Error:",
                         data: alamofireResponse.data,
                         error: alamofireResponse.result.error)
        
        completion(nil, alamofireResponse.result.error)
      }
    }
  }
  
  
  // MARK: - POST: New Comment/Reply
  static func postComment(comment: String,
                          name: String,
                          email: String,
                          parentID: String,
                          completion: @escaping (VUPostResponceModel) -> Void) {
    
    let devR = sharedManager.getRandomHashCode(comment + VUGlobals.requestParametes.vuukleApiKey)
    let devC = sharedManager.getHashCode(comment + "\(VUGlobals.requestParametes.resourceID)" + VUGlobals.requestParametes.vuukleApiKey)
    
    var requestURL = "\(VUGlobals.vuukleBaseURLCommentAction)postComment"
    
    let postHeadersDict = ["user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36",
                           "Referer": "vuukle.com"]
    
    let parametres = ["api_key": VUGlobals.requestParametes.vuukleApiKey,
                      "article_id": VUGlobals.requestParametes.articleID,
                      "comment": comment,
                      "email": email,
                      "host": VUGlobals.requestParametes.vuukleHost,
                      "name": name,
                      "r": devR,
                      "resource_id": VUGlobals.requestParametes.resourceID,
                      "s": devC,
                      "tags": "debug",
                      "title": VUGlobals.requestParametes.articleTitle,
                      "url": VUGlobals.requestParametes.articleURL] as [String : Any]
    
    Alamofire.request(requestURL,
                      method: .post,
                      parameters: parametres,
                      encoding: JSONEncoding.default,
                      headers: postHeadersDict).responseJSON { alamofireResponse in
                        
                        let statusCode = getStatusCode(alamofireResponse.response,
                                                       error: alamofireResponse.result.error)
                        
                        vuuklePrint("[POST Comment] Status Code: \(statusCode)")
                        
                        if let JSON = alamofireResponse.result.value as? NSDictionary {
                          print("\n [NEW Post Comment]: \(JSON)")                        
                          let responceModel = VUPostResponceModel(info: JSON as! [String : Any],
                                                              requestURL: requestURL,
                                                              statusCode: statusCode,
                                                             errorReason: nil)
                          completion(responceModel)
                          
                        } else {
                          
                          printErrorReason("[NEW Post Comment] Error:",
                                           data: alamofireResponse.data,
                                           error: alamofireResponse.result.error)
                          
                          if let responceData = alamofireResponse.data,
                            let errorResult = String.init(data: responceData, encoding: .utf8) {
                            
                            let responceModel = VUPostResponceModel(info: nil,
                                                                    requestURL: requestURL,
                                                                    statusCode: statusCode,
                                                                    errorReason: errorResult)
                            responceModel.comment = comment
                            responceModel.name = name
                            responceModel.email = email
                            
                            completion(responceModel)
                          }
                        }
                      
    }
  }
  
  
  static func postReply(comment: String,
                        name: String,
                        email: String,
                        parentID: String,
                        completion: @escaping (VUPostResponceModel) -> Void) {
    
    let devR = sharedManager.getRandomHashCode(comment + VUGlobals.requestParametes.vuukleApiKey)
    let devC = sharedManager.getHashCode(comment + "\(VUGlobals.requestParametes.resourceID)" + VUGlobals.requestParametes.vuukleApiKey)
    
    var requestURL = "\(VUGlobals.vuukleBaseURLCommentAction)postReply"
    
    let postHeadersDict = ["user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36",
                           "Referer": "vuukle.com"]
    
    let parametres = ["api_key": VUGlobals.requestParametes.vuukleApiKey,
                      "article_id": VUGlobals.requestParametes.articleID,
                      "comment": comment,
                      "comment_id": parentID,
                      "email": email,
                      "host": VUGlobals.requestParametes.vuukleHost,
                      "name": name,
                      "r": devR,
                      "resource_id": VUGlobals.requestParametes.resourceID,
                      "s": devC] as [String : Any]
    
    Alamofire.request(requestURL,
                      method: .post,
                      parameters: parametres,
                      encoding: JSONEncoding.default,
                      headers: postHeadersDict).responseJSON { alamofireResponse in
                        
                        let statusCode = getStatusCode(alamofireResponse.response,
                                                       error: alamofireResponse.result.error)
                        
                        vuuklePrint("[POST Comment] Status Code: \(statusCode)")
                        
                        if let JSON = alamofireResponse.result.value as? NSDictionary {
                          print("\n [NEW Post Comment]: \(JSON)")
                          let responceModel = VUPostResponceModel(info: JSON as! [String : Any],
                                                                  requestURL: requestURL,
                                                                  statusCode: statusCode,
                                                                  errorReason: nil)
                          completion(responceModel)
                          
                        } else {
                          
                          printErrorReason("[NEW Post Comment] Error:",
                                           data: alamofireResponse.data,
                                           error: alamofireResponse.result.error)
                          
                          if let responceData = alamofireResponse.data,
                            let errorResult = String.init(data: responceData, encoding: .utf8) {
                            
                            let responceModel = VUPostResponceModel(info: nil,
                                                                    requestURL: requestURL,
                                                                    statusCode: statusCode,
                                                                    errorReason: errorResult)
                            responceModel.comment = comment
                            responceModel.name = name
                            responceModel.email = email
                            
                            completion(responceModel)
                        }
                      }
    }
  }

  
  // MARK: - REPORT: Comment or Reply
  static func reportComment(commentID: String,
                            name: String,
                            email: String,
                            completion: @escaping(Bool, VURequestError?) -> Void) {
    
    var requestURL = "\(VUGlobals.vuukleBaseURLCommentAction)flagCommentOrReply"
    
    let postHeadersDict = ["user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36",
                           "Referer": "vuukle.com"]
    
    let parametres = ["api_key": VUGlobals.requestParametes.vuukleApiKey,
                      "article_id": VUGlobals.requestParametes.articleID,
                      "comment_id": commentID,
                      "email": email,
                      "name": name,
                      "resource_id": VUGlobals.requestParametes.resourceID] as [String : Any]
    
    Alamofire.request(requestURL,
                      method: .post,
                      parameters: parametres,
                      encoding: JSONEncoding.default,
                      headers: postHeadersDict).responseJSON { alamofireResponse in
                        
                        let statusCode = getStatusCode(alamofireResponse.response,
                                                       error: alamofireResponse.result.error)
                        
                        vuuklePrint("[POST Comment] Status Code: \(statusCode)")
                        
                        if let JSON = alamofireResponse.result.value as? NSDictionary {
                          vuuklePrint("JSON = \(JSON)")
                          
                          completion(true, nil)
                          
                        } else {
                          
                          printErrorReason("[NEW Post Comment] Error:",
                                           data: alamofireResponse.data,
                                           error: alamofireResponse.result.error)
                          
                          let vuukleError = VURequestError(statusCode,
                                                           type: .errorReportComment,
                                                           data: alamofireResponse.data,
                                                           error: alamofireResponse.result.error)
                          
                          var parameters = ["• COMMENT ID: \(commentID)\n"]
                          
                          parameters.append("• NAME: \(name)\n")
                          parameters.append("• EMAIL: \(email)\n")
                          
                          parameters.append("• API KEY: \(VUGlobals.requestParametes.vuukleApiKey)\n")
                          parameters.append("• ARTICLE ID: \(VUGlobals.requestParametes.articleID)\n")
                          parameters.append("• RESOURCE ID: \(VUGlobals.requestParametes.resourceID)\n")
                          
                          vuukleError.parametersArray = parameters
                          
                          completion(false, vuukleError)
                        }
    }
  }
  
  
  // MARK: - VOTE: Up/Down for comment
  static func voteForComment(type: VUCommentVoteType,
                             commentID: String,
                             name: String,
                             email: String,
                             completion: @escaping(Bool, VURequestError?) -> Void) {
    
    var requestURL = "\(VUGlobals.vuukleBaseURLCommentAction)setCommentVote"
    
    let postHeadersDict = ["user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36",
                           "Referer": "vuukle.com"]
    
    let parametres = ["api_key": VUGlobals.requestParametes.vuukleApiKey,
                      "article_id": VUGlobals.requestParametes.articleID,
                      "comment_id": commentID,
                      "email": email,
                      "host": VUGlobals.requestParametes.vuukleHost,
                      "name": name,
                      "secret_key": VUGlobals.requestParametes.vuukleSecretKey,
                      "up_down": type.rawValue] as [String : Any]
    
    Alamofire.request(requestURL,
                      method: .post,
                      parameters: parametres,
                      encoding: JSONEncoding.default,
                      headers: postHeadersDict).responseJSON { alamofireResponse in
                        
                        let statusCode = getStatusCode(alamofireResponse.response,
                                                       error: alamofireResponse.result.error)
                        
                        vuuklePrint("[POST Comment] Status Code: \(statusCode)")
                        
                        if let JSON = alamofireResponse.result.value as? NSDictionary {
                          vuuklePrint("JSON = \(JSON)")
                          
                          completion(true, nil)
                          
                        } else {
                          
                          printErrorReason("[NEW Post Comment] Error:",
                                           data: alamofireResponse.data,
                                           error: alamofireResponse.result.error)
                          
                          let vuukleError = VURequestError(statusCode,
                                                           type: .errorVoteForComment,
                                                           data: alamofireResponse.data,
                                                           error: alamofireResponse.result.error)
                          
                          var parameters = ["• COMMENT ID: \(commentID)\n"]
                          
                          parameters.append("• NAME: \(name)\n")
                          parameters.append("• EMAIL: \(email)\n")
                          
                          parameters.append("• API KEY: \(VUGlobals.requestParametes.vuukleApiKey)\n")
                          parameters.append("• SECRET KEY: \(VUGlobals.requestParametes.vuukleSecretKey)\n")
                          parameters.append("• ARTICLE ID: \(VUGlobals.requestParametes.articleID)\n")
                          parameters.append("• RESOURCE ID: \(VUGlobals.requestParametes.resourceID)\n")
                          
                          parameters.append("• HOST: \(VUGlobals.requestParametes.vuukleHost)\n")
                          parameters.append("• VOTE TYPE: \(type)\n")
                          
                          vuukleError.parametersArray = parameters
                          
                          completion(false, vuukleError)
                          }
                        }
  }


  // MARK: - VOTE: Emoji reaction
  static func voteForEmoji(_ index: Int,
                           completion: @escaping(Bool, VURequestError?) -> Void) {
    
    let index = index + 1
    
    var requestURL = "\(VUGlobals.vuukleBaseURL)setEmoteRating"
    
    requestURL.append("?host=\(VUGlobals.requestParametes.vuukleHost)")
    requestURL.append("&api_key=\(VUGlobals.requestParametes.vuukleApiKey)")
    requestURL.append("&secret_key=\(VUGlobals.requestParametes.vuukleSecretKey)")
    
    requestURL.append("&article_id=\(VUGlobals.requestParametes.articleID)")
    requestURL.append("&article_title=\(VUGlobals.requestParametes.articleTitle)")
    
    requestURL.append("&emote=\(index)")
    requestURL.append("&url=\(VUGlobals.requestParametes.articleURL)")
    requestURL.append("&article_image=")
    
    vuuklePrint("[VOTE Emoji] URL: \(requestURL)")
    
    Alamofire.request(requestURL).responseJSON { alamofireResponse in
      
      let statusCode = getStatusCode(alamofireResponse.response,
                                     error: alamofireResponse.result.error)
      
      vuuklePrint("[VOTE Emoji] Status Code: \(statusCode)")
      
      if let JSON = alamofireResponse.result.value as? NSDictionary {
        
        vuuklePrint("JSON = \(JSON)")
        
        
        completion(true, nil)
        
      } else {
        
        printErrorReason("[VOTE Emoji] Error:",
                         data: alamofireResponse.data,
                         error: alamofireResponse.result.error)
        
        let vuukleError = VURequestError(statusCode,
                                         type: .errorReportComment,
                                         data: alamofireResponse.data,
                                         error: alamofireResponse.result.error)
        
        var parameters = ["• EMOJI INDEX: \(index)\n"]

        parameters.append("• API KEY: \(VUGlobals.requestParametes.vuukleApiKey)\n")
        parameters.append("• ARTICLE ID: \(VUGlobals.requestParametes.articleID)\n")
        parameters.append("• RESOURCE ID: \(VUGlobals.requestParametes.resourceID)\n")
        
        vuukleError.parametersArray = parameters
        
        completion(false, vuukleError)
      }
    }
  }
  
  
  // MARK: - LOGOUT: Current user
  static func logoutCurrentUser(_ completion: @escaping (Bool, VURequestError?) -> Void) {
  
    let requestURL = "\(VUGlobals.vuukleBaseURL)logoutUser"
    
    Alamofire.request(requestURL).responseJSON { alamofireResponse in
      
      let statusCode = getStatusCode(alamofireResponse.response,
                                     error: alamofireResponse.result.error)
      
      vuuklePrint("[LOGOUT User] Status Code: \(statusCode)")
      
      if let JSON = alamofireResponse.result.value as? NSDictionary {
        
        vuuklePrint("JSON = \(JSON)")
        completion(true, nil)
      
      } else {
        
        printErrorReason("[LOGOUT User] Error:",
                         data: alamofireResponse.data,
                         error: alamofireResponse.result.error)
        
        let vuukleError = VURequestError(statusCode,
                                         type: .errorLogOut,
                                         data: alamofireResponse.data,
                                         error: alamofireResponse.result.error)
        completion(false, vuukleError)
      }
    }
  }
  
  
  // MARK: - DOWNLOAD: Image
  typealias imageCompletionClosure = (UIImage?, Error?) -> (Void)
  
  static var dictionaryImageClosures: [String: Any] = Dictionary()
  
  static func downloadImage(_ imageURL: String,
                            completion: @escaping imageCompletionClosure) {
    
    if VUServerManager.dictionaryImageClosures[imageURL] == nil {
      
      vuuklePrint("[DOWNLOAD Image] URL: \(imageURL)")
      
      VUServerManager.saveImageComplition(imageURL,
                                          closure: completion)
      
      Alamofire.request(imageURL).response { alamofireResponse in
        
        let statusCode = getStatusCode(alamofireResponse.response,
                                       error: alamofireResponse.error)
        
        vuuklePrint("[DOWNLOAD Image] Status Code: \(statusCode)")
        
        if alamofireResponse.error == nil,
          let imageData = alamofireResponse.data,
          let downloadedImage = UIImage(data: imageData, scale: 1) {
          
          VUServerManager.returnSuccess(imageURL,
                                        image: downloadedImage)
        } else {
          
          printErrorReason("[DOWNLOAD Image] Error:",
                           data: alamofireResponse.data,
                           error: alamofireResponse.error)
    
          VUServerManager.returnFailure(imageURL,
                                        error: alamofireResponse.error)
        }
      }
    } else {
      VUServerManager.saveImageComplition(imageURL,
                                          closure: completion)
    }
  }
  
  // TODO: • Save closures to for URL
  private  static func saveImageComplition(_ key: String,
                                           closure: @escaping imageCompletionClosure) {
    
    if dictionaryImageClosures[key] == nil {
      
      let closuresArray = [closure]
      dictionaryImageClosures[key] = closuresArray
      
    } else {
      
      if var closuresArray = dictionaryImageClosures[key] as? [imageCompletionClosure] {
        
        closuresArray.append(closure)
        dictionaryImageClosures[key] = closuresArray
      }
    }
  }
  
  // TODO: • Return Image/Error to all closures for URL
  private static func returnSuccess(_ imageURL: String,
                                    image: UIImage) {
    
    if let closuresArray = VUServerManager.dictionaryImageClosures[imageURL] as?[imageCompletionClosure] {
      
      for closure in closuresArray {
        closure(image, nil)
      }
      dictionaryImageClosures[imageURL] = nil
    }
  }
  
  private static func returnFailure(_ imageURL: String,
                                    error: Error?) {
    
    if let closuresArray = dictionaryImageClosures[imageURL] as? [imageCompletionClosure] {
      
      for closure in closuresArray {
        closure(nil, error)
      }
      dictionaryImageClosures[imageURL] = nil
    }
  }
  
  
  // MARK: - SUPPORT METHODS
  private static func getStatusCode(_ response: HTTPURLResponse?,
                                    error: Error?) -> Int {
    
    if let statusCode = response?.statusCode {
      return statusCode
    }
    
    if let requestError = error as? NSError {
      return requestError.code
    }
    
    return 0
  }
  
  private static func printErrorReason(_ errorTitle: String,
                                       data: Data?,
                                       error: Error?) {
    if let responceData = data,
      let errorText = String.init(data: responceData,
                                  encoding: .utf8) {
      vuuklePrint("\(errorTitle) \(errorText)")
    }
    
    if let requestError = error {
      vuuklePrint("\(errorTitle) \(requestError.localizedDescription)")
    }
  }
  
}
