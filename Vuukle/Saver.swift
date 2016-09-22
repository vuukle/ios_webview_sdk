

import Foundation
import UIKit

class Saver {
    
    static let sharedInstance = Saver()
    let defaults : UserDefaults = UserDefaults.standard
    
    func savingWhenPostButtonPressed (_ name : String ,email : String) {
        if self.defaults.object(forKey: "name") == nil {
            self.defaults.set("\(name)", forKey: "name")
            self.defaults.synchronize()
            
        } else {
            
            self.defaults.removeObject(forKey: "name")
            self.defaults.synchronize()
            print(defaults.object(forKey: "name"))
            self.defaults.set("\(name)", forKey: "name")
            self.defaults.synchronize()
        }
        
        if self.defaults.object(forKey: "email") as? String == nil {
            self.defaults.set("\(email)", forKey: "email")
            self.defaults.synchronize()
            
        } else {
            
            self.defaults.removeObject(forKey: "email")
            self.defaults.synchronize()
            self.defaults.set("\(email)", forKey: "email")
            self.defaults.synchronize()
        }
        
    }
    
    func removeWhenLogOutbuttonPressed() {
        if self.defaults.object(forKey: "name") != nil {
            self.defaults.removeObject(forKey: "name")
            self.defaults.synchronize()
        }
        
        if self.defaults.object(forKey: "email") as? String != nil {
            self.defaults.removeObject(forKey: "email")
            self.defaults.synchronize()
        }
    }
}
