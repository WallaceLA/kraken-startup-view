import UIKit
import FirebaseAuth

class RegisterUpdateViewController: UIViewController {
    
    @IBOutlet weak var emailField: PrimaryTextFieldStyle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    /*@IBAction func passwordResetClick(_ sender: Any) {
        guard let email = emailField.text, email != "" else {
            return
        }
        
        resetPassword(email: email, onSuccess: {
            self.view.endEditing(true)
            self.showUserDataAlert()
        }, onError: { (error) in
            self.resetFailedAlert()
        })
        self.performSegue(withIdentifier: "AtualizaToWelcomeSegue", sender: self)
    }*/

    /*func resetPassword(email: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in

                if error == nil {
                    onSuccess()
                } else {
                    onError(error!.localizedDescription)
                }
            
        })
    }
    
    func showUserDataAlert(){
        let alert = UIAlertController(title: "Nova senha enviada", message: "O novo codigo foi enviado para o seu e-mail!", preferredStyle: .alert)
                  
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true)
    }*/
    
    /*func resetFailedAlert(){
        let resetFailedAlert = UIAlertController(title: "Reset falhou", message: "Erro: Nao foi possivel realizar o reset de senha.", preferredStyle: .alert)
        resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(resetFailedAlert, animated: true, completion: nil)
    }
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        showUserDataAlert()
    }*/
    
}
