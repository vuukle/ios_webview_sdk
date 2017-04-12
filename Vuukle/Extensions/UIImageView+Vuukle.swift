//
//  UIImageView+Vuukle.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
  
  var imageTint: UIColor {
    set {
      if let currentImage = self.image {
        
        self.image = currentImage.withRenderingMode(.alwaysTemplate)
        self.tintColor = newValue
      }
    }
    get {
      return self.tintColor
    }
  }

}
