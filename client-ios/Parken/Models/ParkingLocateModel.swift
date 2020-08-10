import Foundation
import heresdk

class ParkingLocateModel: NSObject {
    
    var Address: String
    var Distance: String
    var Ammount: String
    var Rates: String
    var Localization: MapMarkerLite
    
    init(_ address: String, _ distance: String, _ ammount: String, _ rates: String, _ localization: MapMarkerLite) {
        Address = address
        Distance = distance
        Ammount = ammount
        Rates = rates
        Localization = localization
    }
}
