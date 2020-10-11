import UIKit
import FirebaseDatabase
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var firstNameField: PrimaryTextFieldStyle!
    @IBOutlet weak var lastNameField: PrimaryTextFieldStyle!
    @IBOutlet weak var documentNumberField: PrimaryTextFieldStyle!
    @IBOutlet weak var emailField: PrimaryTextFieldStyle!
    @IBOutlet weak var passwordField: PrimaryTextFieldStyle!
    
    var emailAddress = ""
    var passwordTyped = ""

    var ref:DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        passwordField.isSecureTextEntry = true
        
        emailField.text = emailAddress
        passwordField.text = passwordTyped
    }
    
    @IBAction func registerClick(_ sender: UIButton) {
        // TODO: enviar cadastro
        self.ref.child("users").setValue(["firstname":firstNameField.text, "lastname":lastNameField.text, "cpf":documentNumberField.text, "email":emailField.text, "password":passwordField.text])
        
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
        
            showUserDataAlert()
    }
    
    func showUserDataAlert(){
        
        let alert = UIAlertController(title: "Dados cadastrados", message: "Os dados foram cadastrados com sucesso!", preferredStyle: .alert)
                  
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true)
    }
    
    @IBAction func updatePhoneNumberClick(_ sender: Any) {
        /*performSegue(withIdentifier: "RegisterToChangePhoneSegue", sender: nil*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let signInView = segue.destination as? AccessViewController {
            signInView.emailTxt = emailField.text!
        }
    }
    
}
