//
//  VUEmojiCell.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit

protocol VUEmojiCellDelegate {
  
  func didSelectEmoji(emojiCell: VUEmojiCell, button: UIButton)
}


class VUEmojiCell: UICollectionViewCell {
  
  var delegate: VUEmojiCellDelegate?
  
  
  // MARK: - @IBOutlets
  @IBOutlet weak var votesPercentageLabel: UILabel!
  @IBOutlet weak var votesPercentageWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var emojiNameLabel: UILabel!
  @IBOutlet weak var emojiButton: UIButton!
 
  
  // MARK: - Lifecycle
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setEmojiCellDesign()
  }
  

  // MARK: - Public methods
  func setInfo(_ emojiImage: UIImage,
               title: String,
               isMostVoted: Bool,
               votesPercentage: Int) {
    
    if let emojiNameLabel = emojiNameLabel,
      let emojiButton = emojiButton {
      
      emojiNameLabel.text = title
      emojiButton.setImage(emojiImage, for: .normal)
    }
    
    setMostVoted(isMostVoted)
    setVotesPercentage(votesPercentage)
  }
  

  // MARK: - Button actions
  @IBAction func emojiButtonAction(_ sender: UIButton) {
    sender.showAnimatedTap(0.84)
    
    delegate?.didSelectEmoji(emojiCell: self, button: sender)
  }
 
  
  // MARK: - Supporting methos
  private func setVotesPercentage(_ votesPercentage: Int) {
    
    if let votesPercentageLabel = votesPercentageLabel,
      let votesPercentageWidthConstraint = votesPercentageWidthConstraint {
      
      let percentageText = "\(votesPercentage)%"
      
      votesPercentageLabel.text = percentageText
      votesPercentageWidthConstraint.constant = CGFloat(percentageText.characters.count * 8) + 12.0
    }
  }
  
  func setMostVoted(_ isMostVoted: Bool) {
    
    if let votesPercentageLabel = votesPercentageLabel {
      
      if isMostVoted {
        votesPercentageLabel.textColor = VUDesignHUB.emojiVotingCell.percentageTopTextColor
        votesPercentageLabel.backgroundColor = VUDesignHUB.emojiVotingCell.percentageTopBackgroundColor
        
      } else {
        votesPercentageLabel.textColor = VUDesignHUB.emojiVotingCell.percentageTextColor
        votesPercentageLabel.backgroundColor = VUDesignHUB.emojiVotingCell.percentageBackgroundColor
      }
    }
  }
  
  // TODO: • Seting design
  private func setEmojiCellDesign() {
    
    guard let emojiNameLabel = emojiNameLabel,
      let votesPercentageLabel = votesPercentageLabel else {
        return
    }
    
    switch VUDesignHUB.colorsType {
      
    case .dayColors:
      
      emojiNameLabel.textColor = VUDesignHUB.emojiVotingCell.emojiMoodTextColor
      votesPercentageLabel.backgroundColor = VUDesignHUB.emojiVotingCell.percentageBackgroundColor
      votesPercentageLabel.textColor = VUDesignHUB.emojiVotingCell.percentageTextColor
      
    case .nightColors:
      
      emojiNameLabel.textColor = VUDesignHUB.emojiVotingCellNight.emojiMoodTextColor
      votesPercentageLabel.backgroundColor = VUDesignHUB.emojiVotingCellNight.percentageBackgroundColor
      votesPercentageLabel.textColor = VUDesignHUB.emojiVotingCellNight.percentageTextColor
    }
  }
  
  // MARK: - Notifications
  private func addObserverForNewDesignNotification() {
    
    NotificationCenter.default.addObserver(forName: VUGlobals.nSetNewDesign,
                                           object: nil,
                                           queue: nil) { [weak self] (notification) in
                                            
      guard let exSelf = self else {
        return
      }
      
      exSelf.setEmojiCellDesign()
    }
  }

}
