import Foundation

class UserProfile: NSObject
{
    
    var firstName: String
    var lastName: String
    var documentNumber: String
    var email: String
    var phoneNumber: String
    var signIn: UIButton

    init(firstName: String, lastName: String, documentNumber: String, email: String, phoneNumber: String, signIn: UIButton) {
        self.firstName = firstName
        self.lastName = lastName
        self.documentNumber = documentNumber
        self.email = email
        self.phoneNumber = phoneNumber
        self.signIn = signIn
    }
    
}
