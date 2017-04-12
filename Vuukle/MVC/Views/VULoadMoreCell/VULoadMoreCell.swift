//
//  VULoadMoreCell.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit


protocol VULoadMoreCellDelegate {
  
  func loadMoreButtonPressed(_ cell: VULoadMoreCell, button: UIButton)
  func openVuukleButtonPressed(_ cell: VULoadMoreCell, button: UIButton)
}


// MARK:
class VULoadMoreCell: UITableViewCell {

  var delegate: VULoadMoreCellDelegate?
  
  var totalCount = 0
  var loadedCount = 0
  
  // MARK: - Code changeable constraints
  @IBOutlet weak var loadMoreButtonHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var logoAndButtonSpacingConstaint: NSLayoutConstraint!
  
  // MARK: - @IBOutlets
  @IBOutlet weak var versionLabel: UILabel!
  @IBOutlet weak var loadMoreButton: UIButton!
  @IBOutlet weak var openVuukleButton: UIButton!
  @IBOutlet weak var alreadyLoadedLabel: UILabel!
  
  @IBOutlet weak var versionContentView: UIView!
  
  @IBOutlet weak var cellActivityIndicator: UIActivityIndicatorView!
  
  
  // MARK: - Lifecycle
  override func awakeFromNib() {
    super.awakeFromNib()
    
    if let versionLabel = versionLabel {
      versionLabel.text = "version - \(VUGlobals.vuukleVersion)"
    }
    
    setLoadMoreCellDesign()
    
    addObserverForTotatCountUpdate()
    addObserverForLoadedCountUpdate()
    addObserverForNewDesignNotification()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  
  // MARK: Public methods
  func setLoadMoreButtonVisible(_ isVisible: Bool, loadedCount: Int, totalCount: Int) {
    
    self.loadedCount = loadedCount
    self.totalCount = totalCount

    setLoadMoreButtonHiden(isVisible)
    updateLoadedAndTotalCountLabel()
  }

  
  // MARK: Buttons actions
  @IBAction func loadMoreButtonAction(_ sender: UIButton) {
    sender.showAnimatedTap(0.94)
    
    if let delegate = delegate {
      showProgress()
      delegate.loadMoreButtonPressed(self, button: sender)
    }
  }
  
  @IBAction func openVuukleButtonAction(_ sender: UIButton) {
    
    
  }
  
  
  // MARK: - Showing of progress
  func showProgress() {
    
    self.contentView.isUserInteractionEnabled = false
    self.alpha = 0.4
    
    if let indicator = cellActivityIndicator {
      indicator.startAnimating()
    }
  }
  
  func hideProgress() {
    
    self.contentView.isUserInteractionEnabled = true
    self.alpha = 1
    
    if let indicator = cellActivityIndicator {
      indicator.stopAnimating()
    }
  }
  
  
  // MARK: - Notifications
  private func addObserverForTotatCountUpdate() {
    
    NotificationCenter.default.addObserver(forName: VUGlobals.nTotalCountUpdate,
                                           object: nil,
                                           queue: nil) { [weak self] (notification) in
      
      guard let exSelf = self, let newCount = notification.object as? Int else {
        return
      }
      
      exSelf.totalCount = newCount
      exSelf.updateLoadedAndTotalCountLabel()
    }
  }
  
  private func addObserverForLoadedCountUpdate() {
    
    NotificationCenter.default.addObserver(forName: VUGlobals.nLoadedCountUpdate,
                                           object: nil,
                                           queue: nil) { [weak self] (notification) in
      
      guard let exSelf = self, let newCount = notification.object as? Int else {
        return
      }
      
      exSelf.loadedCount = newCount
      exSelf.updateLoadedAndTotalCountLabel()
    }
  }
  
  private func addObserverForNewDesignNotification() {
    
    NotificationCenter.default.addObserver(forName: VUGlobals.nSetNewDesign, object: nil,  queue: nil) { [weak self] (notification) in
      
      guard let exSelf = self else {
        return
      }
      
      exSelf.setLoadMoreCellDesign()
    }
  }
  
  // MARK: - Supporting methods
  private func updateLoadedAndTotalCountLabel() {
    
    if let countLabel = alreadyLoadedLabel {
      countLabel.text = "Already loaded \(loadedCount) from \(totalCount) comments"
    }
  }
  
  private func setLoadMoreButtonHiden(_ isVisible: Bool) {
    
    if isVisible {
      
      loadMoreButton.isHidden = false
      loadMoreButtonHeightConstraint.constant = 34.0
      logoAndButtonSpacingConstaint.constant = 8.0
      
    } else {
      
      loadMoreButton.isHidden = true
      loadMoreButtonHeightConstraint.constant = 0
      logoAndButtonSpacingConstaint.constant = 0
    }
  }
  
  // MARK: - Design and colors
  func setLoadMoreCellDesign() {
    
    guard let alreadyLoadedLabel = alreadyLoadedLabel,
      let loadMoreButton = loadMoreButton,
      let versionLabel = versionLabel,
      let versionContentView = versionContentView,
      let cellActivityIndicator = cellActivityIndicator else {
        return
    }
    
    switch VUDesignHUB.colorsType {
      
    case .dayColors:
      
      versionLabel.textColor = UIColor.darkGray
      versionContentView.alpha = 1
      cellActivityIndicator.color = VUDesignHUB.general.progressIndicatorColor

      alreadyLoadedLabel.textColor = VUDesignHUB.loadMoreCell.alreadyLoadedTextColor
      
      loadMoreButton.setTitleColor(VUDesignHUB.loadMoreCell.loadMoreButtonTextColor,
                                   for: .normal)
      loadMoreButton.setTitleColor(VUDesignHUB.loadMoreCell.loadMoreButtonTextColor,
                                   for: .highlighted)
      loadMoreButton.setTitleColor(VUDesignHUB.loadMoreCell.loadMoreButtonTextColor,
                                   for: .selected)

      loadMoreButton.backgroundColor = VUDesignHUB.loadMoreCell.loadMoreButtonBackgroundColor
      
    case .nightColors:
      
      versionLabel.textColor = UIColor.gray
      versionContentView.alpha = 0.9
      cellActivityIndicator.color = VUDesignHUB.generalNight.progressIndicatorColor
      
      alreadyLoadedLabel.textColor = VUDesignHUB.loadMoreCellNight.alreadyLoadedTextColor
      
      loadMoreButton.setTitleColor(VUDesignHUB.loadMoreCellNight.loadMoreButtonTextColor,
                                   for: .normal)
      loadMoreButton.setTitleColor(VUDesignHUB.loadMoreCellNight.loadMoreButtonTextColor,
                                   for: .highlighted)
      loadMoreButton.setTitleColor(VUDesignHUB.loadMoreCellNight.loadMoreButtonTextColor,
                                   for: .selected)
      
      loadMoreButton.backgroundColor = VUDesignHUB.loadMoreCellNight.loadMoreButtonBackgroundColor
    }
  }
  
  
}
