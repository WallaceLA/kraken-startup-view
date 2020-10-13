import UIKit
import FirebaseDatabase
import FirebaseAuth
import PhoneNumberKit
import SwiftMaskTextfield

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var passwordField: PrimaryTextFieldStyle!
    @IBOutlet weak var emailField: PrimaryTextFieldStyle!
    @IBOutlet weak var phoneNumberField: SwiftMaskTextfield!
    @IBOutlet weak var documentNumberField: SwiftMaskTextfield!
    @IBOutlet weak var lastNameField: PrimaryTextFieldStyle!
    @IBOutlet weak var firstNameField: PrimaryTextFieldStyle!
    
    var emailAddress = ""
    var passwordTyped = ""

    var ref:DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.documentNumberField.formatPattern = "###.###.###-##"
        self.phoneNumberField.formatPattern = "+## (##) #####-####"
        
        passwordField.isSecureTextEntry = true
        
        emailField.text = emailAddress
        passwordField.text = passwordTyped
    }

    
    @IBAction func registerClick(_ sender: UIButton) {
        
        guard let emailTxt = emailField.text,
            let passwordTxt = passwordField.text else{
                return
        }
        
        FirebaseAuth.Auth.auth().createUser(withEmail: emailTxt, password: passwordTxt, completion: { [weak self] result, error in
        
        guard self != nil else{
            return
        }
        guard error == nil else {
          
            print("Criacao de conta falhou")
            return
            }
            
            print("Criação de conta feita com sucesso.")
            
            FirebaseAuth.Auth.auth().signIn(withEmail: emailTxt, password: passwordTxt , completion: { [weak self] result, error in
                           guard self != nil else{
                               return
                           }
                           guard error == nil else {
                            print("Login falhou.")
                               return
                           }
                           
                           print("Voce esta logado.")
            
                       })
            
            let user = Auth.auth().currentUser;
            self!.ref.child("users").child(user!.uid).setValue(["firstname":self!.firstNameField.text!, "lastname":self!.lastNameField.text!, "cpf":self!.documentNumberField.text!, "phone":self!.phoneNumberField.text!, "email":self!.emailField.text!, "password":self!.passwordField.text!])
            
            do{
                try Auth.auth().signOut()
                print("Você está deslogado.")
            } catch let signOutError as NSError {
                print("Logout falhou.", signOutError)
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
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let signInView = segue.destination as? AccessViewController {
            signInView.emailTxt = emailField.text!
        }
    }
    
    func showEmptyDataAlert(){
        
        let alert = UIAlertController(title: "Dados incorretos", message: "Os dados inseridos estao incorretos", preferredStyle: .alert)
                  
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true)
    }
    
}
