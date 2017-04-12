//
//  UIColor+Vuukle.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  
  // MARK: - Vuukle colors
  class var vuukleOrange: UIColor {
    return UIColor(colorLiteralRed:  0.968462, green: 0.606849, blue: 0.275868, alpha: 1)
  }
  
  class var vuukleRed: UIColor {
    return UIColor(colorLiteralRed: 0.847, green: 0.016, blue: 0.000, alpha: 1)
  }
  
  class var vuukleBlue: UIColor {
    return UIColor(colorLiteralRed: 0.211, green: 0.525, blue: 0.972, alpha: 1)
  }
  
  class var vuukleGray: UIColor {
    return UIColor(colorLiteralRed: 0.5, green: 0.5, blue: 0.5, alpha: 1)
  }
  
  class var vuukleLightGray: UIColor {
    return UIColor(colorLiteralRed: 0.723, green: 0.723, blue: 0.723, alpha: 1)
  }
  
  
  // MARK: - Colors for voting
  class var vuukleVotingHappy: UIColor {
    return UIColor(colorLiteralRed: 0.092, green: 0.782, blue: 0.519, alpha: 1)
  }
  
  class var vuukleVotingNeutral: UIColor {
    return UIColor(colorLiteralRed: 0.953, green: 0.755, blue: 0.120, alpha: 1)
  }
  
  class var vuukleVotingAmused: UIColor {
    return UIColor(colorLiteralRed: 0.189, green: 0.554, blue: 0.984, alpha: 1)
  }
  
  class var vuukleVotingExcited: UIColor {
    return UIColor(colorLiteralRed: 0.625, green: 0.373, blue: 0.751, alpha: 1)
  }
  
  class var vuukleVotingAngry: UIColor {
    return UIColor(colorLiteralRed: 1.000, green: 0.271, blue: 0.000, alpha: 1)
  }
  
  class var vuukleVotingSad: UIColor {
    return UIColor(colorLiteralRed: 0.789, green: 0.560, blue: 0.485, alpha: 1)
  }
  
  
  // MARK: - Static methods
  static func colourWith0to255(red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
    
    return UIColor(red: CGFloat(red) / 255.0,
                   green: CGFloat(green) / 255.0,
                   blue: CGFloat(blue) / 255.0,
                   alpha: CGFloat(alpha))
  }
  
}
