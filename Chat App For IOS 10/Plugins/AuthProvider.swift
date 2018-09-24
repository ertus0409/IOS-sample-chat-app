//
//  AuthProvider.swift
//  Chat App For IOS 10
//
//  Created by Guner Babursah on 22/09/2018.
//  Copyright © 2018 Arthur Developments. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthProvider {
    
    var userName = ""
    
    private static let _instance = AuthProvider()
    
    private init() {}
    
    static var Instance: AuthProvider {
        return _instance
    }
    
    func userId() -> String {
        return (Auth.auth().currentUser?.uid)!
    }
    
    func isLoggedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }
}
