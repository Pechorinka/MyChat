//
//  ChatViewController.swift
//  MyChat
//
//  Created by Tatyana Sidoryuk on 13.08.2022.
//

import UIKit
import Firebase

class ChatsViewController: UIViewController {
    let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages: [Message] = []
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ])
                { (error) in
                    if let e = error {
                        print ("There was an issue with saving data, \(e)")
                    } else {
                        print ("Successfully saved data")
                        
                        DispatchQueue.main.async {
                            self.messageTextfield.text = ""
                        }
                        
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages() {

        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapShot, error) in

            self.messages = []
            if let e = error {
                print ("There was an error. \(e)")
            } else {
                if let snapShotDocs = querySnapShot?.documents {
                    for doc in snapShotDocs {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMesssage = Message (sender: messageSender, body: messageBody)
                            self.messages.append(newMesssage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }

    @IBOutlet weak var barButton: UIBarButtonItem!
    
    @IBAction func logOutPressedd(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    
                    navigationController?.popToRootViewController(animated: true)
                    
                }   catch let signOutError as NSError {
                        print ("Error signing out ", signOutError)
                    }
                }
        
    }

extension ChatsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
                cell.label.text = messages[indexPath.row].body
                
        
        // Message from current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = .gray
            cell.label.textColor = .black
        }
       // Messsage from another user
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = .purple
            cell.label.textColor = .white
        }
        return cell
    }
}
