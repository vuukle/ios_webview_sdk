//
//  VUTopArticleModel.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit


class VUTopArticleModel {

  // MARK: - Model
  var articleTitle = "Talk of the Town"
  var articleDate = NSDate(timeIntervalSinceNow: 0)
  var imageURL: String?
  
  var commentsCount = 0
  
  var apiKey: String?
  var host: String?

  var articleID: String?
  var articleURL: String?
  
  
  // MARK: - Init of model
  init(_ info: NSDictionary) {
    
    if let infoTitle = info["heading"] as? String {
      
      if let decodedTitle = infoTitle.jsonDecoded() {
        articleTitle = decodedTitle
      } else {
        let transform = "Any-Hex/Java"
        var completeDecodeTitle = NSMutableString()
        let firstCut = infoTitle.replacingOccurrences(of: "%20", with: " ", options: .literal, range: nil)
        let secondCut = firstCut.replacingOccurrences(of: "%u", with: " \\u", options: .literal, range: nil)
        let convertStringToArray = secondCut.characters.split{$0 == " "}.map(String.init)
        for decode in convertStringToArray {
            if decode.contains("\\u") {
                var convertedString = decode.mutableCopy() as! NSMutableString
                CFStringTransform(convertedString, nil,  transform as CFString!, true)
                completeDecodeTitle.append(convertedString as String)
            } else {
                if let word = String(decode.components(separatedBy: CharacterSet.letters.inverted).joined()) {
                    let index = convertStringToArray.index(of: word)
                    if index == 0 {
                        completeDecodeTitle.append("\(word)\n")
                    } else {
                        completeDecodeTitle.append(" \(word)")
                    }
                }
            }
        }
        articleTitle = completeDecodeTitle as String
        }
    }
    
    if let infoImageURL = info["img"] as? String,
      let decodedImageURL = infoImageURL.jsonDecoded() {
    
      imageURL = decodedImageURL
    }
    
    if let infoDateString = info["ts"] as? String {
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
      
      if let date = dateFormatter.date(from: infoDateString) {
        articleDate = NSDate(timeIntervalSinceNow: date.timeIntervalSinceNow)
      }
    }

    
    if let infoCount = info["count"] as? String,
      let decodedCount = infoCount.jsonDecoded(),
      let count = Int(decodedCount) {
      
      commentsCount = count
    }
    
    if let infoArticleID = info["articleId"] as? String,
      let decodedArticleID = infoArticleID.jsonDecoded() {
      
      articleID = decodedArticleID
    }
    
    if let infoApiKey = info["api_key"] as? String,
      let decodedApiKey = infoApiKey.jsonDecoded() {
      
      apiKey = decodedApiKey
    }
    
    if let infoArticleHost = info["host"] as? String,
      let decodedArticleHost = infoArticleHost.jsonDecoded() {
      
      host = decodedArticleHost
    }
    
    if let infoArticleURL = info["url"] as? String,
      let decodedArticleURL = infoArticleURL.jsonDecoded() {
      
      articleURL = decodedArticleURL
    }
  }
  
}
