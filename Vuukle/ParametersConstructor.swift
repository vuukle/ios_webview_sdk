

import Foundation
import UIKit
import Social


class ParametersConstructor  {
  
  static let sharedInstance = ParametersConstructor()
  let defaults : UserDefaults = UserDefaults.standard
  
  
  func showAlert(_ title : String ,message : String) {
    let ErrorAlert = UIAlertView(title: "\(title)", message: "\(message)", delegate: self, cancelButtonTitle: "Ok")
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [unowned self] in
      ErrorAlert.show()
    }
  }
  
  var isContatintURL = false
  var isNameContatintURL = false
  var URL: URL?
  
  func checkFields(_ name : String , email : String , comment : String) -> Bool {
    
    var allFill = false
    
    if name.characters.first == " " {
      
      showAlert("Error", message: "Name cannot start from space!")
      return false
    }
    if name != "" && email != "" && comment != "" && comment != "Please write a comment..." {
      
      allFill = verifyEmail(email: email)
      if (allFill == false) {
        showAlert( "Please enter a correct email!",message: "")
      }
    } else if name == "" || name == " " {
      showAlert("Please enter your name", message: "")
      allFill = false
    } else if email == ""{
      showAlert("Please enter your email", message: "")
      allFill = false
    } else if ((comment == "Please write a comment...") || (comment == "") || (comment.isEmpty) || (comment == " ")) || (checkStringForSpaces(string: comment) == false) {
      showAlert("Please enter the comment", message: "")
      allFill = false
    }
    
    let checkTypes: NSTextCheckingResult.CheckingType = [.link]
    let detector = try? NSDataDetector(types: checkTypes.rawValue)
    
    detector?.enumerateMatches(in: comment, options: .reportCompletion, range: NSRange.init(location: 0, length: comment.characters.count)) { (result, _, _) in
      
      if let lResult = result {
        
        print("\nRESULT = \(lResult)")
        
        if let lURL = lResult.url {
          self.isContatintURL = true
          self.URL = lURL
        }
        allFill = false
      }
    }
    
    if isContatintURL {
      if let lURL = URL {
        
        showAlert("Comment can't contain URL", message: "Please delete: \(lURL)")
        self.isContatintURL = false
        self.URL = nil
      }
    }
    
    let detector2 = try? NSDataDetector(types: checkTypes.rawValue)
    
    detector2?.enumerateMatches(in: name, options: .reportCompletion, range: NSRange.init(location: 0, length: name.characters.count)) { (result, _, _) in
      
      if let lResult = result {
        
        print("\nRESULT = \(lResult)")
        
        if let lURL = lResult.url {
          self.isNameContatintURL = true
          self.URL = lURL
        }
        allFill = false
      }
    }
    
    if isNameContatintURL {
      
      if let lURL = URL {
        showAlert("Name can't contain URL", message: "Please delete: \(lURL)")
        self.isNameContatintURL = false
        self.URL = nil
      }
    }
    
    return allFill
  }
  
  func checkTextIsURL(_ text: String) -> URL? {
    
    var urlFromString: URL?
    
    let lCheckTypes: NSTextCheckingResult.CheckingType = [.link]
    let lDetector = try? NSDataDetector(types: lCheckTypes.rawValue)
    
    let lRange = NSRange.init(location: 0, length: text.characters.count)
    
    lDetector?.enumerateMatches(in: text, options: .reportCompletion, range: lRange) { (result, _, _) in
      
      if let lUrl = result?.url {
        urlFromString = lUrl
      }
    }
    return urlFromString
  }
  
  
  
  func setDateInFofmat(_ dateInString : String) -> Date {
    
    var date = Date()
    if dateInString != "" {
      let dateString:String = dateInString
      let dateFormat = DateFormatter.init()
      dateFormat.dateStyle = .full
      dateFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
      date = (dateFormat.date(from: dateString)! as NSDate) as Date
    }
    return date
  }
  
  func encodingString(_ string : String) -> String {
    
    var text = string.replacingOccurrences(of: "&", with: " ")
    
    if let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
      return encodedText
    } else {
      return "dont_encoded_string"
    }
  }
  
  func decodingString(_ string : String?) -> String {
    
    if let lText = string {
      
      if let lDecodedText = lText.removingPercentEncoding {
        
        let lText = lDecodedText.replacingOccurrences(of: "<br/>", with: "\n")
        return lText
        
      } else {
        return lText
      }
    } else {
      return "empty_field"
    }
  }
  

  func setRatePercent (_ first : Int , second : Int , thirt : Int , fourth : Int , fifth : Int , sixt : Int , element : Int) -> Int {
    let sume : Int = first + second + thirt + fourth + fifth + sixt
    if sume == 0 {
      return 0
    }
    let percent = (element * 100)/sume
    return percent
  }
  
  
  func searchUpperChracters(_ fullName: String) -> String{
    
    var output1 = ""
    var output2 = ""
    var output = ""
    var sname = ""
    var fname = ""
    if fullName != "" {
      
      var fullNameComponents = fullName.components(separatedBy: " ")
      
      fname = fullNameComponents.count > 0 ? fullNameComponents[0]: ""
      sname = fullNameComponents.count > 1 ? fullNameComponents[1]: ""
      fname = fname.capitalized
      sname = sname.capitalized
      for chr in fname.characters {
        if output1.characters.count != 1 {
          output1 = String(chr)
        }
      }
      for chr in sname.characters {
        if output2.characters.count != 1 {
          output2 = String(chr)
        }
      }
      output = "\(output1)\(output2)"
    }
    return output
  }
  
  func setEmoticonCountVotes (_ data : EmoteRating){
    Global.firstEmoticonVotesCount = data.first
    Global.secondEmoticonVotesCount = data.second
    Global.thirdEmoticonVotesCount = data.third
    Global.fourthEmoticonVotesCount = data.fourth
    Global.fifthEmoticonVotesCount = data.fifth
    Global.sixthEmoticonVotesCount = data.sixth
    Global.votes = data
  }
  
  func checkStringForSpaces(string : String) -> Bool {
    let whitespaceSet = " "
    if string.range(of: whitespaceSet) != nil {
      
      return false
    } else {
      return true
    }
  }
  
  func getPercentage(_ input: [Int]) -> [Int] {
    var output: [Int] = []
    var sum = 0
    for value in input {
      if value > 0 {
        sum += value
      }
    }
    if sum == 0 { return [0] }
    
    for i in 0..<input.count {
      output.append(input[i] * 100 / sum)
    }
    
    return output
  }
  
  func getUserInfo() -> [String:String] {
    var resultDictionary: [String:String] = ["email":"", "name":"", "isLoggedIn":"false"]
    if self.defaults.object(forKey: "email") as? String != nil && self.defaults.object(forKey: "email") as? String != "" && self.defaults.object(forKey: "name") as? String != nil && self.defaults.object(forKey: "name") as? String != "" {
      let name = self.defaults.object(forKey: "name") as! String
      let email = self.defaults.object(forKey: "email") as! String
      resultDictionary.updateValue("true", forKey: "isLoggedIn")
      resultDictionary.updateValue(name, forKey: "name")
      resultDictionary.updateValue(email, forKey: "email")
    }
    return resultDictionary
  }
  
  func setUserInfo(name: String, email: String) {
    
    var lname = decodingString(name)
    var lemail = decodingString(email)
    lemail = lemail.replacingOccurrences(of: " ", with: "")
    lemail = lemail.replacingOccurrences(of: "%", with: "")
    lname = lname.replacingOccurrences(of: "%", with: "")
    self.defaults.set(lname, forKey: "name")
    self.defaults.set(lemail, forKey: "email")
    
    UserDefaults.standard.removeObject(forKey: "IS_LOGIN_FORM_OPENED")
    
    NotificationCenter.default.post(name: Notification.Name("Set_SocialLogin_Hidden"), object: nil)
  }
  
  func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
  
  func removeSpace(stroke : String) -> String {
    var strArray : [String] = []
    for value in stroke.characters {
      strArray.append(String(value))
    }
    if strArray.count > 2{
      if strArray[strArray.count - 1] == " " {
        strArray.popLast()
      }
    }
    var output = ""
    for value in strArray {
      output += value
    }
    return output
  }
  
}


