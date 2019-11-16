//
//  mapVC.swift
//  BuddyWatch
//
//  Created by Nirbhay Singh on 17/11/19.
//  Copyright © 2019 Nirbhay Singh. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import CoreLocation
import EZLoadingActivity

class mapVC: UIViewController,CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    var globalPos:CLLocationCoordinate2D! = nil
    
    override func viewDidLoad() {

        super.viewDidLoad()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        EZLoadingActivity.show("Fetching your location", disableUI: true)
        guard let loc = locations.last?.coordinate else{
            EZLoadingActivity.hide(false, animated: true)
            showAlert(msg: "We could not fetch your location at this moment.")
            return
        }
        globalPos = loc
        print(globalPos as Any)
        manager.stopUpdatingLocation()
        EZLoadingActivity.hide(true, animated: true)
        getUser()
        populateView()
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(msg: error.localizedDescription)
    }
    
    func getUser(){
        let camera = GMSCameraPosition.camera(withLatitude: globalPos.latitude, longitude: globalPos.longitude, zoom: 16)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true;
        self.view = mapView
    }
    func populateView(){
        let ref = Database.database().reference().child("reportsNode")
        let listener = ref.observe(DataEventType.value, with: { (snapshot) in
            let reports = snapshot.value as! [String:AnyObject]
            for report in reports{
                print(report)
                let lat = report.value["Lat"] as! Double
                let lon = report.value["Lon"] as! Double
                let coordinates = CLLocationCoordinate2D(latitude:lat,longitude:lon)
                let marker = GMSMarker(position:coordinates)
                let complainee = report.value["Username"] as! String
                let details = report.value["Details"] as! String
                let type = report.value["Report Type"] as! String
                marker.title = type as! String
                marker.snippet = details + "\n" + complainee
                marker.map = self.view as! GMSMapView
            }
        })

            
    }
    


}
