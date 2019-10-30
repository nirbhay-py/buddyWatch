import Foundation

enum reportType{
    case adoptionType
    case injuredAnimal
}

class reportClass{
    var type:reportType
    var user:User
    var lat:Double
    var lon:Double
    var details:String
    var photo:Data
    init(type:reportType,user:User,lat:Double,lon:Double,details:String,photo:Data){
        self.type = type
        self.user = user
        self.lat = lat
        self.lon = lon
        self.details = details
        self.photo = photo
    }
}

