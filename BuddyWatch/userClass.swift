import Foundation

class User{
    var name:String
    var phone:String
    var city:String
    init(){
        self.name=""
        self.phone=""
        self.city=""
    }
    init(name:String,phone:String,city:String) {
        self.name = name
        self.phone = phone
        self.city = city
    }
}
