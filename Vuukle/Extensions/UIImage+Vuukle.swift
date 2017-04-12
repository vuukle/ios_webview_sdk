//
//  UIImage+Vuukle.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
  
  // MARK: - New initalizers
  convenience init(assetIdentifier: VUAssetsIdentifier) {
    
    self.init(named: assetIdentifier.rawValue,
              in: Bundle(for: VUCommentsVC.self),
              compatibleWith: nil)!
  }
  
  
  // MARK: - Static methods
  func resize(newWidth: CGFloat) -> UIImage? {
    
    if self.size.width < newWidth {
      return nil
    }
    
    let scale = newWidth / self.size.width
    let newHeight = self.size.height * scale
    
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    
    self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return newImage
  }
  
  func maskWithColor(color: UIColor) -> UIImage? {
    
    if let maskImage = cgImage {
      
      let width = size.width
      let height = size.height
      let bounds = CGRect(x: 0, y: 0, width: width, height: height)
      
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
      
      if let context = CGContext(data: nil,
                                 width: Int(width),
                                 height: Int(height),
                                 bitsPerComponent: 8,
                                 bytesPerRow: 0,
                                 space: colorSpace,
                                 bitmapInfo: bitmapInfo.rawValue) {
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
          
          let coloredImage = UIImage(cgImage: cgImage)
          return coloredImage
        }
      }
    }
    return nil
  }
  
}
