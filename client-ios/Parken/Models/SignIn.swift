import UIKit
import Foundation

class SignIn: NSObject {

    var codeSecurity: String
    var retryTime: UILabel
    var phoneNumber: UILabel
    
    init(codeSecurity: String, retryTime: UILabel, phoneNumber: UILabel) {
        self.codeSecurity = codeSecurity
        self.retryTime = retryTime
        self.phoneNumber = phoneNumber
    }
    
}
