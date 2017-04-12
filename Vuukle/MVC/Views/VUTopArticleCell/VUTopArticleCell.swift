//
//  VUTopArticleCell.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit
import NSDate_TimeAgo


// MARK: - VUTopArticleCellDelegate
protocol VUTopArticleCellDelegate {
  
  func openTopArticle(_ topArticleCell: VUTopArticleCell, button: UIButton)
}


// MARK: - VUTopArticleCell
class VUTopArticleCell: UITableViewCell {
  
  var delegate: VUTopArticleCellDelegate?
  
  
  // MARK: - @IBOutlets
  @IBOutlet weak var articleImageContentView: UIView!
  @IBOutlet weak var articleImageView: UIImageView!
  @IBOutlet weak var articleTitleLabel: UILabel!
  
  @IBOutlet weak var openArticleButton: UIButton!

  @IBOutlet weak var articleTimeLabel: UILabel!
  @IBOutlet weak var commentsCountLabel: UILabel!
  @IBOutlet weak var commentCountWidthConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
  
  
  // MARK: - Lifecycle
  override func awakeFromNib() {
    super.awakeFromNib()

    guard let articleImageContentView = articleImageContentView,
      let activityIndicator = imageActivityIndicator else {
        return
    }

    activityIndicator.isHidden = true
    
    articleImageContentView.layer.borderWidth = 1.0 / UIScreen.main.scale
    articleImageContentView.layer.borderColor = UIColor.lightGray.cgColor
    
    setLoadMoreCellDesign()
    addObserverForNewDesignNotification()
  }
  
  
  // MARK: - Public methods
  func setArticle(title: String,
                  date: NSDate,
                  commentsCount: Int,
                  imageURL: String?) {
    
    if let articleTitleLabel = articleTitleLabel {
      articleTitleLabel.text = title
    }

    if let articleTimeLabel = articleTimeLabel {
      articleTimeLabel.text = date.timeAgo()
    }
    
    setComments(count: commentsCount)
    setArticleImage(from: imageURL)
  }
  
  
  // MARK: - Button action
  @IBAction func openArticleButtonAction(_ sender: UIButton) {
    showTapOnArticle()
    
    delegate?.openTopArticle(self, button: sender)
  }
  
  
  // MARK: - Notifications
  private func addObserverForNewDesignNotification() {
    
    NotificationCenter.default.addObserver(forName: VUGlobals.nSetNewDesign, object: nil,  queue: nil) { [weak self] (notification) in
      
      guard let exSelf = self else {
        return
      }
      
      exSelf.setLoadMoreCellDesign()
    }
  }
  
  // MARK: - Support methods
  private func setComments(count: Int) {
    
    if let countLabel = commentsCountLabel,
      let widthConstraint = commentCountWidthConstraint {
      
        var text = ""
        if count <= 1 {
            text = "\(count) comment"
        } else {
            text = "\(count) comments"
        }
      countLabel.text = text
      
      let width: CGFloat = CGFloat(text.characters.count + 2) * 8.0
      let maxWidth: CGFloat = UIScreen.main.bounds.width - 86.0
      
      if width < maxWidth {
        widthConstraint.constant = width
        
      } else {
        widthConstraint.constant = maxWidth
      }
    }
  }
  
  // TODO: •  Article Image
  private func setArticleImage(from: String?) {
    
    if let articleImageView = articleImageView,
      let activityIndicator = imageActivityIndicator {
      
      if let imageURL = from {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        vuuklePrint("[Top Article Cell] Article Image URL")
        
        downloadArticleImage(imageURL)
        
      } else {
        articleImageView.image = UIImage(assetIdentifier: .topArticlePlaceholder)
      }
    }
  }
  
  private func downloadArticleImage(_ fromURL: String) {
    
    VUServerManager.downloadImage(fromURL) { [weak self] (image, error) in
      
      guard let exSelf = self,
        let articleImageView = exSelf.articleImageView,
        let activityIndicator = exSelf.imageActivityIndicator else {
        return
      }
      
      activityIndicator.stopAnimating()
      activityIndicator.isHidden = true
      
      if let image = image {
        
        if let resizedImage = image.resize(newWidth: articleImageView.frame.width * UIScreen.main.scale) {
          articleImageView.image = resizedImage
          
        } else {
          articleImageView.image = image
        }
      } else {
        articleImageView.image = UIImage(assetIdentifier: .topArticlePlaceholder)
      }
    }
  }
  
  private func showTapOnArticle() {
    
    if VUCommentsBuilder.delegate != nil {
      
      UIView.animate(withDuration: 0.3, animations: { [weak self] in
        
        guard let exSelf = self else {
          return
        }
        exSelf.alpha = 0.6
        
      }) { (isCompleted) in
        
        UIView.animate(withDuration: 0.3) { [weak self] in
          
          guard let exSelf = self else {
            return
          }
          exSelf.alpha = 1.0
        }
      }
    }
  }
  
  // MARK: - Design and colors
  func setLoadMoreCellDesign() {
    
    guard let articleImageContentView = articleImageContentView,
      let articleTitleLabel = articleTitleLabel,
      let articleTimeLabel = articleTimeLabel,
      let commentsCountLabel = commentsCountLabel else {
        return
    }
    
    switch VUDesignHUB.colorsType {
      
    case .dayColors:
      
      articleImageContentView.layer.borderColor = VUDesignHUB.talkOfTheTownCell.imageBorderColor.cgColor
      
      articleTitleLabel.textColor = VUDesignHUB.talkOfTheTownCell.titleTextColor
      articleTimeLabel.textColor = VUDesignHUB.talkOfTheTownCell.timeTextColor
      
      commentsCountLabel.textColor = VUDesignHUB.talkOfTheTownCell.commentsCountTextColor
      commentsCountLabel.backgroundColor = VUDesignHUB.talkOfTheTownCell.commentsCountBackground
      
    case .nightColors:
      
      articleImageContentView.layer.borderColor = VUDesignHUB.talkOfTheTownCellNight.imageBorderColor.cgColor
      
      articleTitleLabel.textColor = VUDesignHUB.talkOfTheTownCellNight.titleTextColor
      articleTimeLabel.textColor = VUDesignHUB.talkOfTheTownCellNight.timeTextColor
      
      commentsCountLabel.textColor = VUDesignHUB.talkOfTheTownCellNight.commentsCountTextColor
      commentsCountLabel.backgroundColor = VUDesignHUB.talkOfTheTownCellNight.commentsCountBackground
    }
  }
}
