import UIKit
import CoreLocation
import Firebase
import EZLoadingActivity

class reportVC: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    var report:reportType!
    var address:String!
    var name:String!
    var lat:Double!
    var lon:Double!
    var imgData:Data!
    var user:User!
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var detText: UITextView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var locConst: NSLayoutConstraint!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var promptConst: NSLayoutConstraint!
    @IBOutlet weak var tfConst: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        btn.layer.cornerRadius = 5
        let width = self.view.bounds.width
        locLbl.text = address
        locConst.constant -= width
        promptConst.constant -= width
        tfConst.constant -= width
        self.textView.layer.cornerRadius = 15
        self.textView.layer.borderWidth = 0.5
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        self.textView.textContainerInset = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        self.view.layoutIfNeeded()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    override func viewDidAppear(_ animated: Bool) {
        
        let width = self.view.bounds.width
        UIView.animate(withDuration: 0.5, animations: {
            self.locConst.constant += width
            self.promptConst.constant += width
            self.tfConst.constant += width
        })
    }
    @IBAction func submit(_ sender: Any) {
        if(detText.text!.count<20){
            showAlert(msg: "You need to write some more, sorry.")
        }
        else if(imgData==nil){
            showAlert(msg: "You need to submit an image!")
        }
       else if(imgData.count>8000000) {
            showAlert(msg: "You must select a lighter file!")
        }else{
            var r_str=""
            if(report==reportType.injuredAnimal){
                r_str = "Injured Animal"
            }else if(report == reportType.adoptionType){
                r_str = "Adoption"
            }else if(report == reportType.volunteerOpp){
                r_str = "Volunteer Opp"
            }
            EZLoadingActivity.show("Processing data", disableUI: true)
            let dataRef = Database.database().reference().child("reportsNode").childByAutoId()
            let dataDic:[String:Any]=[
                "Username":user.name,
                "Phone":user.phone,
                "Email":user.email,
                "Lat":lat,
                "Lon":lon,
                "Details":detText.text as NSString,
                "Report Type":r_str as NSString
            ]
            dataRef.setValue(dataDic){ error,ref -> Void in
                if(error == nil){
                    let storage = Storage.storage()
                    let storageRef = storage.reference().child("reportsPictures").child(ref.key!)
                    _ = storageRef.putData(self.imgData, metadata: nil) { (metadata, error) in
                        if(error == nil){
                            EZLoadingActivity.hide(true,animated: true)
                            showSuccess(msg:"This alert has been issued successfully!")
                            self.textView.text = ""
                            self.imgData=nil
                            self.performSegue(withIdentifier: "back", sender: self)
                        }else{
                            EZLoadingActivity.hide(false,animated:true)
                            showAlert(msg: error!.localizedDescription)
                        }
                    }
                }else{
                    EZLoadingActivity.hide(false, animated: true)
                    showAlert(msg: error!.localizedDescription)
                }
            }
            
        }
    }
    @IBAction func selectImg(_ sender: Any) {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
}
//TODO :- Add Image Picker Functionality
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            print(pickedImage.pngData())
            imgData = pickedImage.pngData()
        }
     
        dismiss(animated: true, completion: nil)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
