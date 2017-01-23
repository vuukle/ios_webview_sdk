import UIKit
import Alamofire
//import Social
//import FBSDKCoreKit
//import FBSDKLoginKit
//import STTwitter


class SocialNetworksTracker: NSObject {
  
  private override init() { }
  static let sharedTracker : SocialNetworksTracker = SocialNetworksTracker()
  
  //MARK: - Facebook properties
  //var facebookLoginManager = FBSDKLoginManager()
  
  //MARK: Facebook methods
  func logInFacebook(successClosure: @escaping (Dictionary<String, String>?) -> (),
                     errorClosure: @escaping (Error?) -> ()) {
//    
//    FBSDKAccessToken.setCurrent(nil)
//    FBSDKProfile.setCurrent(nil)
//    
//    if (FBSDKAccessToken.current() == nil) {
//      
//      facebookLoginManager.logIn(withReadPermissions: ["public_profile", "email"]) { (loginResult, loginError) in
//        
//        if (loginError != nil) {
//          errorClosure(loginError)
//          
//        } else if (loginResult?.isCancelled == true) {
//          
//          let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("facebook_login_canceled", comment: "bla-bla-bla")]
//          let canceledError = NSError(domain: "facebook",
//                                      code: 100500,
//                                      userInfo: userInfo)
//          
//          errorClosure(canceledError)
//          
//        } else {
//          
//          let graphRequst = FBSDKGraphRequest(graphPath: "me",
//                                              parameters: ["fields": "name, email, id"],
//                                              httpMethod: "GET")
//          
//          graphRequst?.start( completionHandler: { (requestConnection, requestResult, requestError) in
//            
//            if (requestError != nil) {
//              print("-- Error: \(requestError?.localizedDescription)")
//              errorClosure(requestError)
//              
//            } else {
//              
//              let userInfo = requestResult as! Dictionary<String, String>
//              
//              SocialNetworksUser.sharedInstance.saveFacebookUser(
//                name: userInfo["name"],
//                ID: userInfo["id"],
//                email: userInfo["email"])
//              
//              successClosure(userInfo)
//            }
//                                              })
//        }
//      }
//    }
  }
  
  func logOutFacebook() {
//    facebookLoginManager.logOut()
//    SocialNetworksUser.sharedInstance.deleteFacebookUser()
  }
  
  
  //MARK: - Twitter properties
  typealias twitterCompletionClosureType = (Dictionary<String, Any>?) -> (Void)
  typealias twitterErrorClosureType = (Error?) -> ()
  
  //var twitterAPI = STTwitterAPI()
  let twitterConsumerKey = "WiMW1eZLZBYuJb6J3xJ9A0KoR"
  let twitterConsumerSecret = "BA8murNNEBHi3tZ77cGcW7cc5ehxzCILDQmBM03xK3jUPWa6fw"
  
  var twitterCompletionClosure: twitterCompletionClosureType?
  var twitterErrorClosure: twitterErrorClosureType?
  
  //MARK: Twitter methods
  func logInTwitter(successClosure: @escaping twitterCompletionClosureType,
                    errorClosure: @escaping twitterErrorClosureType) {
    
//    twitterCompletionClosure = successClosure
//    twitterErrorClosure = errorClosure
//    
//    let infoPlist = Bundle.main.infoDictionary
//    
//    twitterAPI = STTwitterAPI(oAuthConsumerKey: twitterConsumerKey,
//                              consumerSecret: twitterConsumerSecret)
//    
//    twitterAPI.postTokenRequest({ (twitterURL, twitterOAuthToken) in
//      
//      if (twitterURL != nil) {
//        UIApplication.shared.openURL(twitterURL!)
//      }
//      
//    }, authenticateInsteadOfAuthorize: false,
//       forceLogin: 1 as NSNumber,
//       screenName: nil,
//       oauthCallback: "vuuclecomments://twitter_access_tokens/",
//       errorBlock: { [unowned self] in self.twitterErrorClosure!($0) })
  }
  
  func setTitterOAuth(token: String, verifier: String) {
    
//    SocialNetworksUser.sharedInstance.saveTwitterTokens(token: token, secret: verifier)
//    
//    twitterAPI.postAccessTokenRequest(withPIN: verifier, successBlock: { [unowned self] (oauthToken, oauthTokenSecret, userID, userName) in
//      
//      self.twitterAPI.getAccountVerifyCredentials(withIncludeEntites: 0 as NSNumber,
//                                                  skipStatus: 0 as NSNumber,
//                                                  includeEmail: true,
//      successBlock: { (userInfo) in
//        
//        var dict: Dictionary <String, Any> = userInfo as! Dictionary<String, Any>
//        var lowerCaseName = userName!
//        lowerCaseName = lowerCaseName.lowercased()
//        let cruthEmail = "\(lowerCaseName as String)@email.com"
//        
//        SocialNetworksUser.sharedInstance.saveTwitterUser(name: userName!,
//                                                          ID: userID!,
//                                                          email: cruthEmail)
//        self.twitterCompletionClosure!(dict)
//        
//      }, errorBlock: { [unowned self] in self.twitterErrorClosure!($0) })
//      }, errorBlock: { [unowned self] in self.twitterErrorClosure!($0) })
  }
  
}
