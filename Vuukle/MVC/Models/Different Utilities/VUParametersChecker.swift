//
//  VUParametersChecker.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit

class VUParametersChecker {


  // MARK: - [Gereral] Different verifications
  static func checkTextContaintsURL(_ text: String) -> URL? {
    
    var urlFromString: URL?
    
    let сheckTypes: NSTextCheckingResult.CheckingType = [.link]
    let urlDetector = try? NSDataDetector(types: сheckTypes.rawValue)
    
    let textRange = NSRange.init(location: 0, length: text.characters.count)
    
    urlDetector?.enumerateMatches(in: text, options: .reportCompletion, range: textRange) { (result, _, _) in
      
      if let url = result?.url {
        urlFromString = url
      }
    }
    return urlFromString
  }

  static func checkTextContaintsEmail(_ text: String) -> Bool {
    
    if text.utf8.count <= 254 {
      
      let emailComponents = text.components(separatedBy: "@")
      
      if emailComponents.count == 2,
        emailComponents[0].utf8.count <= 64,
        emailComponents[1].utf8.count <= 320 {
        
        let emailFotmatPattern = "[A-Z0-9a-z]+[A-Z0-9a-z._%+-]+[A-Z0-9a-z]+[@]{1,1}+[A-Za-z0-9-.]+[A-Za-z0-9]+[.]{1,1}+[A-Za-z]{2,}"
        
        let verifedEmail = NSPredicate(format:"SELF MATCHES %@", emailFotmatPattern)
        
        if verifedEmail.evaluate(with: text) {
          return true
        }
      }
    }
    return false
  }

  
  // MARK: -  [VUCommentsBuilderModel] Parameters of func "Load Vuukle Comments"
  static func checkCommentsBuilder(apiKey: inout String,
                                   secretKey: inout String,
                                   host: inout String) -> Bool {
    
    let chartersSet = CharacterSet.whitespacesAndNewlines
   
    let trimmedApiKey = apiKey.trimmingCharacters(in: chartersSet)
    let trimmedSecretKey = secretKey.trimmingCharacters(in: chartersSet)
    let trimmedHost = host.trimmingCharacters(in: chartersSet)

    if apiKey.isEmpty || trimmedApiKey.isEmpty {
    
      VUGlobals.errorFlag = "Empty Vuukle API Key!"
      return false
    }
    
    if secretKey.isEmpty || trimmedSecretKey.isEmpty {
      
      VUGlobals.errorFlag = "Empty Vuukle Secret Key!"
      return false
    }
    
    if host.isEmpty || trimmedHost.isEmpty {
      
      VUGlobals.errorFlag = "Empty Vuukle Host!"
      return false
    }
    
    let keyFotmatPattern = "[A-Z0-9a-z-]{1,}"
    let keyPredicate = NSPredicate(format:"SELF MATCHES %@", keyFotmatPattern)
    
    if keyPredicate.evaluate(with: apiKey) == false {
      
      VUGlobals.errorFlag = "Invalid Vuukle API Key"
      return false
    }
    
    if keyPredicate.evaluate(with: secretKey) == false {
      
      VUGlobals.errorFlag = "Invalid Vuukle Secret Key"
      return false
    }
    
    if host.lowercased().range(of: "www") != nil {
      
      VUGlobals.errorFlag = "Remove 'www' from Host!"
      return false
    }
    
    if host.lowercased().range(of: "http") != nil {
      
      VUGlobals.errorFlag = "Remove 'http' from Host!"
      return false
    }
    
    if host.lowercased().range(of: "https") != nil {
      
      VUGlobals.errorFlag = "Remove 'https' from host!"
      return false
    }
    
    apiKey = trimmedApiKey.removeExcessiveSpaces()
    secretKey = trimmedSecretKey.removeExcessiveSpaces()
    host = trimmedHost.removeExcessiveSpaces()
    
    return true
  }
  
  // TODO: • Time zone
  static func checkCommentsBuilder(timeZone: inout String) -> Bool {
  
    let chartersSet = CharacterSet.whitespacesAndNewlines
    let trimmedTimeZone = timeZone.trimmingCharacters(in: chartersSet)
    
    if timeZone.isEmpty || trimmedTimeZone.isEmpty {
      
      VUGlobals.errorFlag = "Empty Time Zone!"
      return false
    }
    
    let stringComponents = timeZone.components(separatedBy: "/")
    
    if stringComponents.count != 2 {
     
      VUGlobals.errorFlag = "Wrong Time Zone Format!"
      return false
    }
    
    timeZone = trimmedTimeZone.removeExcessiveSpaces()
    
    return true
  }
  
  // TODO: • Article ID, Article title, Article URL
  static func checkCommentsBuilder(articleID: inout String,
                                   articleTitle: inout String,
                                   articleURL: inout String) -> Bool {
    
    let chartersSet = CharacterSet.whitespacesAndNewlines
    
    let trimmedArticleID = articleID.trimmingCharacters(in: chartersSet)
    let trimmedArticleTitle = articleTitle.trimmingCharacters(in: chartersSet)
    let trimmedArticleURL = articleURL.trimmingCharacters(in: chartersSet)
    
    if articleID.isEmpty || trimmedArticleID.isEmpty {
      
      VUGlobals.errorFlag = "Empty Vuukle API key!"
      return false
    }
    
    if articleTitle.isEmpty || trimmedArticleTitle.isEmpty {
      
      VUGlobals.errorFlag = "Empty Vuukle Secret key!"
      return false
    }
    
    if articleURL.isEmpty || trimmedArticleURL.isEmpty {
      
      VUGlobals.errorFlag = "Empty Vuukle Host!"
      return false
    }

    if checkTextContaintsURL(articleURL) == nil {
      VUGlobals.errorFlag = "Invalid Article URL!"
      return false
    }
    
    articleTitle = articleTitle.replacingOccurrences(of: "\\s+",
                                                     with: " ",
                                                     options: .regularExpression)
    articleTitle = articleTitle.removeExcessiveSpaces()
    
    articleID = trimmedArticleID.removeExcessiveSpaces()
    articleURL = trimmedArticleURL.removeExcessiveSpaces()
    
    return true
  }
  
  // TODO: • App Name, App ID
  static func checkCommentsBuilder(appName: inout String,
                                   appID: inout String) -> Bool {
    
    let chartersSet = CharacterSet.whitespacesAndNewlines
    
    let trimmedAppName = appName.trimmingCharacters(in: chartersSet)
    let trimmedAppID = appID.trimmingCharacters(in: chartersSet)
    
    if appName.isEmpty || trimmedAppName.isEmpty {
      
      VUGlobals.errorFlag = "Empty App Name!"
      return false
    }
    
    if appID.isEmpty || trimmedAppID.isEmpty {
      
      VUGlobals.errorFlag = "Empty App ID!"
      return false
    }
    
    let keyFotmatPattern = "[A-Z0-9a-z-_.]{1,}"
    let keyPredicate = NSPredicate(format:"SELF MATCHES %@", keyFotmatPattern)
    
    if keyPredicate.evaluate(with: appName) == false {
      
      VUGlobals.errorFlag = "Invalid App Name"
      return false
    }
    
    if keyPredicate.evaluate(with: appID) == false {
      
      VUGlobals.errorFlag = "Invalid App ID"
      return false
    }
    
    appName = appName.replacingOccurrences(of: "\\s+",
                                           with: " ",
                                           options: .regularExpression)
    
    appName = appName.removeExcessiveSpaces()
    appID = trimmedAppID.removeExcessiveSpaces()
    
    return true
  }
  
  
  // MARK: - [VUNewCommentCell] Parameters of comment, name, email
  static func checkComment(_ text: inout String) -> Bool {
    
    if let baseVC = VUCommentsBuilderModel.vBaseVC {
      
      text = text.removeExcessiveSpaces()
      text = text.removeExcessiveTabs()
      
      switch checkField(comment: text) {
        
      case .emptyComment:
        baseVC.showAlert("⚠️ Empty comment",
                         message: "You can't post an empty comment.")
        return false

      case .commentContaintsURL:
        baseVC.showAlert("⚠️ Comment containts URL",
                         message: "Comment can't contain links or web-sites, please remove: \"\(VUGlobals.errorFlag)\"")
        return false

      case .correct:
        return true
      }
   }
    return false
  }

  static func checkUser(name: inout String, email: inout String) -> Bool {
    
    if let baseVC = VUCommentsBuilderModel.vBaseVC {
      
      name = name.removeExcessiveSpaces()
      email = email.removeExcessiveSpaces()

      switch checkField(name: name) {
      
      case .emptyName:
        baseVC.showAlert("⚠️ Empty name",
                         message: "You can't make posts with an empty name.")
        return false
  
      case .nameContainsURL:
        baseVC.showAlert("⚠️ Name containts URL",
                         message: "Name can't contain links or web-sites, please remove: \"\(VUGlobals.errorFlag)\"")
        return false
   
      default: break
      }
      
      switch checkField(email: email) {
        
      case .emptyEmail:
        baseVC.showAlert("⚠️ Empty email",
                         message: "You can't make posts with an empty email.")

      case .notEmail:
        baseVC.showAlert("⚠️ Invalid email",
                         message: "You can't make posts with not valid email address.")
        
      case .correct:
        return true
      }
    }
    return false
  }

  // TODO: • Comment
  private static func checkField(comment: String) -> VUCommentCheckResultType {
    
    let chartersSet = CharacterSet.whitespacesAndNewlines
    let trimmedComment = comment.trimmingCharacters(in: chartersSet)
  
    if trimmedComment.isEmpty {
      return .emptyComment
    }
    
    if let url = checkTextContaintsURL(comment) {
      
      VUGlobals.errorFlag = "\(url)"
      return .commentContaintsURL
    }
    return .correct
  }
  
  // TODO: • Name
  private static func checkField(name: String) -> VUNameCheckResultType {
    
    let chartersSet = CharacterSet.whitespacesAndNewlines
    let trimmedName = name.trimmingCharacters(in: chartersSet)
    
    if name.isEmpty || trimmedName.isEmpty {
      return .emptyName
    }
    
    if let url = checkTextContaintsURL(name) {
      VUGlobals.errorFlag = "\(url)"
      return .nameContainsURL
    }
    return .correct
  }
  
  // TODO: • Email
  private static func checkField(email: String) -> VUEmailCheckResultType {
    
    let chartersSet = CharacterSet.whitespacesAndNewlines
    let trimmedEmail = email.trimmingCharacters(in: chartersSet)
    
    if email.isEmpty || trimmedEmail.isEmpty {
      return .emptyEmail
    }
    
    if checkTextContaintsEmail(email) == false {
      return .notEmail
    }
    return .correct
  }
  
  
  // MARK: - [VUModelsFactory] Compare names and emails
  static func compare(name: String,
                      currentName: String,
                      email: String,
                      currentEmail: String) -> Bool {
    
    var name = name.removeExcessiveSpaces()
    name = name.lowercased()
    
    var currentName = currentName.removeExcessiveSpaces()
    currentName = currentName.lowercased()
    
    let isNameEqual = name == currentName
    
    // FIXME: Update this later when backend will work correct.
    let isEmailEqual = true
    
    return isNameEqual && isEmailEqual
  }
  
}

