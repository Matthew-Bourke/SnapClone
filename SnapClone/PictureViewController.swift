//
//  PictureViewController.swift
//  SnapClone
//
//  Created by Matthew Bourke on 20/8/17.
//  Copyright © 2017 Matthew Bourke. All rights reserved.
//

import UIKit
import Firebase

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    // Runs function and lets output be saved in imagePicker variable
    var imagePicker = UIImagePickerController()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // imagePicker initialisation
        imagePicker.delegate = self
        nextButton.isEnabled = false
    }
    
    // Function to select image to put in imagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // I think this is the line of code that lets you actually select an image
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Sets the image on the VC to the selected image
        imageView.image = image
        
        nextButton.isEnabled = true
        
        imageView.backgroundColor = UIColor.clear
        
        // Dismiss image picker
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func cameraTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        
        nextButton.isEnabled = false
        
        let imagesFolder =  Storage.storage().reference().child("Images")
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.1)
        
        
        imagesFolder.child("\(NSUUID().uuidString)").putData(imageData!, metadata: nil) { (metadata, error) in
            print("We tried to upload")
            if error != nil {
                print("ERROR \(String(describing: error))")
            } else {
                
                print(metadata?.downloadURL() as Any)
                self.performSegue(withIdentifier: "selectUserSegue", sender: nil)
                self.nextButton.isEnabled = true
            }
        }

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
