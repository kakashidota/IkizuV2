//
//  MultiplayerControlelr.swift
//  IkizuV2
//
//  Created by Robin kamo on 2018-04-26.
//  Copyright © 2018 Robin kamo. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class MultiplayerControlelr: UIViewController {
    
//    var user = Auth.auth()
    var listOfUsers : [PlayerClass] = []


    
    
    var database = Database.database().reference()
    
    
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func joinBtnPressed(_ sender: Any) {
        
        
        var user = PlayerClass()
        user.name = Auth.auth().currentUser!.displayName!
        user.Uid = Auth.auth().currentUser!.uid
        
        
        let myDatabase = Database.database().reference()
        myDatabase.child(searchField.text!).childByAutoId().setValue(user.Uid)
        
        myDatabase.child(searchField.text!).observe(.childAdded) { (snapshot) in
            print(" rätt spår bror\(snapshot.key)")
           
            
        }
        
//       // myDatabase.setValue(user.currentUser!.uid)
//
//        let usersRef = myDatabase.child("users").child(searchField!.text!)
//        let thisUserRef = usersRef.child(user.currentUser!.uid)
//        var thisUserPostRef = thisUserRef.childByAutoId //create a new post node
//
//      //  listOfUsers.append(Auth.auth().currentUser!)
        
        
        
      //  thisUserPostRef().child(user.currentUser!.uid).setValue(listOfUsers)
        
        
        
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
