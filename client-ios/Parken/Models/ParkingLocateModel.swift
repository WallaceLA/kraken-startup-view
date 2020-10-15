import Foundation
import heresdk

class ParkingLocateModel: NSObject {
    
    var Address: String
    var Distance: String
    var Ammount: String
    var Rates: String
    var Localization: MapMarkerLite
    var Description: String
    var Title: String
    var Id: String
    
    init(_ address: String, _ distance: String, _ ammount: String, _ rates: String, _ localization: MapMarkerLite, _ description: String, _ title: String, _ id: String) {
        Address = address
        Distance = distance
        Ammount = ammount
        Rates = rates
        Localization = localization
        Description = description
        Title = title
        Id = id
    }
}
