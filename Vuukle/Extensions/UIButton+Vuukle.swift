//
//  UIButton+Vuukle.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {

  // MARK: - New funcs
  func showAnimatedTap(_ scale: CGFloat, isShowSelection: Bool = false) {
 
    self.isUserInteractionEnabled = false
    
    UIView.animate(withDuration: 0.1,
                   animations: { [weak self] in
                    
                    guard let exSelf = self else {
                      return
                    }
                    
                    if isShowSelection {
                      exSelf.isSelected = true
                    }
                    exSelf.transform = CGAffineTransform(scaleX: scale, y: scale)
      
      }, completion: { _ in
        
        UIView.animate(withDuration: 0.6,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 4.0,
                       options: .allowUserInteraction, animations: { [weak self] in
                        
                        guard let exSelf = self else {
                          return
                        }
                      
                        exSelf.transform = .identity
                        
        }, completion: { _ in
          
          if isShowSelection {
            
            UIView.animate(withDuration: 0.08) { [weak self] in
             
              guard let exSelf = self else {
                return
              }
              exSelf.isSelected = false
            }
          }
        })
    })
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
      
      guard let exSelf = self else {
        return
      }
      
      exSelf.isUserInteractionEnabled = true
    }
  }
  
  
  func setImageTint(_ color: UIColor) {
    
    if let currnetImage = self.image(for: .normal) {
      
      let tinedImage = currnetImage.withRenderingMode(.alwaysTemplate)
      
      self.setImage(tinedImage, for: .normal)
      self.tintColor = color
    }
  }
  
}
