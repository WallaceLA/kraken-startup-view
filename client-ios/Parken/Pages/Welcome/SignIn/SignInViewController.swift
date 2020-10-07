import UIKit
import SGCodeTextField
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var codeSecurityField: SGCodeTextField!
    @IBOutlet weak var retryTimeLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    var phoneNumber = ""
    private var retryCodeTime = 60
    var tempo:Timer?
    var timeLeft = 60
        
        @objc func onTimerFires(){
            timeLeft -= 1
            
            if timeLeft <= 0{
                tempo?.invalidate()
                tempo = nil
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        codeSecurityField.count = 4
        //codeSecurityField.placeholder = "*"
        codeSecurityField.textColorFocused = UIColor.brown
        codeSecurityField.refreshUI()
        
        tempo = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        
        phoneNumberLabel.text = phoneNumber
        retryTimeLabel.text = String("\(timeLeft)")
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
