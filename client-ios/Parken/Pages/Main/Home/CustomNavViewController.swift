import UIKit
import FirebaseDatabase
import FirebaseAuth

class CustomNavViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    var ref:DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let userID = Auth.auth().currentUser?.uid;
        
        ref?.child("users").child(userID!).observeSingleEvent(of: .value, with: {(snapshot) in
            if let getData = snapshot.value as? NSDictionary {
                
                print(getData)
                
                let firstname = getData["firstname"] as? String ?? ""
                
                /*let regex = try! NSRegularE"\(firstname)")xpression(pattern: "[A-Z]+\w")
                let range = NSRange(location: 0, length: String(firstname).utf16.count)
                
                self.nameLabel.text! += "\(regex.firstMatch(in: String(firstname), options: [], range: range) != nil)!"*/
                print(firstname)
                
                self.nameLabel.text! += "\(firstname)!"
                
            }
        })*/
    }
    
    @IBAction func sairBtnClick(_ sender: Any) {
        performSegue(withIdentifier: "SairToWelcomeSegue", sender: nil)
    }
    
}
