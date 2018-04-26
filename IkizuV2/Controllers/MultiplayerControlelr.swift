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
    
    var user = Auth.auth()
    var listOfUsers : [Auth] = []
    
    
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
        
        listOfUsers.append(user)
        database.child(searchField!.text!).setValue(listOfUsers)

        
        
        
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
