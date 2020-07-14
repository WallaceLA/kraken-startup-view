import UIKit

class RegisterViewController: UIViewController {

    var phoneNumber = ""
    
    @IBOutlet weak var firstNameField: PrimaryTextFieldStyle!
    @IBOutlet weak var lastNameField: PrimaryTextFieldStyle!
    @IBOutlet weak var documentNumberField: PrimaryTextFieldStyle!
    @IBOutlet weak var emailField: PrimaryTextFieldStyle!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func registerClick(_ sender: UIButton) {
        // TODO: enviar cadastro
        performSegue(withIdentifier: "RegisterToMain", sender: nil)
    }
    
    @IBAction func updatePhoneNumberClick(_ sender: Any) {
        performSegue(withIdentifier: "RegisterToChangePhoneSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
