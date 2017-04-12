//
//  VUAlertsHub.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit
import MBProgressHUD

class VUAlertsHub {

  private init() {}
  
  // MARK: - Showning of Alerts and HUDs
  static func showAlert(_ title: String,
                        message: String) {
    
    if let baseVC = VUCommentsBuilderModel.vBaseVC {
      baseVC.showAlert(title, message: message)
    }
  }
  
  static func showHUD(_ text: String,
                      image: VUAssetsIdentifier,
                      details: String? = nil) {
    
    if let baseVC = VUCommentsBuilderModel.vBaseVC {
      
      let hud = MBProgressHUD.showAdded(to: baseVC.view, animated: true)
      
      hud.mode = .customView
      
      let imageView = UIImageView(image: UIImage(assetIdentifier: image))
      imageView.imageTint = UIColor.darkGray
      
      hud.customView = imageView
      hud.label.text = text
      
      if let lDetails = details {
        hud.detailsLabel.text = lDetails
        hud.detailsLabel.font = hud.label.font
      }
      
      hud.removeFromSuperViewOnHide = true
      hud.isUserInteractionEnabled = false
      
      hud.hide(animated: true, afterDelay: 2)
    }
  }
  
}
