//
//  VUEmojiVotingModel.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit

class VUEmojiVotingModel {

  private let questionText = "What is your reaction?"
  private let votedText = "Thank your for voting!"
  
  
  // MARK: - Model
  var emojiArray = [VUEmojiModel]()
  var totalVotes = 0
  private(set) var title = ""

  var votedIndex: Int?
  
  
  // MARK: - Init
  init(_ articleID: String) {
    
    let index = UserDefaults.standard.value(forKey: "VUUKLE_VOTED_\(articleID)") as? Int
    setVotedIndex(index)
    
    let happyEmoji = VUEmojiModel(type: .emojiHappyIcon,
                                  title: "HAPPY")
    
    let neutralEmoji = VUEmojiModel(type: .emojiNeutralIcon,
                                    title: "NEUTRAL")
    
    let amusedEmoji = VUEmojiModel(type: .emojiAmusedIcon,
                                   title: "AMUSED")
    
    let excitedEmoji = VUEmojiModel(type: .emojiExictedIcon,
                                    title: "EXCITED")
    
    let angryEmoji = VUEmojiModel(type: .emojiAngryIcon,
                                  title: "ANGRY")
    
    let sadEmoji = VUEmojiModel(type: .emojiSadIcon,
                                title: "SAD")
    
    emojiArray = [happyEmoji, neutralEmoji, amusedEmoji, excitedEmoji, angryEmoji, sadEmoji]
  }
  
  
  // MARK: - Class methods
  func setCommentRatingInfo(_ info: NSDictionary) {
    
    if let emojiInfo = info["emotes"] as? NSDictionary {
      
      let happyVotes = Int(emojiInfo["first"] as? Int64 ?? 0)
      let neutralVotes = Int(emojiInfo["second"] as? Int64 ?? 0)
      let amusedVotes  = Int(emojiInfo["third"] as? Int64 ?? 0)
      let excitedVotes = Int(emojiInfo["fourth"] as? Int64 ?? 0)
      let angryVotes = Int(emojiInfo["fifth"] as? Int64 ?? 0)
      let sadVotes   = Int(emojiInfo["sixth"] as? Int64 ?? 0)
      
      totalVotes = happyVotes + neutralVotes + amusedVotes + excitedVotes + angryVotes + sadVotes

      if emojiArray.count != 6 {
        return
      }
      
      emojiArray[0].setInfo(votes: happyVotes,
                            totalVotes: totalVotes,
                            index: 0,
                            votedIndex: votedIndex)
      
      emojiArray[1].setInfo(votes: neutralVotes,
                            totalVotes: totalVotes,
                            index: 1,
                            votedIndex: votedIndex)
      
      emojiArray[2].setInfo(votes: amusedVotes,
                            totalVotes: totalVotes,
                            index: 2,
                            votedIndex: votedIndex)
      
      emojiArray[3].setInfo(votes: excitedVotes,
                            totalVotes: totalVotes,
                            index: 3,
                            votedIndex: votedIndex)
      
      emojiArray[4].setInfo(votes: angryVotes,
                            totalVotes: totalVotes,
                            index: 4,
                            votedIndex: votedIndex)
      
      emojiArray[5].setInfo(votes: sadVotes,
                            totalVotes: totalVotes,
                            index: 5,
                            votedIndex: votedIndex)
      findMostVotedEmoji()
    }
  }

  // MARK: Support methods
  func setVotedIndex(_ index: Int?, isUpdate: Bool = false) {
    
    if index == nil {
      votedIndex = nil
      title = questionText
      
    } else {
      votedIndex = index
      title = votedText
    
      findMostVotedEmoji(totalVotes: totalVotes,
                         votedIndex: votedIndex)
      
      let articleID = VUGlobals.requestParametes.articleID
      UserDefaults.standard.setValue(votedIndex, forKey: "VUUKLE_VOTED_\(articleID)")
    }
  }
  
  func findMostVotedEmoji(totalVotes: Int? = nil,
                          votedIndex: Int? = nil) {
    
    var mostVotes = 0
    var mostVotedEmojiIndex = 0
    
    for i in 0..<emojiArray.count {
      
      if let votedIndex = votedIndex, votedIndex == i {
        emojiArray[i].isVoted = true
      }
      
      if let totalVotes = totalVotes {
        emojiArray[i].updatePercentage(totalVotes: totalVotes)
      }
    
      if mostVotes < emojiArray[i].votesCount {
       
        mostVotes = emojiArray[i].votesCount
        mostVotedEmojiIndex = i
      }
    }
    
    if emojiArray.indices.contains(mostVotedEmojiIndex) {
      emojiArray[mostVotedEmojiIndex].isMostVoted = true
    
      for i in 0..<emojiArray.count {
        if i != mostVotedEmojiIndex {
          emojiArray[i].isMostVoted = false
        }
      }
    }
  }
  
}

