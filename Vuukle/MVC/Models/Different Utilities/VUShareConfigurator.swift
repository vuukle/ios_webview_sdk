//
//  VUShareKitConfigurator.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit

class VUShareConfigurator {
  
  // MARK: Configure ShareVC
  static func configure(name: String, comment: String, url: String) -> UIActivityViewController {
  
    var shareText = "User: \"\(name)\" Commented: \"\(comment)\" On: "
   
    var shareItems = [Any]()
    
    if !shareText.isEmpty {
        UIPasteboard.general.string = shareText
    }
    
    if let shareURL = NSURL(string: "\(VUGlobals.requestParametes.articleURL)") {
      shareItems.append(shareURL)
    } else {
      shareText.append("\(url)")
    }
    
    shareItems.append(shareText)

    return UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
  }
  
  
  // MARK: Show as Phone or Pad
  static func presentShareKitAsPhone(_ shareVC: UIActivityViewController, cell: VUCommentCell) {
    
    shareVC.modalPresentationStyle = .overCurrentContext
    
    if let lBaseVC = VUCommentsBuilderModel.vBaseVC {
      
      lBaseVC.present(shareVC, animated: true, completion: nil)
      
      shareVC.completionWithItemsHandler = { activityType, completed, returnedItems, error in
        cell.hideProgress()
      }
    } else {
      cell.hideProgress()
    }
  }
  
  
  static func presentShareKitAsPad(_ shareVC: UIActivityViewController, button: UIButton, cell: VUCommentCell) {
    
    if let lBaseVC = VUCommentsBuilderModel.vBaseVC {
      
      shareVC.modalPresentationStyle = .popover
      lBaseVC.present(shareVC, animated: true, completion: nil)
      
      let popoverPC = shareVC.popoverPresentationController
      popoverPC?.sourceView = button
      popoverPC?.sourceRect = CGRect(x: 0, y: 0,
                                     width: button.frame.size.width,
                                     height: button.frame.size.height)
      
      shareVC.completionWithItemsHandler = { activityType, completed, returnedItems, error in
        cell.hideProgress()
      }
    } else {
      cell.hideProgress()
    }
  }
  
}
