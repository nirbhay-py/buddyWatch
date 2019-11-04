//
//  loginVC.swift
//  BuddyWatch
//
//  Created by Nirbhay Singh on 30/10/19.
//  Copyright © 2019 Nirbhay Singh. All rights reserved.
//

import UIKit
import Firebase
import EZLoadingActivity

class loginVC: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pswd: UITextField!
    @IBOutlet weak var emailConst: NSLayoutConstraint!
    @IBOutlet weak var pswdConst: NSLayoutConstraint!
    @IBOutlet weak var btnConst: NSLayoutConstraint!
    @IBOutlet weak var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn.layer.cornerRadius = 5;
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:"dismissKeyboard")
        view.addGestureRecognizer(tap)

    }
    override func viewWillAppear(_ animated: Bool) {
        disappear(const: emailConst)
        disappear(const: pswdConst)
        disappear(const: btnConst)
        view.layoutIfNeeded()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.appear(const: self.emailConst)
            self.appear(const: self.pswdConst)
            self.appear(const: self.btnConst)
            self.view.layoutIfNeeded()
        })
        
    }
    @IBAction func btnPressed(_ sender: Any) {
        var email_txt = email.text;
        var pswd_txt = pswd.text;
        if(email_txt==""||pswd_txt==""){
            showAlert(msg: "You can't leave these fields blank.")
        }else if(!(isValidEmail(emailStr: email_txt!))){
             showAlert(msg: "Looks like you entered an invalid email.")
        }else{
            EZLoadingActivity.show("Authenticating", disableUI: true)
            Auth.auth().signIn(withEmail: email_txt!, password: pswd_txt!){(authResult,error) in
                print(authResult)
                if(error != nil){
                    EZLoadingActivity.hide(false, animated: true)
                    showAlert(msg: error!.localizedDescription)
                }else{
                    EZLoadingActivity.hide(true, animated: true)
                    self.performSegue(withIdentifier: "loginToMain", sender: nil)
                }
            }
        }
    }
    
    func disappear(const:NSLayoutConstraint){
        const.constant-=view.bounds.width
    }
    func appear(const:NSLayoutConstraint){
        const.constant+=view.bounds.width
    }
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    @objc func dismissKeyboard() {
           view.endEditing(true)
       }
    
}

