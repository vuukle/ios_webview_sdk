//
//  VUDebugPrint.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import Foundation

public func vuuklePrint(_ objects: Any..., separator: String = " ", terminator: String = "\n") {
  
  if VUGlobals.isDebugBuild {

    for object in objects {
    
      Swift.print("\n[Vuukle \(VUGlobals.vuukleVersion)] \(object)",
                  separator: separator,
                  terminator: terminator)
    }
  }
}
