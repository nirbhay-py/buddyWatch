//
//  ViewController.swift
//  BuddyWatch
//
//  Created by Nirbhay Singh on 29/10/19.
//  Copyright © 2019 Nirbhay Singh. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var imgConst: NSLayoutConstraint!
    @IBOutlet weak var loginConst: NSLayoutConstraint!
    @IBOutlet weak var signUpConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        login.layer.cornerRadius = 5;
        signUp.layer.cornerRadius = 5;
        imgConst.constant -= view.bounds.width
        loginConst.constant -= view.bounds.width
        signUpConst.constant -= view.bounds.width
        view.layoutIfNeeded()
    }
    override func viewDidAppear(_ animated: Bool) {
        if(Auth.auth().currentUser != nil){
            self.performSegue(withIdentifier: "welcomeToMain", sender: nil)
        }
        UIView.animate(withDuration: 0.7, animations: {
            self.imgConst.constant += self.view.bounds.width
            self.loginConst.constant += self.view.bounds.width
            self.signUpConst.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        },completion: nil)
    }

}

