//
//  VUControllSum.swift
//  Pods
//
//  Created by Orest Mykha on 3/7/17.
//
//

import UIKit

class VUControllSum: NSObject {
  
  public func getHashCode(_ text: String) -> Int {
    
    var hash : Int32 = 0
    
    for i in 0..<text.characters.count {
      
      let tmp = hash << 5
      hash = (tmp &- hash)
      hash += Int32(text[i].asciiCode)
    }
    
    return Int(hash)
  }
  
  
  public func getRandomHashCode(_ text: String) -> Int {
    
    var hash : Int32 = 0
    
    for i in 0..<text.characters.count {
      
      let tmp = hash << 22
      hash = (tmp &- hash)
      hash += Int32(text[i].asciiCode)
    }
    
    return Int(hash)
  }

}
