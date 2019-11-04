import Foundation

class User{
    var name:String
    var email:String
    var phone:String
    init(){
        self.name=""
        self.email=""
        self.phone=""
    }
    init(name:String,email:String,phone:String) {
        self.name = name
        self.email = email
        self.phone = phone
    }
}
