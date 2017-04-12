//
//  VUInternetChecker.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit


class VUInternetChecker {

  private static let networkManager = VUInternetReachability(host: "www.apple.com")
  
  class var isOnline: Bool {
    return networkManager?.isReachable ?? false
  }
  
}
