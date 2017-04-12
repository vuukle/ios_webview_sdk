//
//  UIView+Vuukle.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//

import Foundation
import UIKit

extension UIToolbar {
  
  static func addKeyboardToolbar(_ arrayTextObjects: [Any]) {
    
    for i in 0..<arrayTextObjects.count {
      
      let textObject = arrayTextObjects[i]
      
      let keyboardToolbar = configureKeyboardToolbar()
      var toolbarItems = [UIBarButtonItem]()
      
      let doneBarButton = configureDoneBarButton(textObject)
      let barSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                      target: nil,
                                      action: nil)
      toolbarItems.append(doneBarButton)
      toolbarItems.append(barSpacer)
      
      if arrayTextObjects.count > 1 {

        let upButton = configureUpBarButton()
        let downButton = configureDownBarButton()
        
        let upBarButton = UIBarButtonItem(customView: upButton)
        let downBarButton = UIBarButtonItem(customView: downButton)
        
        if (i - 1) >= 0 {
          
          upButton.addTarget(arrayTextObjects[i - 1],
                             action: #selector(becomeFirstResponder),
                             for: .touchUpInside)
        } else {
          upBarButton.isEnabled = false
        }
        
        if (i + 1) < arrayTextObjects.count {
          
          downButton.addTarget(arrayTextObjects[i + 1],
                               action: #selector(becomeFirstResponder),
                               for: .touchUpInside)
        } else {
          downBarButton.isEnabled = false
        }
        
        toolbarItems.append(upBarButton)
        toolbarItems.append(downBarButton)
      }
      
      keyboardToolbar.items = toolbarItems
      addToolbar(textObject, toolbar: keyboardToolbar)
    }
  }
  
  // MARK: - Supporting methods
  private static func configureKeyboardToolbar() -> UIToolbar {
    
    let keyboardToolbar = UIToolbar(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: UIScreen.main.bounds.width,
                                                  height: 44))
    
    switch VUDesignHUB.colorsType {
      
    case .dayColors:
      keyboardToolbar.barStyle = VUDesignHUB.keyboard.toolbarStyle
      
    case .nightColors:
      keyboardToolbar.barStyle = VUDesignHUB.keyboardNight.toolbarStyle
    }
    
    
    
    
    
    
    
    
    return keyboardToolbar
  }
  
  private static func configureDoneBarButton(_ target: Any) -> UIBarButtonItem {
    
    let doneBarButton = UIBarButtonItem(title: "Done",
                                        style: .done,
                                        target: target,
                                        action: #selector(resignFirstResponder))
   
    switch VUDesignHUB.colorsType {
   
    case .dayColors:
      doneBarButton.tintColor = VUDesignHUB.keyboard.toolbarDoneButtonColor

    case .nightColors:
      doneBarButton.tintColor = VUDesignHUB.keyboardNight.toolbarDoneButtonColor
    }
    
    return doneBarButton
  }
  
  private static func configureUpBarButton() -> UIButton {
    
    let upButton = UIButton(frame: CGRect(x: (44 + 10), y: 0, width: 44, height: 44))
   
    switch VUDesignHUB.colorsType {
      
    case .dayColors:
      upButton.setImage(UIImage(assetIdentifier: .upArrow),
                        for: .normal)
      upButton.setImageTint(VUDesignHUB.keyboard.toolbarUpArrowButtonColor)
      
    case .nightColors:
      
      upButton.setImage(UIImage(assetIdentifier: .upArrow),
                        for: .normal)
      upButton.setImageTint(VUDesignHUB.keyboardNight.toolbarUpArrowButtonColor)
    }
    
    return upButton
  }
  
  
  private static func configureDownBarButton() -> UIButton {
    
    let downButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    
    switch VUDesignHUB.colorsType {
      
    case .dayColors:
      downButton.setImage(UIImage(assetIdentifier: .downArrow),
                          for: .normal)
      downButton.setImageTint(VUDesignHUB.keyboard.toolbarDownArrowButtonColor)
      
    case .nightColors:
      downButton.setImage(UIImage(assetIdentifier: .downArrow),
                          for: .normal)
      downButton.setImageTint(VUDesignHUB.keyboardNight.toolbarDownArrowButtonColor)
    }
    
    return downButton
  }
  
  private static func addToolbar(_ textObject: Any, toolbar: UIToolbar) {
    
    switch textObject {
   
    case is UITextField:
      let textField = textObject as! UITextField
      textField.inputAccessoryView = toolbar
      
    case is UITextView:
      let textView = textObject as! UITextView
      textView.inputAccessoryView = toolbar
      
    default: break
    }
  }
  
}

