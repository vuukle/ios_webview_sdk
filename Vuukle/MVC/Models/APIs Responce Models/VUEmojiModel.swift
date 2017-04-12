//
//  VUEmojiModel.swift
//  Pods
//
//  Created by Alex Chaku on 10.02.17.
//
//

import UIKit

class VUEmojiModel {

  // MARK: - Model
  var emojiImage = UIImage()
  var emojiTitle = ""
  var votesCount = 0
  var votesPercentage = 0
  
  var isVoted = false
  var isMostVoted = false
  
  // MARK: - Init
  init(type: VUAssetsIdentifier,
       title: String) {
    
    emojiImage = UIImage(assetIdentifier: type)
    emojiTitle = title
  }
  
  
  // MARK: - Set info
  func setInfo(votes: Int,
               totalVotes: Int,
               index: Int,
               votedIndex: Int?) {
    
    if let votedIndex = votedIndex, votedIndex == index {
      isVoted = true
    } else {
      isVoted = false
    }

    votesCount = votes
    
    if totalVotes != 0 {
      votesPercentage = Int((Float(votes) / Float(totalVotes)) * 100.0)
    }
  }
  
  func updatePercentage(totalVotes: Int) {
   
    if totalVotes != 0 {
      votesPercentage = Int((Float(votesCount) / Float(totalVotes)) * 100.0)
    }
  }
  
}
