import UIKit
import FirebaseAuth

class RegisterUpdateViewController: UIViewController {
    
    @IBOutlet weak var emailField: PrimaryTextFieldStyle!
    @IBOutlet weak var updateAccountBtn: PrimaryButtonStyle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func updateAccountBtnClick(_ sender: Any) {
        // TODO: enviar novos dados
        guard let email = emailField.text else {
            return
        }
        
    FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
        DispatchQueue.main.async {
                if error != nil {
                    self.resetFailedAlert()
                } else {
                    self.confirmResetAlert()
                }
            }
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        showUserDataAlert()
    }
    
    func showUserDataAlert(){
        let alert = UIAlertController(title: "Nova senha enviada", message: "O novo codigo foi enviado para o seu e-mail!", preferredStyle: .alert)
                  
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true)
    }
    
    func resetFailedAlert(){
        let resetFailedAlert = UIAlertController(title: "Reset falhou", message: "Erro: Nao foi possivel realizar o reset de senha.", preferredStyle: .alert)
        resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(resetFailedAlert, animated: true, completion: nil)
    }
    
    func confirmResetAlert(){
        let resetFailedAlert = UIAlertController(title: "Nova senha enviada!", message: "Confira seu e-mail para o link de reset de senha.", preferredStyle: .alert)
        resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(resetFailedAlert, animated: true, completion: nil)
    }
    
}
