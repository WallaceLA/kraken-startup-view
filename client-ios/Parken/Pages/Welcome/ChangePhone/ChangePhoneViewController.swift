import UIKit

class ChangePhoneViewController: UIViewController {

    var phoneNumber = ""
    
    @IBOutlet weak var documentNumberField: PrimaryTextFieldStyle!
    @IBOutlet weak var emailField: PrimaryTextFieldStyle!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //ChangePhoneToMainSegue

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
