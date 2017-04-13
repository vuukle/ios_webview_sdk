//
//  String+Vuukle.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import Foundation
import UIKit

extension String {
  
  // MARK: - Encode/Decode text
  func jsonEncoded(isSendBugReport: Bool = false) -> String? {

    let text = self.replacingOccurrences(of: "&", with: " ")
    
    if let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
      return encodedText
    }

    if isSendBugReport {
      VUBugReportsFactory.showSendReportBUG(.errorEncodeText,
                                            errorMessage: "Can't encode text: \"\(self)\"")
    }
    return nil
  }

  func jsonDecoded() -> String? {
  
    if var decodedText = self.removingPercentEncoding {
      
      decodedText = decodedText.replacingOccurrences(of: "<br/>", with: "\n")
      return decodedText
    }
    return nil
  }
    
  // MARK - Decode/Encode emojis
    
  var encodeEmojis: String? {
    let encodedStr = NSString(cString: self.cString(using: String.Encoding.nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue)
      return encodedStr! as String
  }
  
  var decodeEmojis: String {
    let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
      if data != nil {
        let valueUniCode = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue) as String?
          if valueUniCode != nil {
            return valueUniCode!
        } else {
            return self
        }
    } else {
        return self
    }
  }
  
  // MARK: - Get initials from name
  func getInitials() -> String {
    
    var text = self.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    text = text.removeExcessiveSpaces()
    
    let textComponents = text.components(separatedBy: " ")
    var initialsString = "👨🏻‍💻"
    
    if textComponents.count >= 1, let nameChar = textComponents[0].characters.first {
      initialsString = "\(nameChar)"
    }
    
    if textComponents.count >= 2, let surnameChar = textComponents[1].characters.first {
      initialsString.append("\(surnameChar)")
    }
    return initialsString.uppercased()
  }
  
  
  // MARK: - Remove excessive symbols
  func removeExcessiveSpaces() -> String {
    
    var removedText = self
    
    if removedText.hasPrefix(" ") {
      
      while removedText.characters.first == " " {
        removedText.remove(at: removedText.startIndex)
      }
    }
    
    if removedText.hasSuffix(" ") {
      
      while removedText.characters.last == " " {
        removedText.remove(at: removedText.index(before: removedText.endIndex))
      }
    }
    return removedText
  }
  
  
  func removeExcessiveTabs() -> String {
    
    var removedText = self
    
    if removedText.hasPrefix("\n") {
      
      while removedText.characters.first == "\n" {
        removedText.remove(at: removedText.startIndex)
      }
    }
    
    if removedText.hasSuffix("\n") {

      while removedText.characters.last == "\n" {
        removedText.remove(at: removedText.index(before: removedText.endIndex))
      }
    }
    return removedText
  }
  
  subscript(i: Int) -> Character {
    return self.characters[self.index(self.startIndex, offsetBy: i)]
  }
  
}

extension Character {
  
  var asciiCode: Int {
    
    let characterString = String(self)
    let scalars = characterString.unicodeScalars
    
    return Int(scalars[scalars.startIndex].value)
  }
  
}
