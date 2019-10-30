//
//  mainVC.swift
//  BuddyWatch
//
//  Created by Nirbhay Singh on 30/10/19.
//  Copyright © 2019 Nirbhay Singh. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase

class mainVC: UIViewController {
    @IBOutlet weak var viewConst: NSLayoutConstraint!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var lolLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    var user=User()
    let hud = JGProgressHUD(style: .extraLight)
    override func viewDidLoad() {
        print(Auth.auth().currentUser!.uid)
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        hud.textLabel.text="Loading..."
        fetchDetails()
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2
        profilePic.clipsToBounds = true
        profilePic.layer.borderWidth = 3
        profilePic.layer.borderColor = UIColor.white.cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        viewConst.constant -= view.bounds.width;
        self.navigationController?.isNavigationBarHidden = true
        view.layoutIfNeeded()
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2, animations: {
            self.viewConst.constant += self.view.bounds.width;
            self.view.layoutIfNeeded()

        })
         hud.show(in: self.view, animated: true)
        
    }
    
    func fetchDetails()
    {
        var downloadUrl:String=""
        var ref = Database.database().reference().child("userNode").child(Auth.auth().currentUser!.uid);
        ref.observeSingleEvent(of: .value, with:{ (snapshot) in
            let value = snapshot.value as! [String:String]
            self.user.name = value["username"]!
            self.user.phone = value["phone"]! 
            self.user.city = value["city"]!
            let storage = Storage.storage()
            let storageRef = storage.reference().child("userPictures").child(Auth.auth().currentUser!.uid)
            storageRef.getData(maxSize: 3 * 1024 * 1024) { data, error in
              if let error = error {
                self.hud.dismiss(animated: true)
                self.showAlert(msg: error.localizedDescription)
              } else {
                let image = UIImage(data: data!)
                self.profilePic.image = image
                self.nameLbl.text = self.user.name
                self.emailLbl.text = self.user.phone
                self.hud.dismiss(animated: true)
              }
            }
        }){ (error) in
            self.hud.dismiss(animated:true)
            print(error.localizedDescription)
            self.showAlert(msg: error.localizedDescription)
        }
    }
    
    func showAlert(msg:String){
        let alert = UIAlertController(title:"Uh oh!", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}


