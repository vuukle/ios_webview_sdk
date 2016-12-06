//
//  Email Verificator.swift
//  Pods
//
//  Created by Alex Chaku on 05.12.16.
//
//

import Foundation


func verifyEmail(email: String) -> Bool {
    
    if (email.characters.count <= 254) {
        let emailComponents = email.components(separatedBy: "@")
        
        if (emailComponents.count == 2) {
            if (emailComponents[0].characters.count <= 64 &&
                emailComponents[1].characters.count <= 320) {
                
                let emailFotmatPattern = "[A-Z0-9a-z]+[A-Z0-9a-z._%+-]+[A-Z0-9a-z]+[@]{1,1}+[A-Za-z0-9-.]+[A-Za-z0-9]+[.]{1,1}+[A-Za-z]{2,}"
                let emailTest = NSPredicate(format:"SELF MATCHES %@", emailFotmatPattern)
                
                if emailTest.evaluate(with: email) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }
    } else {
        return false
    }
}

