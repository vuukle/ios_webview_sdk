//
//  VURequestError.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit

class VURequestError {

  var statusCode = 0
  
  var errorType: VUBugReportType = .none
  var errorText = ""
  var errorDescription = ""
  
  var parametersArray = [String]()
  
  
  // MARK: - Init
  init(_ code: Int,
       type: VUBugReportType,
       data: Data?,
       error: Error?) {
   
    statusCode = code
    errorType = type
    
    if let responceData = data,
      let decodedText = String.init(data: responceData,
                                    encoding: .utf8) {
      errorText = decodedText
    }
    
    if let requestError = error {
      errorDescription = requestError.localizedDescription
    }
  }
  
}
