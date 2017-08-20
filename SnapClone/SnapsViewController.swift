//
//  SnapsViewController.swift
//  SnapClone
//
//  Created by Matthew Bourke on 20/8/17.
//  Copyright © 2017 Matthew Bourke. All rights reserved.
//

import UIKit
import Firebase

class SnapsViewController: UIViewController {
    
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
            
            self.snaps.append(snap)
            
            
            
            
        })
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        // Since this VC was presented modally, we can just dismiss it and go back to login screen
        dismiss(animated: true, completion: nil)
        print("Sign out successful")
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
