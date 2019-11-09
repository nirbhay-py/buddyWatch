//
//  mainVC.swift
//  BuddyWatch
//
//  Created by Nirbhay Singh on 30/10/19.
//  Copyright © 2019 Nirbhay Singh. All rights reserved.
//

import UIKit
import EZLoadingActivity
import Firebase
import CoreLocation
import GoogleMaps

class mainVC: UIViewController , CLLocationManagerDelegate {
    @IBOutlet weak var viewConst: NSLayoutConstraint!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var lolLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var newAlertBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    var lat:Double=0;
    var lon:Double=0;
    var user=User()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        btn1.layer.cornerRadius = 5
        btn2.layer.cornerRadius = 5
        print(Auth.auth().currentUser!.uid)
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2
        profilePic.clipsToBounds = true
        profilePic.layer.borderWidth = 3
        profilePic.layer.borderColor = UIColor.white.cgColor
        
//        // Location Methods
//        
//        self.locationManager.requestAlwaysAuthorization()
//
//        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.lat = locValue.latitude
        self.lon = locValue.longitude
        self.locationManager.stopUpdatingLocation()
        if(nameLbl.text=="Loading..."){
            self.fetchDetails(pos:locValue)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
       
        viewConst.constant -= view.bounds.width;
        self.navigationController?.isNavigationBarHidden = true
        view.layoutIfNeeded()
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.viewConst.constant += self.view.bounds.width;
            self.view.layoutIfNeeded()

        })
        
    }
    
    func fetchDetails(pos:CLLocationCoordinate2D)
    {
        // fetch user data
        let ref = Database.database().reference().child("userNode").child(Auth.auth().currentUser!.uid);
        ref.observeSingleEvent(of: .value, with:{ (snapshot) in
            if let value = snapshot.value as? [String:String]{
                self.user.name = value["username"]!
                self.user.email = value["email"]!
                self.user.phone  = value["phone"]!
                let storage = Storage.storage()
                let storageRef = storage.reference().child("userPictures").child(Auth.auth().currentUser!.uid)
                storageRef.getData(maxSize: 3 * 1024 * 1024) { data, error in
                  if let error = error {
                    showAlert(msg: error.localizedDescription)
                  } else {
                    let image = UIImage(data: data!)
                    self.profilePic.image = image
                    self.nameLbl.text = self.user.name
                    self.emailLbl.text = self.user.email
                    let geocoder = GMSGeocoder()
                           geocoder.reverseGeocodeCoordinate(pos){ resp, err in
                               if let address = resp?.firstResult() {
                                   self.lolLbl.text = address.addressLine1()
                               }else{
                                   showAlert(msg: "We could not fetch your location - check your app permissions.")
                        }
                    }
                  }
                }
            }else{
                showAlert(msg: "We could not fetch your data at this time. Try again later.")
            }
        })
    }
    

    override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}


