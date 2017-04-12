//
//  VUBackgroundButton.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit

class VUCustumButton: UIButton {

  // MARK: Override basic methods
  override open var isHighlighted: Bool {
    set {
      if newValue {
        self.alpha = 0.8
      } else {
        self.alpha = 1
      }
      super.isHighlighted = newValue
    }
    get {
      return super.isHighlighted
    }
  }
}
