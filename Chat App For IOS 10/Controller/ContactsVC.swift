//
//  ContactsVC.swift
//  Chat App For IOS 10
//
//  Created by Guner Babursah on 21/09/2018.
//  Copyright © 2018 Arthur Developments. All rights reserved.
//

import UIKit
import Firebase

class ContactsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FetchData {

    @IBOutlet weak var myTableView: UITableView!
    
    private var contacts = [Contact]()
    private let CELL_ID = "Cell"
    private let CHAT_SEGUE = "ChatSegue"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DBProvider.Instance.delegate = self
        DBProvider.Instance.getContacts()
        
    }
    
    func dataReceived(contacts: [Contact]) {
        self.contacts = contacts
        for contact in contacts {
            if contact.id == AuthProvider.Instance.userId() {
                AuthProvider.Instance.userName = contact.name
            }
        }
        print(contacts)
        myTableView.reloadData()
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        
        let text = cell.textLabel
        cell.textLabel?.text = contacts[indexPath.row].name
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: CHAT_SEGUE, sender: nil)
    }
    
    @IBAction func logOut(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        do {
            let _ = try Auth.auth().signOut()
        } catch {
        
        }
    }
    
}
