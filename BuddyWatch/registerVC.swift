import UIKit
import FirebaseAuth
import Firebase
import EZLoadingActivity
class registerVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    var thisUser=User()
    var pswd:String=""
    var data:Data!
    let imagePicker = UIImagePickerController()
    var flag:Bool=false
//MARK:- IB OUTLETS
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var txt: UITextField!
    @IBOutlet weak var lblTop: NSLayoutConstraint!
    @IBOutlet weak var lblConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtConstraint: NSLayoutConstraint!
    @IBOutlet weak var btn1const: NSLayoutConstraint!
    @IBOutlet weak var btn5Const: NSLayoutConstraint!
    @IBOutlet weak var btn2const: NSLayoutConstraint!
    @IBOutlet weak var btn3const: NSLayoutConstraint!
    @IBOutlet weak var btn4const: NSLayoutConstraint!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var selectBtnConst: NSLayoutConstraint!
    @IBOutlet weak var txtLeading: NSLayoutConstraint!
    @IBOutlet weak var btn0const: NSLayoutConstraint!
    @IBOutlet weak var lblHeight: NSLayoutConstraint!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var picConst: NSLayoutConstraint!
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:"dismissKeyboard")
        view.addGestureRecognizer(tap)
        profilePic.frame = CGRect(x:0,y:0,width:75,height: 75)
        profilePic.clipsToBounds = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        btn0const.constant -= view.bounds.width
        btn1const.constant -= view.bounds.width
        btn2const.constant -= view.bounds.width
        picConst.constant -= view.bounds.width
        btn3const.constant -= view.bounds.width
        btn4const.constant -= view.bounds.width
        btn5Const.constant -= view.bounds.width
        selectBtnConst.constant -= view.bounds.width;
        lblConstraint.constant -= view.bounds.width
        txtConstraint.constant -= view.bounds.width
        btn0.layer.cornerRadius = 5;
        btn1.layer.cornerRadius = 5;
        btn2.layer.cornerRadius = 5;
        btn3.layer.cornerRadius = 5;
        btn4.layer.cornerRadius = 5;
        btn5.layer.cornerRadius = 5;
        selectBtn.layer.cornerRadius = 5;
        
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.btn0const.constant += self.view.bounds.width
            self.lblConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        },completion: nil)
    }

    @IBAction func btn0Clicked(_ sender: Any) {
        self.placeholderLbl.text = "What's your name?"
        UIView.animate(withDuration:0.5, animations: {
            self.lblHeight.constant = 40;
            self.btn0const.constant-=self.view.bounds.width
            self.btn1const.constant+=self.view.bounds.width
            self.txtConstraint.constant+=self.view.bounds.width
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func btn1Clicked(_ sender: Any) {
        if(txt.text==""){
            showAlert(msg:"You can't leave this field blank!")
        }else{
            print(txt.text!)
            self.thisUser.name = txt.text!
            self.placeholderLbl.text = "What's your email?"
            txt.text=""
            txt.placeholder = "Enter here"
            UIView.animate(withDuration:0.5, animations: {
                self.btn1const.constant-=self.view.bounds.width
                self.btn2const.constant+=self.view.bounds.width
                self.view.layoutIfNeeded()
            })
        }
    }
    @IBAction func btn2Clicked(_ sender: Any) {
        if(txt.text==""){
            showAlert(msg:"You can't leave this field blank!")
        }else if(!(isValidEmail(emailStr: txt.text!))){
            showAlert(msg:"Looks like you entered an invalid email.")
        }else{
            self.thisUser.email = txt.text!
            self.placeholderLbl.text = "Phone number?"
            txt.text=""
            txt.placeholder = "Here you go"
            UIView.animate(withDuration:0.5, animations:{
                self.btn2const.constant-=self.view.bounds.width
                self.btn3const.constant+=self.view.bounds.width
                self.view.layoutIfNeeded()
            })
        }
    }
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBAction func btn3Clicked(_ sender: Any) {
        if(txt.text==""){
            showAlert(msg:"You can't leave this field blank!")
        }
        else if(txt.text?.count != 10){
            showAlert(msg: "Please enter a valid number!")
        }
        else{
            thisUser.phone = txt.text!
            self.placeholderLbl.text = "What's your password?"
            txt.text=""
            txt.placeholder = "Here you go"
            txt.isSecureTextEntry = true;
            UIView.animate(withDuration:0.5, animations: {
                self.btn3const.constant-=self.view.bounds.width
                self.btn4const.constant+=self.view.bounds.width
                self.view.layoutIfNeeded()
            })
        }
    }

    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func btn4Clicked(_ sender: Any) {
        print(self.thisUser.name,self.thisUser.phone,self.thisUser.email)
        if(txt.text==""){
            showAlert(msg:"You can't leave this field blank!")
        }else if(txt.text!.count<8){
            showAlert(msg: "Looks like your password is too short. You need atleast 8 characters")
        }else{
            pswd = txt.text!
            self.placeholderLbl.text = "Choose your best photo!"
            UIView.animate(withDuration:0.5, animations: {
                self.txtConstraint.constant -= self.view.bounds.width
                self.btn4const.constant-=self.view.bounds.width
                self.btn5Const.constant+=self.view.bounds.width
                self.selectBtnConst.constant+=self.view.bounds.width
                self.view.layoutIfNeeded()
            })
        }
    }
    @IBAction func btn5Clicked(_ sender: Any) {
        print(data.count)
        if(data==nil){
            showAlert(msg: "You need to pick an image.")
        }else if(data.count > 5000000){
            showAlert(msg: "You need to choose a lighter file.")
        }
        else{
            UIView.animate(withDuration: 0.5, animations: {
                self.picConst.constant+=self.view.bounds.width
                self.selectBtnConst.constant-=self.view.bounds.width
            })
            EZLoadingActivity.show("Loading...", disableUI: true)
            Auth.auth().createUser(withEmail: thisUser.email, password: pswd) { authResult, error in
                if(error==nil && Auth.auth().currentUser != nil ) {
                    let ref = Database.database().reference().child("userNode").child(Auth.auth().currentUser!.uid)
                    ref.setValue([
                        "username":self.thisUser.name,
                        "phone":self.thisUser.phone,
                        "email":self.thisUser.email
                    ]);
                    let storage = Storage.storage()
                    let storageRef = storage.reference().child("userPictures").child(Auth.auth().currentUser!.uid)
                    let uploadTask = storageRef.putData(self.data,metadata: nil) {(metadata,error) in
                        if(error != nil){
                            EZLoadingActivity.hide(false, animated: true)
                            showAlert(msg: error!.localizedDescription)
                        }else{
                            EZLoadingActivity.hide(true, animated: true)
                            self.performSegue(withIdentifier: "registerToMain", sender: nil)
                        }
                    }
                }
            }
        }
    }
    @IBAction func selectPressed(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

     
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePic.contentMode = .scaleAspectFit
            profilePic.image = pickedImage
            self.data = pickedImage.pngData()!
        }
        dismiss(animated: true, completion: nil)
    }
}


 


