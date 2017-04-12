//
//  UIDevice+Vuukle.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
  
  var deviceType: VUCurrentDeviceType {
    
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    
    let identifier = machineMirror.children.reduce("") { identifier, element in
      
      guard let value = element.value as? Int8, value != 0 else {
        return identifier
      }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    
    switch identifier {
   
    case "iPod5,1", "iPod7,1":
      return .iPodTouch
   
    case "iPhone3,1", "iPhone3,2", "iPhone3,3", "iPhone4,1":
      return .iPhone4
   
    case "iPhone5,1", "iPhone5,2","iPhone5,3", "iPhone5,4", "iPhone6,1", "iPhone6,2", "iPhone8,4":
      return .iPhone5
   
    case "iPhone7,2", "iPhone8,1", "iPhone9,1", "iPhone9,3":
      return .iPhone6
      
    case "iPhone7,1", "iPhone8,2", "iPhone9,2", "iPhone9,4":
      return .iPhonePlus

    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4", "iPad3,1", "iPad3,2", "iPad3,3", "iPad3,4", "iPad3,5", "iPad3,6", "iPad4,1", "iPad4,2", "iPad4,3", "iPad Air","iPad5,3", "iPad5,4":
      return .iPadRetina
      
    case "iPad2,5", "iPad2,6", "iPad2,7", "iPad4,4", "iPad4,5", "iPad4,6", "iPad Mini 2", "iPad4,7", "iPad4,8", "iPad4,9", "iPad5,1", "iPad5,2":
      return .iPadMini
      
    case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":
      return .iPadPro
    
    case "i386", "x86_64":
      return simulatorDeviceType
      
    default:
      return .unknown
    }
  }
  
  private var simulatorDeviceType: VUCurrentDeviceType {
    
    if UIDevice.current.userInterfaceIdiom == .phone {
     
      if UIApplication.shared.statusBarOrientation.isPortrait {
        
        return checkSimulatorPhoneType(width: UIScreen.main.bounds.width,
                                       height: UIScreen.main.bounds.height)
        
      } else {
        return checkSimulatorPhoneType(width: UIScreen.main.bounds.height,
                                       height: UIScreen.main.bounds.width)
      }
    }
    return .unknown
  }
  
  
  private func checkSimulatorPhoneType(width: CGFloat, height: CGFloat) -> VUCurrentDeviceType {
    
    switch width {
      
    case 320:
      
      if height == 480 {
        return .iPhone4
        
      } else {
        return .iPhone5
      }
      
    case 375:
      return .iPhone6
      
    case 414:
      return .iPhonePlus
      
    default:
      return .unknown
    }
  }
  
}
