

import Foundation

class Saver {

    static let sharedInstance = Saver()
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()

    func savingWhenPostButtonPressed (name : String ,email : String) {
        if self.defaults.objectForKey("name") == nil {
            self.defaults.setObject("\(name)", forKey: "name")
            self.defaults.synchronize()
            
        } else {
            
            self.defaults.removeObjectForKey("name")
            self.defaults.synchronize()
            print(defaults.objectForKey("name"))
            self.defaults.setObject("\(name)", forKey: "name")
            self.defaults.synchronize()
        }
        
        if self.defaults.objectForKey("email") as? String == nil {
            self.defaults.setObject("\(email)", forKey: "email")
            self.defaults.synchronize()
            
        } else {
            
            self.defaults.removeObjectForKey("email")
            self.defaults.synchronize()
            self.defaults.setObject("\(email)", forKey: "email")
            self.defaults.synchronize()
        }
    
    }
    
    func removeWhenLogOutbuttonPressed() {
        if self.defaults.objectForKey("name") != nil {
            self.defaults.removeObjectForKey("name")
            self.defaults.synchronize()
        }
        
        if self.defaults.objectForKey("email") as? String != nil {
            self.defaults.removeObjectForKey("email")
            self.defaults.synchronize()
    }
    }
}