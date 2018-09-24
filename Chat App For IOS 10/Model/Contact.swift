//
//  Contact.swift
//  Chat App For IOS 10
//
//  Created by Guner Babursah on 22/09/2018.
//  Copyright © 2018 Arthur Developments. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Contact {
    
    private var _name = ""
    private var _id = ""
    
    init(id: String, name: String) {
        _id = id
        _name = name
    }
    
    var name: String {
        return _name
    }
    
    var id: String {
        return _id
    }
}
