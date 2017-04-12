//
//  VUEmojiVotingCell.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit

protocol VUEmojiVotingCellDelegate {
  
  func didSelectEmoji(_ emojiVotingCell: VUEmojiVotingCell,
                      atIndex: Int,
                      emojiModel: VUEmojiModel)
}


class VUEmojiVotingCell: UITableViewCell {
  
  var delegate: VUEmojiVotingCellDelegate?
  var emojiArray = [VUEmojiModel]()
  
  var votedEmojiIndex: Int?
  lazy var colorsArray = [UIColor.vuukleVotingHappy,
                          UIColor.vuukleVotingNeutral,
                          UIColor.vuukleVotingAmused,
                          UIColor.vuukleVotingExcited,
                          UIColor.vuukleVotingAngry,
                          UIColor.vuukleVotingSad]
  
  // MARK: - @IBOutlets
  @IBOutlet weak var votingTitleLabel: UILabel!
  @IBOutlet weak var totalVotesLabel: UILabel!
  @IBOutlet weak var totalVotesWidthConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var emojiCollectionView: UICollectionView!
  @IBOutlet weak var emojiFlowLayout: UICollectionViewFlowLayout!
  
  @IBOutlet weak var cellActivityIndicator: UIActivityIndicatorView!
  
  
  // MARK: - Lifecycle
  override func awakeFromNib() {
    super.awakeFromNib()
    
    registerCollectionViewCells()
    
    if let cellActivityIndicator = cellActivityIndicator {
      cellActivityIndicator.isHidden = true
    }
    
    setEmojiVotingCellDesign()
    
    addObserverForUpdateFrameNotification()
    addObserverForNewModelNotification()
    addObserverForNewDesignNotification()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  
  // MARK: - Public methods
  func setInfo(_ emojiVotingModel: VUEmojiVotingModel) {
    
    if let votingTitleLabel = votingTitleLabel {
      votingTitleLabel.text = emojiVotingModel.title
    }
    
    emojiArray = emojiVotingModel.emojiArray
    votedEmojiIndex = emojiVotingModel.votedIndex
    
    if let emojiCollectionView = emojiCollectionView {
      emojiCollectionView.reloadData()
    }
    
    setTotalVotes(emojiVotingModel.totalVotes)
  }
  
  
  // MARK: - Showing of progress
  func showProgress() {
    
    self.contentView.isUserInteractionEnabled = false
    self.alpha = 0.4
    
    if let indicator = cellActivityIndicator {
      
      indicator.isHidden = false
      indicator.startAnimating()
    }
  }
  
  func hideProgress() {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
      
      guard let exSelf = self else {
        return
      }
      
      exSelf.contentView.isUserInteractionEnabled = true
      exSelf.alpha = 1
      
      if let indicator = exSelf.cellActivityIndicator {
        
        indicator.isHidden = true
        indicator.stopAnimating()
      }
    }
  }
  
  
  // MARK: - Notifications
  private func addObserverForUpdateFrameNotification() {
    
    NotificationCenter.default.addObserver(forName: VUGlobals.nEmojiUpdateFrames,
                                           object: nil,
                                           queue: nil) { [weak self] (notification) in
      guard let exSelf = self else {
        return
      }

      exSelf.setEmojiSize()
    }
  }
  
  private func addObserverForNewModelNotification() {
    
    NotificationCenter.default.addObserver(forName: VUGlobals.nEmojiUpdateModels,
                                           object: nil,
                                           queue: nil) { [weak self] (notification) in
      
      guard let exSelf = self,
        let emojiVotingModel = notification.object as? VUEmojiVotingModel else {
          return
      }
   
      exSelf.setInfo(emojiVotingModel)
    }
  }
  
  private func addObserverForNewDesignNotification() {
    
    NotificationCenter.default.addObserver(forName: VUGlobals.nSetNewDesign,
                                           object: nil,
                                           queue: nil) { [weak self] (notification) in
      
      guard let exSelf = self else {
          return
      }
      
      exSelf.setEmojiVotingCellDesign()
    }
  }
  
  
  // MARK: - Support methods
  private func registerCollectionViewCells() {
    
    let emojiNib = UINib(nibName: "VUEmojiCell", bundle: Bundle(for: VUCommentsVC.self))
    
    emojiCollectionView.register(emojiNib,
                                 forCellWithReuseIdentifier: VUIdentifiersUI.VUEmojiCell)
  }
 
  // TODO: • Seting Emoji frame size
  private func setEmojiSize() {
    
    let emojiWidth = self.emojiCollectionView.bounds.width / 6
    var emojiHeight = emojiWidth * (44.0 / 27.0)
    
    if emojiHeight >= 120 {
      emojiHeight = 120
    }
    
    emojiFlowLayout.itemSize = CGSize(width: emojiWidth,
                                      height: emojiHeight)
    
    emojiCollectionView.setCollectionViewLayout(emojiFlowLayout,
                                                animated: true)
  }
  
  private func setTotalVotes(_ votes: Int) {
    
    if let totalVotesLabel = totalVotesLabel,
      let totalVotesWidthConstraint = totalVotesWidthConstraint {
      
      let votesText = "\(votes)"
      
      totalVotesLabel.text = votesText
      totalVotesWidthConstraint.constant = CGFloat(votesText.characters.count * 8) + 16.0
    }
  }
  
  
  // TODO: • Set design
  private func setEmojiVotingCellDesign() {
    
    guard let votingTitleLabel = votingTitleLabel,
      let totalVotesLabel = totalVotesLabel,
      let cellActivityIndicator = cellActivityIndicator else {
        return
    }
    
    switch VUDesignHUB.colorsType {
   
    case .dayColors:
      
      votingTitleLabel.textColor = VUDesignHUB.emojiVotingCell.titleTextColor
      totalVotesLabel.textColor  = VUDesignHUB.emojiVotingCell.totalCountTextColor
      totalVotesLabel.backgroundColor = VUDesignHUB.emojiVotingCell.totalCountBackgroundColor
      cellActivityIndicator.color = VUDesignHUB.general.progressIndicatorColor
      
    case .nightColors:
      
      votingTitleLabel.textColor = VUDesignHUB.emojiVotingCellNight.titleTextColor
      totalVotesLabel.textColor  = VUDesignHUB.emojiVotingCellNight.totalCountTextColor
      totalVotesLabel.backgroundColor = VUDesignHUB.emojiVotingCellNight.totalCountBackgroundColor
      cellActivityIndicator.color = VUDesignHUB.generalNight.progressIndicatorColor
    }
  }
  
}


// MARK: - UICollectionViewDataSource
extension VUEmojiVotingCell: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    
    return emojiArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let emojiModel = emojiArray[indexPath.row]

    let cell = emojiCollectionView.dequeueReusableCell(withReuseIdentifier: VUIdentifiersUI.VUEmojiCell, for: indexPath) as? VUEmojiCell ?? VUEmojiCell()
   
    cell.delegate = self
  
    cell.setInfo(emojiModel.emojiImage,
                 title: emojiModel.emojiTitle,
                 isMostVoted: emojiModel.isMostVoted,
                 votesPercentage: emojiModel.votesPercentage)

    if let emojiNameLabel = cell.emojiNameLabel {
      
      if let votedEmojiIndex = votedEmojiIndex,
        votedEmojiIndex == indexPath.row {
        
        emojiNameLabel.textColor = colorsArray[indexPath.row]
        
      } else {
        emojiNameLabel.textColor = VUDesignHUB.emojiVotingCell.emojiMoodTextColor
      }
    }
    
    return cell
  }
}


// MARK: - VUEmojiCellDelegate
extension VUEmojiVotingCell: VUEmojiCellDelegate {
  
  func didSelectEmoji(emojiCell: VUEmojiCell, button: UIButton) {
  
    if let emojiIndex = emojiCollectionView.indexPath(for: emojiCell),
      emojiArray.indices.contains(emojiIndex.row) {
      
      delegate?.didSelectEmoji(self,
                               atIndex: emojiIndex.row,
                               emojiModel: emojiArray[emojiIndex.row])
    }
  }
}
