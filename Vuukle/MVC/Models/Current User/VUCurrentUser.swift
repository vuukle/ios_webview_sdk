//
//  VUCurrentUser.swift
//  pod 'Vuukle'
//
//  Copyright © 2016-2017 Vuukle Comments. All rights reserved.
//


import UIKit

class VUCurrentUser {

  private static var _name: String?
  private static var _email: String?
  
  
  // MARK: - Key for UserDefailts
  private static let nameKey = "VUUKLE_CURRENT_USER_NAME_KEY"
  private static let emailKey = "VUUKLE_CURRENT_USER_EMAIL_KEY"
  
  
  // MARK: - Public varibles
  static var isUserLogined: Bool {
    
    if name == nil && email == nil {
      return false
    } else {
      return true
    }
  }

  static var name: String? {
    set{
      
      _name = newValue
      UserDefaults.standard.set(newValue, forKey: nameKey)
      UserDefaults.standard.synchronize()
    }
    get {
      
      if let name = _name {
        return name
      }
      
      UserDefaults.standard.synchronize()
      return UserDefaults.standard.object(forKey: nameKey) as? String
    }
  }
  
  static var email: String? {
    set{
      
      _email = newValue
      UserDefaults.standard.set(newValue, forKey: emailKey)
      UserDefaults.standard.synchronize()
    }
    get {
      if let email = _email {
        
        return email
      }
      
      UserDefaults.standard.synchronize()
      return UserDefaults.standard.object(forKey: emailKey) as? String
    }
  }
  
  
  // MARK: - Static methods
  static func setInfo(name: String, email: String) {
    
    var name = name.removeExcessiveSpaces()
    name = name.replacingOccurrences(of: "&", with: " ")
    name = name.replacingOccurrences(of: "=", with: " ")
    
    VUCurrentUser.name = name
    VUCurrentUser.email = email
  }
  
  static func deleteUser() {
    
    _name = nil
    _email = nil
    
    UserDefaults.standard.removeObject(forKey: nameKey)
    UserDefaults.standard.removeObject(forKey: emailKey)
    UserDefaults.standard.synchronize()
  }
  
}
