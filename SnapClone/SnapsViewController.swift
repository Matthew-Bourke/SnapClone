//
//  SnapsViewController.swift
//  SnapClone
//
//  Created by Matthew Bourke on 20/8/17.
//  Copyright © 2017 Matthew Bourke. All rights reserved.
//

import UIKit
import Firebase

class SnapsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var snapsTV: UITableView!
    
    var snaps : [Snap] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("snaps").observe(DataEventType.childAdded, with: { (snapshot) in
            // Snapshot is all of the 'added childs'
            print(snapshot)
            
            let snap = Snap()
            
            // This line was a fuckig bitch to get. REMEMBER THIS ONE!
            snap.imageURL = (snapshot.value! as! NSDictionary).object(forKey: "imageURL") as! String
            snap.from = (snapshot.value! as! NSDictionary).object(forKey: "from") as! String
            snap.descrip = (snapshot.value! as! NSDictionary).object(forKey: "description") as! String
            snap.key = snapshot.key
            snap.uuid = (snapshot.value! as! NSDictionary).object(forKey: "uuid") as! String
            
            self.snaps.append(snap)
            
            self.snapsTV.reloadData()
            
        })
        
        
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("snaps").observe(DataEventType.childRemoved, with: { (snapshot) in
            // Snapshot is all of the 'added childs'
            print(snapshot)
            
            
            /* Creating a for loop with an index variable allows us to delete an element of the array
                without knowing which index it exists in */
            var index = 0
            
            for snap in self.snaps {
                if snap.key == snapshot.key {
                    self.snaps.remove(at: index)
                }
                
                index += 1
            }
            
            self.snapsTV.reloadData()
        })
        
        snapsTV.delegate = self
        snapsTV.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0 {
            return 1
        } else {
             return snaps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if snaps.count == 0 {
            cell.textLabel?.text = "No snaps 💩"
        } else {
            let snap = snaps[indexPath.row]
            
            cell.textLabel?.text = snap.from
        }
        return cell
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        // Since this VC was presented modally, we can just dismiss it and go back to login screen
        dismiss(animated: true, completion: nil)
        print("Sign out successful")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if snaps.count != 0 {
            let snap = snaps[indexPath.row]
            
            performSegue(withIdentifier: "viewSnapSegue", sender: snap)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSnapSegue" {
            let nextVC = segue.destination as! ViewSnapViewController
            nextVC.snap = sender as! Snap
        }
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
