//
//  VUBugReportsFactory.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit
import MessageUI


class VUBugReportsFactory {
  
  
  static func showSendReportBUG(_ reason: VUBugReportType,
                                responceModel: VUPostResponceModel) {
    
    var message = "• STATUS CODE: \(responceModel.statusCode)\n"
    
    message.append("• REASON: \(responceModel.requestErrorReason)\n")
    message.append("• URL: \(responceModel.requestURL)\n")
    message.append("• ARTICLE TITLE: \(VUGlobals.requestParametes.articleTitle)\n")
    message.append("• ARTICLE ID: \(VUGlobals.requestParametes.articleID)\n")
    message.append("• ARTICLE URL: \(VUGlobals.requestParametes.articleURL)\n")
    message.append("• COMMENT: \(responceModel.comment)\n")
    message.append("• MODERATION: \(responceModel.isUnderModeration ? "true" : "false")\n")
    message.append("• NAME: \(responceModel.name)\n")
    message.append("• EMAIL: \(responceModel.email)\n")
    
    VUBugReportsFactory.showSendReportBUG(reason, errorMessage: message)
  }
  
  static func showSendReportBUG(_ vuukleError: VURequestError) {
    
    var message = "• STATUS CODE: \(vuukleError.statusCode)\n"
    
    message.append("• ERROR TEXT: \(vuukleError.errorText)\n")
    message.append("• ERROR DESCRIPTION: \(vuukleError.errorDescription)\n")
    
    for parameter in vuukleError.parametersArray {
      message.append(parameter)
    }
    
    VUBugReportsFactory.showSendReportBUG(vuukleError.errorType, errorMessage: message)
  }
  
  static func showSendReportBUG(_ reason: VUBugReportType,
                                errorMessage: String) {
    
    if let baseVC = VUCommentsBuilderModel.vBaseVC {
      
      let alertVC = UIAlertController(title: "👻 Something went wrong...",
                                      message: "Please, sent us bug report to help make our comments better.",
                                      preferredStyle: .alert)
      
      let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        
        alertVC.dismiss(animated: true)
      }
      
      let sendBugReport = UIAlertAction(title: "Send bug report", style: .default) { (action) in
        
        alertVC.dismiss(animated: false)
        
        if MFMailComposeViewController.canSendMail() {
          
          let mailComposeVC = configureMailComposerVC(reason, errorMessage: errorMessage)
          baseVC.present(mailComposeVC, animated: true)
          
        } else {
          
          if VUInternetChecker.isOnline == false {
            VUAlertsHub.showAlert("⚠️ Can't send Report",
                                  message: "Please, check yout device Wi-Fi and Cellural Data settings.")
            
          } else {
            VUAlertsHub.showAlert("⚠️ Can't send Report",
                                  message: "Please, check your iPhone or iPad default \"Mail\" app settings.")
          }
        }
      }
      alertVC.addAction(cancelButton)
      alertVC.addAction(sendBugReport)
      
      alertVC.modalPresentationStyle = .overCurrentContext
      baseVC.present(alertVC, animated: true)
    }
  }
  
  
  private static func configureMailComposerVC(_ reason: VUBugReportType, errorMessage: String) -> MFMailComposeViewController {
    
    let mailComposerVC = MFMailComposeViewController()
    mailComposerVC.mailComposeDelegate = VUCommentsVC.sharedInstance
    
    mailComposerVC.setToRecipients(["fedir@vuukle.com"])
    mailComposerVC.setSubject("[Vuukle iOS \(VUGlobals.vuukleVersion) - BUG Report] \(reason.rawValue)")
    mailComposerVC.setMessageBody(errorMessage, isHTML: false)
    
    return mailComposerVC
  }
  
}
