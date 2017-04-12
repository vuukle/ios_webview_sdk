//
//  VUNewReplyModel.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import Foundation


class VUNewReplyModel {

  //MARK: Model
  var isUserLogined: Bool {
    return VUCurrentUser.isUserLogined
  }
  
  // MARK: Init of Model
  init() { }

}
