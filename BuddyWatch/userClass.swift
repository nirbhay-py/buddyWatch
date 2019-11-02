import Foundation

class User{
    var name:String
    var email:String
    var city:String
    init(){
        self.name=""
        self.email=""
        self.city=""
    }
    init(name:String,email:String,city:String) {
        self.name = name
        self.email = email
        self.city = city
    }
}
