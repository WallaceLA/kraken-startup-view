import UIKit
import FirebaseDatabase
import FirebaseAuth
import InputMask

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var firstNameField: PrimaryTextFieldStyle!
    @IBOutlet weak var lastNameField: PrimaryTextFieldStyle!
    @IBOutlet weak var documentNumberField: UITextField!
    @IBOutlet weak var emailField: PrimaryTextFieldStyle!
    @IBOutlet weak var passwordField: PrimaryTextFieldStyle!
    @IBOutlet var listener: MaskedTextFieldDelegate!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    var emailAddress = ""
    var passwordTyped = ""

    var ref:DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        /*listener.affinityCalculationStrategy = .prefix
        listener.primaryMaskFormat = "[000].[000].[000]-[00]"*/
        
        passwordField.isSecureTextEntry = true
        
        emailField.text = emailAddress
        passwordField.text = passwordTyped
    }
    
    @IBAction func registerClick(_ sender: UIButton) {
        // TODO: enviar cadastro
        self.ref.child("users").setValue(["firstname":firstNameField.text, "lastname":lastNameField.text, "cpf":documentNumberField.text,
            "phone":phoneNumberField.text,
            "email":emailField.text,
            "password":passwordField.text])
        
        guard let email = emailField.text,
            let password = passwordField.text else{
                return
        }
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
        
        guard self != nil else{
            return
        }
        guard error == nil else {
            print("Criacao de conta falhou")
            return
            }
        })
        
            
    }
    
    func showUserDataAlert(){
        
        let alert = UIAlertController(title: "Dados cadastrados", message: "Os dados foram cadastrados com sucesso!", preferredStyle: .alert)
                  
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true)
    }
    
    @IBAction func updatePhoneNumberClick(_ sender: Any) {
        /*performSegue(withIdentifier: "RegisterToChangePhoneSegue", sender: nil*/
        showUserDataAlert()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let signInView = segue.destination as? AccessViewController {
            signInView.emailTxt = emailField.text!
        }
    }
    
}
