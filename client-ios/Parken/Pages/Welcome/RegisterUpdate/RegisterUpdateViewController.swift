import UIKit

class RegisterUpdateViewController: UIViewController {

     var phoneNumber = ""
      
      @IBOutlet weak var documentNumberField: PrimaryTextFieldStyle!
      @IBOutlet weak var emailField: PrimaryTextFieldStyle!
      
      override func viewDidLoad() {
          super.viewDidLoad()

          self.navigationController?.setNavigationBarHidden(false, animated: false)
      }
    
      @IBAction func updateAccountClick(_ sender: Any) {
          // TODO: enviar novos dados
          if true {
              performSegue(withIdentifier: "RegisterUpdateToMainSegue", sender: nil)
          }
      }
      
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          // Get the new view controller using segue.destination.
          // Pass the selected object to the new view controller.
      }

}
