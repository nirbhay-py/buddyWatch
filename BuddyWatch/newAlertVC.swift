import UIKit
import CoreLocation
import Firebase
import GoogleMaps
import EZLoadingActivity

class newAlertVC: UIViewController,CLLocationManagerDelegate{
    // MARK:- IB Outlets

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locLbl: UILabel!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var btn3: UIButton!
    
    var lat:Double=0
    var lon:Double=0

    // MARK:- NSConstraint Outlets
    
    @IBOutlet weak var nameConst: NSLayoutConstraint!
    @IBOutlet weak var b1Const: NSLayoutConstraint!
    @IBOutlet weak var b2Const: NSLayoutConstraint!
    @IBOutlet weak var b3Const: NSLayoutConstraint!
    @IBOutlet weak var imgConst: NSLayoutConstraint!
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        btn1.layer.cornerRadius = 5
        btn2.layer.cornerRadius = 5
        btn3.layer.cornerRadius = 5
        let width = self.view.bounds.width
        nameConst.constant -= width
        b1Const.constant -= width
        b2Const.constant -= width
        b3Const.constant -= width
        imgConst.constant -= width
        self.view.layoutIfNeeded()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let width = self.view.bounds.width
        UIView.animate(withDuration: 0.7, animations: {
            self.nameConst.constant += width
            self.b1Const.constant += width
            self.b2Const.constant += width
            self.b3Const.constant += width
            self.imgConst.constant += width
            self.view.layoutIfNeeded()
        },completion: nil)
    }
    
    
    
    
    let locationManager = CLLocationManager()
    var user = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Started updating locations")
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.lat = locValue.latitude
        self.lon = locValue.longitude
        self.locationManager.stopUpdatingLocation()
        self.fetchDetails(pos:locValue)
    }
    
    func fetchDetails(pos:CLLocationCoordinate2D)
    {
        EZLoadingActivity.show("Loading...", disableUI: true)
        // fetch user data
        let ref = Database.database().reference().child("userNode").child(Auth.auth().currentUser!.uid);
        ref.observeSingleEvent(of: .value, with:{ (snapshot) in
            if let value = snapshot.value as? [String:String]{
                self.user.name = value["username"]!
                self.user.email = value["email"]!
                self.user.phone = value["phone"]!
                let storage = Storage.storage()
                let storageRef = storage.reference().child("userPictures").child(Auth.auth().currentUser!.uid)
                storageRef.getData(maxSize: 3 * 1024 * 1024) { data, error in
                  if let error = error {
                    EZLoadingActivity.hide( animated: true)
                    showAlert(msg: error.localizedDescription)
                  } else {
                    // display user details in this block
                    self.nameLbl.text = self.user.name+", what's up?"
                    EZLoadingActivity.hide(true, animated: true)
                  }
                }
            }else{
                showAlert(msg: "We could not fetch your data at this time. Try again later.")
                EZLoadingActivity.hide(false, animated: true)
            }
            
        }){ (error) in
            EZLoadingActivity.hide(false, animated: true)
            print(error.localizedDescription)
            showAlert(msg: error.localizedDescription)
        }
        // fetch location data
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(pos){ resp, err in
            if let address = resp?.firstResult() {
                self.locLbl.text = address.addressLine1()
            }else{
                showAlert(msg: "We could not fetch your location - check your app permissions.")
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        EZLoadingActivity.hide(false, animated: true)
        showAlert(msg: error.localizedDescription)
    }

}
