//
//  SocialNetworksUsers.swift
//  Pods
//
//  Created by Alex Chaku on 24.11.16.
//
//

import UIKit


class SocialNetworksUser: NSObject {
  
  //MARK: - Lifecycle
  private override init() {
    let name = UserDefaults.standard.value(forKey: "facebookNameKey") as? String
    if (name != nil) {
      facebookName = name!
    }
    
    let id = UserDefaults.standard.value(forKey: "facebookIDKey") as? String
    if (id != nil) {
      facebookID = id!
    }
    
    let email = UserDefaults.standard.value(forKey: "facebookEmailKey") as? String
    if (email != nil) {
      facebookEmail = email!
    }
  }
  static let sharedInstance : SocialNetworksUser = SocialNetworksUser()
  
  
  //MARK: - Facebook user Properties
  
  var facebookName = String()
  var facebookID = String()
  var facebookEmail = String()
  
  
  //MARK: Facebook user Methods
  
  func saveFacebookUser(name: String?, ID: String?, email: String?) {
    
    self.deleteTwitterUser()
    
    if name == nil {
      facebookName = "No name"
    } else {
      facebookName = name!
    }
    
    if ID == nil {
      facebookID = "No ID"
    } else {
      facebookID = ID!
    }
    
    if email == nil {
      facebookEmail = "\(facebookName)@email.com"
    } else {
      facebookEmail = email!
    }
    
    UserDefaults.standard.set(facebookName, forKey: "facebookNameKey")
    UserDefaults.standard.set(facebookID, forKey: "facebookIDKey")
    UserDefaults.standard.set(facebookEmail, forKey: "facebookEmailKey")
    UserDefaults.standard.synchronize()
  }
  
  func deleteFacebookUser() {
    
    UserDefaults.standard.removeObject(forKey: "facebookNameKey")
    UserDefaults.standard.removeObject(forKey: "facebookIDKey")
    UserDefaults.standard.removeObject(forKey: "facebookEmailKey")
    UserDefaults.standard.synchronize()
  }
  
  
  //MARK: - Twitter user Properties
  
  var twitterOAuthToken = String()
  var twitterOAuthTokenSecret = String()
  var twitterName = String()
  var twitterID = String()
  var twitterEmail = String()
  
  
  //MARK: Twitter user Methods
  
  func saveTwitterTokens(token: String, secret: String) {
    
    twitterOAuthToken = token
    twitterOAuthTokenSecret = secret
    
    UserDefaults.standard.set(twitterOAuthToken, forKey: "twitterOAuthTokenKey")
    UserDefaults.standard.set(twitterOAuthTokenSecret, forKey: "twitterOAuthTokenSecretKey")
    UserDefaults.standard.synchronize()
  }
  
  func saveTwitterUser(name: String, ID: String, email: String) {
    
    self.deleteFacebookUser()
    
    twitterName = name
    twitterID = ID
    twitterEmail = email
    
    UserDefaults.standard.set(twitterName, forKey: "twitterNameKey")
    UserDefaults.standard.set(twitterID, forKey: "twitterIDKey")
    UserDefaults.standard.set(twitterEmail, forKey: "twitterEmailKey")
    UserDefaults.standard.synchronize()
  }
  
  func deleteTwitterUser() {
    
    UserDefaults.standard.removeObject(forKey: "twitterOAuthTokenKey")
    UserDefaults.standard.removeObject(forKey: "twitterOAuthTokenSecretKey")
    
    UserDefaults.standard.removeObject(forKey: "twitterNameKey")
    UserDefaults.standard.removeObject(forKey: "twitterIDKey")
    UserDefaults.standard.removeObject(forKey: "twitterEmailKey")
    UserDefaults.standard.synchronize()
  }
}
