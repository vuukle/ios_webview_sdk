//
//  UIViewController+Vuukle.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import UIKit


extension UIViewController {
  
  func showAlert(_ title: String?,
                 message: String?) {
    
    if title == nil && message == nil {
      return
    }
    
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let okButton = UIAlertAction(title: "OK", style: .cancel) { (action) in
      alertVC.dismiss(animated: true, completion: nil)
    }
    
    okButton.setValue(UIColor.vuukleOrange, forKey: "titleTextColor")
    
    alertVC.addAction(okButton)
    self.present(alertVC, animated: true, completion: nil)
  }
  
  func showQuestionAlert(_ title: String?,
                         message: String?,
                         trueButtonText: String,
                         falseButtonText: String,
                         completion: @escaping (Bool) -> Void) {
    
    if title == nil && message == nil {
      return
    }
    
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let falseButton = UIAlertAction(title: falseButtonText, style: .cancel) { (action) in
      
      completion(false)
      alertVC.dismiss(animated: true, completion: nil)
    }
    falseButton.setValue(UIColor.vuukleOrange, forKey: "titleTextColor")
    
    let trueButton = UIAlertAction(title: trueButtonText, style: .default) { (action) in
      
      completion(true)
      alertVC.dismiss(animated: true, completion: nil)
    }
    trueButton.setValue(UIColor.vuukleRed, forKey: "titleTextColor")
    
    alertVC.addAction(falseButton)
    alertVC.addAction(trueButton)
    
    self.present(alertVC, animated: true, completion: nil)
  }

}
