//
//  DBProvider.swift
//  Chat App For IOS 10
//
//  Created by Guner Babursah on 21/09/2018.
//  Copyright © 2018 Arthur Developments. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol FetchData: class {
    func dataReceived(contacts: [Contact])
}

class DBProvider {
    
    private static let _instance = DBProvider()
    
    private init() {}
    
    weak var delegate: FetchData?
    
    static var Instance: DBProvider {
        return _instance
    }
    
    var dbRef: DatabaseReference {
        return Database.database().reference()
    }
    
    var contactsRef: DatabaseReference {
        return dbRef.child(CONSTANTS.CONTACTS)
    }
    
    var messageRef: DatabaseReference {
        return dbRef.child(CONSTANTS.MESSAGES)
    }
    
    var mediaMessagesRef: DatabaseReference {
        return dbRef.child(CONSTANTS.MEDIA_MESSAGES)
    }
    
    var storageRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://chat-app-tutorial-34e12.appspot.com")
    }
    
    var imageRef: StorageReference {
        return storageRef.child(CONSTANTS.IMAGE_Storage)
    }
    
    var videoRef: StorageReference {
        return storageRef.child(CONSTANTS.VIEO_STORAGE)
    }
    
    
    
    func saveUser(withID: String, email: String, password: String) {
        let data: Dictionary<String, Any> = [CONSTANTS.EMAIL: email, CONSTANTS.PASSWORD: password]
        contactsRef.child(withID).setValue(data)
    }
    
    func getContacts() {
        var contacts = [Contact]()
        
        contactsRef.observeSingleEvent(of: .value) { (snapshot) in
            if let myContacts = snapshot.value as? NSDictionary {
                for (key, value) in myContacts {
                    if let contactData = value as? NSDictionary {
                        if let email = contactData[CONSTANTS.EMAIL] as? String {
                            let id = key as! String
                            let newContact = Contact(id: id, name: email)
                            contacts.append(newContact)
                        }
                    }
                }
            }
            self.delegate?.dataReceived(contacts: contacts)
        }
    }
}
