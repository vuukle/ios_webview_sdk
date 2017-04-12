//
//  VULoadMoreModel.swift
//  pod 'Vuukle'
//
//  Copyright © 2016 Vuukle Comments. All rights reserved.
//

import UIKit

class VULoadMoreModel {

  let vuukleURL = ""
  var isAbleLoadComments = true

  init(commentsCount: Int) {
    
    if commentsCount < VUGlobals.commentsPagination {
      isAbleLoadComments = false
    }
  }
  
  func setCommentsCount(_ count: Int) {
    
    if count < VUGlobals.commentsPagination {
      isAbleLoadComments = false
      
      NotificationCenter.default.post(name: VUGlobals.nHideLoadMoreButton,
                                      object: nil)
    }
  }

}
