//
//  SelectUserViewController.swift
//  SnapClone
//
//  Created by Matthew Bourke on 20/8/17.
//  Copyright © 2017 Matthew Bourke. All rights reserved.
//

import UIKit
import Firebase

class SelectUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userList: UITableView!
    
    var users : [User] = []
    
    var imageURL = ""
    var descrip = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userList.delegate = self
        userList.dataSource = self
        
        // Accessing FireBase database, observe is what lets us pull the files from database
        Database.database().reference().child("users").observe(DataEventType.childAdded, with: { (snapshot) in
            // Snapshot is all of the 'added childs'
            print(snapshot)
            
            let user = User()
            
            // This line was a fuckig bitch to get. REMEMBER THIS ONE!
            user.email = (snapshot.value! as! NSDictionary).object(forKey: "email") as! String
            user.uid = snapshot.key
            
            self.users.append(user)
            
            self.userList.reloadData()
            
            
        })
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.email
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        let snap = ["from":user.email, "description":descrip, "imageURL":imageURL]
        
        Database.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
