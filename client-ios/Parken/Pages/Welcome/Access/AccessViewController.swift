import UIKit
import PhoneNumberKit

class AccessViewController: UIViewController {

    @IBOutlet weak var phoneNumberField: PhoneNumberTextField!
    @IBOutlet weak var signInButton: UIButton!
    
    let phoneNumberKit = PhoneNumberKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        phoneNumberField.withFlag = true
        phoneNumberField.withExamplePlaceholder = true
    }
   
    @IBAction func signInClick(_ sender: Any) {
        // TODO: Validar telefone
        
        if true {
            performSegue(withIdentifier: "AccessToSignInSegue", sender: nil)
            phoneNumberField.text = ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let signInView = segue.destination as? SignInViewController {
            signInView.phoneNumber = phoneNumberField.text!
        }
    }
}
