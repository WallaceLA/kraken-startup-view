import UIKit
import SGCodeTextField

class SignInViewController: UIViewController {
    
    @IBOutlet weak var codeSecurityField: SGCodeTextField!
    @IBOutlet weak var retryTimeLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    var phoneNumber = ""
    private var retryCodeTime = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        codeSecurityField.count = 4
        //codeSecurityField.placeholder = "*"
        codeSecurityField.textColorFocused = UIColor.brown
        codeSecurityField.refreshUI()
        
        phoneNumberLabel.text = phoneNumber
        retryTimeLabel.text = String(retryCodeTime)
    }
    
    @IBAction func acessarClick(_ sender: UIButton) {
        if true {
            performSegue(withIdentifier: "SignInToMainSegue", sender: nil)
        } else {
            // TODO: Nao tem conta
            performSegue(withIdentifier: "SignToRegisterSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let registerView = segue.destination as? RegisterViewController {
            registerView.phoneNumber = phoneNumber
        }
    }
}
