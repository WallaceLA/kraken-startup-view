import UIKit
import Jelly

class DealActionsViewController: UIViewController {

     var jellyAnimator: Animator?
    
     override func viewDidLoad() {
         super.viewDidLoad()

        let slidePresentation = SlidePresentation(direction: .top)
        let animator = Animator(presentation: slidePresentation)
        
         self.jellyAnimator = animator
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
