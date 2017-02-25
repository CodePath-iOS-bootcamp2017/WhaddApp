//
//  ChatViewController.swift
//  WhaddApp
//
//  Created by Satyam Jaiswal on 2/24/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var newMessageTextView: UITextView!
    @IBOutlet weak var chatTableView: UITableView!
    
    var chat: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupTableView()
        self.loadMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMessages(){
        let query = PFQuery(className: "Message")
        query.order(byAscending: "createdAt")
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
            if let chatMessages = messages{
//                print(chatMessages)
                for message in chatMessages{
//                    print(message)
                    if let text = message.object(forKey: "text") as? String{
//                        print(text)
                        self.chat.append(text)
                    }else{
                        print("text key not found")
                    }
                }
                self.chatTableView.reloadData()
            }else{
                print(error.debugDescription)
            }
        }
    }
    
    func setupNavigationBar(){
        self.navigationItem.title = "Chat"
    }
    
    func setupTableView(){
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.chatTableView.estimatedRowHeight = 120
        self.chatTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        if !self.chat.isEmpty{
            cell.messageLabel.text = self.chat[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.chat.isEmpty{
            return self.chat.count
        }else{
            return 0
        }
    }
    
    @IBAction func onComposeButtonTapped(_ sender: Any) {
        
        let message = PFObject(className: "Message")
        message["text"] = self.newMessageTextView.text
        message.saveInBackground { (success: Bool, error: Error?) in
            if success{
                print("new message save successfully")
            }else{
                print(error?.localizedDescription)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
