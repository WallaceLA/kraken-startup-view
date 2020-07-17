import UIKit

class DealActionsViewController: UIViewController {

    var interactionAction: (() -> ())?
    
     override func viewDidLoad() {
         super.viewDidLoad()
         modalPresentationCapturesStatusBarAppearance = true
     }

    @IBAction func actionButtonPressed(_ sender: Any) {
           if let interactionAction = interactionAction {
               interactionAction()
           } else {
               self.dismiss(animated: true, completion: nil)
           }
       }
       
       override var prefersStatusBarHidden: Bool {
           return true
       }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
