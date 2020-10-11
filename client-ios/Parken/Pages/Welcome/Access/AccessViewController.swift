import UIKit
import PhoneNumberKit
import FirebaseAuth

class AccessViewController: UIViewController {
    
    @IBOutlet weak var instBtn: SecondButtonStyle!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var emailTxt = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        emailTextField.placeholder = "Insira o seu e-mail..."
        passwordTextField.placeholder = "Insira a sua senha..."
        passwordTextField.isSecureTextEntry = true
        
        emailTextField.text = emailTxt
        
    }
    
    @IBAction func signInClick(_ sender: Any) {
        
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else{
                showEmptyDataAlert()
                return
            }

    }
    
    @IBAction func instBtnClick(_ sender: Any) {
        
            performSegue(withIdentifier: "SignInToPresentationSegue", sender: nil)
        }
    
    func showEmptyDataAlert(){
        
        let alert = UIAlertController(title: "Dados incorretos", message: "Os dados inseridos estao incorretos", preferredStyle: .alert)
                  
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true)
    }
    
    func showCreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Criar conta", message: "Voce gostaria de criar uma conta?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: { _ in
            
            /*FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
                
                guard self != nil else{
                    return
                }
                guard error == nil else {
                    print("Criacao de conta falhou")
                    return
                }*/
            
            self.performSegue(withIdentifier: "criarContaSegue", sender: self)
                
            })
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { _ in
        }))
        
        present(alert, animated: true)
    }
           
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else{
                return true
        }
        
        if(emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false) {
            
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password , completion: { [weak self] result, error in
                guard let strongSelf = self else{
                    return
                }
                guard error == nil else {
                    strongSelf.showCreateAccount(email: email, password: password)
                    return
                }
                
                print("You have signed in")
                
                self?.performSegue(withIdentifier: "AccessToSignInSegue", sender: self)
                
            })
            
            return false
        } else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let signInView = segue.destination as? SignInViewController {
            signInView.phoneNumber = emailTextField.text!
        }
        
        if let signInView = segue.destination as? RegisterViewController {
            signInView.emailAddress = emailTextField.text!
            signInView.passwordTyped = passwordTextField.text!
        }
    }
    
    func validateEmail(emailTyped:String) -> Bool{
         let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
         let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
         return emailPredicate.evaluate(with: emailTyped)
     }
    
}
