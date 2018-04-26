//
//  WelcomePage.swift
//  IkizuV2
//
//  Created by Robin kamo on 2018-04-25.
//  Copyright © 2018 Robin kamo. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class WelcomePage: UIViewController, GIDSignInUIDelegate {
    

    @IBOutlet weak var signInBtn: GIDSignInButton!
    
    
    @IBOutlet weak var mainBg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        if GIDSignIn.sharedInstance().currentUser != nil {
            performSegue(withIdentifier: "lobbySegue", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        
       
        
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
