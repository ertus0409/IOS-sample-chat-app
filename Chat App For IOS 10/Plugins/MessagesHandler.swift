//
//  MessagesHandler.swift
//  Chat App For IOS 10
//
//  Created by Guner Babursah on 23/09/2018.
//  Copyright © 2018 Arthur Developments. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol MessageRecievedDelegate: class {
    func messageRecieved(senderID: String, senderName: String, text: String)
    func mediaRecieved(senderID: String, senderName: String, url: String)
}

class MessagesHandler {
    private static let _instance = MessagesHandler()
    private init() {}
    
    weak var delegate: MessageRecievedDelegate?
    
    static var Instance: MessagesHandler {
        return _instance
    }
    
    func sendMessages(senderID: String, senderName: String, text: String) {
        
        let data: Dictionary<String, Any> = [CONSTANTS.SENDER_ID: senderID, CONSTANTS.SENDER_NAME: senderName, CONSTANTS.TEXT: text]
        
        DBProvider.Instance.messageRef.childByAutoId().setValue(data)
    }
    
    func sendMediaMessage(senderID: String, senderName: String, url: String) {
        let data: Dictionary<String, Any> = [CONSTANTS.SENDER_ID: senderID, CONSTANTS.SENDER_NAME: senderName, CONSTANTS.URL: url]
        DBProvider.Instance.mediaMessagesRef.childByAutoId().setValue(data)
    }
    
    func sendMedia(image: Data?, video: URL?, senderID: String, senderName: String) {
        if image != nil {
            DBProvider.Instance.imageRef.child(senderID + "\(NSUUID().uuidString).jpg").putData(image!, metadata: nil, completion: { (metadata: StorageMetadata?, err: Error?) in
                if err != nil {
                    //inform the user there was a problem
                } else {
                    self.sendMediaMessage(senderID: senderID, senderName: senderName, url: String(describing: metadata!.downloadURL()!))
                }
            })
        } else if video != nil {
            DBProvider.Instance.videoRef.child(senderID + "\(NSUUID().uuidString)").putFile(from: video!, metadata: nil, completion: { (metadata: StorageMetadata?, err: Error?) in
                if err != nil {
                    //inform the user there was a problem
                } else {
                    self.sendMediaMessage(senderID: senderID, senderName: senderName, url: String(describing: metadata!.downloadURL()!))
                }
            })
        }
    }
    
    func observeMessages() {
        DBProvider.Instance.messageRef.observe(.childAdded) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let senderID = data[CONSTANTS.SENDER_ID] as? String {
                    if let text = data[CONSTANTS.TEXT] as? String {
                        if let senderName = data[CONSTANTS.SENDER_NAME]  as? String{
                            self.delegate?.messageRecieved(senderID: senderID, senderName: senderName, text: text)
                        }
                    }
                }
            }
        }
    }
    
    func observeMediaMessages() {
        DBProvider.Instance.mediaMessagesRef.observe(.childAdded) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let id = data[CONSTANTS.SENDER_ID] as? String {
                    if let name = data[CONSTANTS.SENDER_NAME] as? String {
                        if let fileURL = data[CONSTANTS.URL] as? String {
                            self.delegate?.mediaRecieved(senderID: id, senderName: name, url: fileURL)
                        }
                    }
                }
            }
        }
    }
}
