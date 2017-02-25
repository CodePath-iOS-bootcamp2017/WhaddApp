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
    
    var chat: Array<PFObject> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupTableView()
        self.loadMessages()
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(loadMessages), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let offset = self.chatTableView.contentSize.height - self.chatTableView.bounds.height
        self.chatTableView.setContentOffset(CGPoint(x: 0, y: offset), animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMessages(){
        let query = PFQuery(className: "Message")
        query.order(byDescending: "createdAt")
        query.includeKey("user")
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
            if let chatMessages = messages{
                self.chat.removeAll()
                self.chat.append(contentsOf: chatMessages)
                self.chatTableView.reloadData()
                let offset = self.chatTableView.contentSize.height - self.chatTableView.bounds.height
                self.chatTableView.setContentOffset(CGPoint(x: 0, y: offset), animated: false)
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
            let totalMessages = self.chat.count
            let message = self.chat[totalMessages - 1 - indexPath.row]
            if let text = message["text"] as? String{
                cell.messageLabel.text = text
            }
            
            if let fromUser = message["user"] as? PFUser{
                cell.usernameLabel.isHidden = false
                cell.usernameLabel.text = "@\(fromUser.username!):"
            }else{
                cell.usernameLabel.isHidden = true
            }
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
        message["user"] = PFUser.current()
        message.saveInBackground { (success: Bool, error: Error?) in
            if success{
                print("new message save successfully")
                self.chat.append(message)
                self.chatTableView.reloadData()
                self.newMessageTextView.text.removeAll()
            }else{
                if let error = error{
                    print(error.localizedDescription)
                }
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
