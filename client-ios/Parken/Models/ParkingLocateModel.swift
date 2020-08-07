import Foundation
import heresdk

class ParkingLocateModel: NSObject {
    
    var Ammount: String
    var Rates: String
    var Localization: MapMarkerLite
    
    init(_ ammount: String, _ rates: String, _ localization: MapMarkerLite) {
        Ammount = ammount
        Rates = rates
        Localization = localization
    }
}
