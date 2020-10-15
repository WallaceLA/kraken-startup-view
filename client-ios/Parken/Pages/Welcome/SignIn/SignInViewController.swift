import UIKit
import SGCodeTextField
import Firebase
import FirebaseDatabase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var codeSecurityField: SGCodeTextField!
    @IBOutlet weak var retryTimeLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    var ref:DatabaseReference! = Database.database().reference()
    
    var phoneNumber = ""
    private var retryCodeTime = 60
    var tempo:Timer!
    var timeLeft = 60
        
    @objc func onTimerFires(){
        
            if timeLeft != 0{
                retryTimeLabel.text = "\(timeLeft)"
                timeLeft -= 1
            } else {
                tempo.invalidate()
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        codeSecurityField.count = 4
        //codeSecurityField.placeholder = "*"
        codeSecurityField.textColorFocused = UIColor.brown
        codeSecurityField.refreshUI()
        
        self.tempo = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        
        let userID = Auth.auth().currentUser?.uid
        
        ref?.child("users").child(userID!).observeSingleEvent(of: .value, with: {(snapshot) in
        if let getData = snapshot.value as? NSDictionary {
            
            print(getData)
            
            let phone = getData["phone"] as? String ?? ""
            print(phone)
            
            self.phoneNumberLabel.text = phone
            }
        })
            
        retryTimeLabel.text = String("\(timeLeft)")
    }
    
    @IBAction func acessarClick(_ sender: UIButton) {
        if true {
            performSegue(withIdentifier: "SignInToMainSegue", sender: nil)
        } else {
           
        }
    }

}
