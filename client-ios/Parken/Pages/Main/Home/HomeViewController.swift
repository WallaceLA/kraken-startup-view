import UIKit
import heresdk
import Jelly

class HomeViewController: UIViewController {
    
    @IBOutlet var mapView: MapViewLite!
    
     var animator: Jelly.Animator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let uiConfiguration = PresentationUIConfiguration(
            cornerRadius: 10,
            backgroundStyle: .dimmed(alpha: 0.0),
            isTapBackgroundToDismissEnabled: false)
        
        let size = PresentationSize(
            width: .custom(value: (self.view.frame.width * 0.8)),
            height: .custom(value: (self.view.frame.height * 0.4)))
        
        let alignment = PresentationAlignment(vertical: .bottom, horizontal: .center)
        
        let marginGuards = UIEdgeInsets(top: 40, left: 16, bottom: 40, right: 16)
        
        let timing = PresentationTiming(duration: .normal, presentationCurve: .linear, dismissCurve: .linear)

        let interactionConfiguration = InteractionConfiguration(
            presentingViewController: self,
            completionThreshold: 0.5,
            dragMode: .edge)
        
        /*
        let slidePresentation = SlidePresentation(
            direction: .bottom,
            size: .halfscreen
        )
        */
        
        let slidePresentation = CoverPresentation(
            directionShow: .top,
            directionDismiss: .bottom,
            uiConfiguration: uiConfiguration,
            size: size,
            alignment: alignment,
            marginGuards: marginGuards,
            timing: timing,
            spring: .none,
            interactionConfiguration: interactionConfiguration)
        
        
        //                   storyboard!.instantiateViewController(withIdentifier: "DealActionsViewController")
        //let viewController = DealActionsViewController()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DealActions") as! DealActionsViewController
        
        
        animator = Animator(presentation: slidePresentation)
        animator?.prepare(presentedViewController: viewController)
        present(viewController, animated: true, completion: nil)
        
        if true {
            viewController.interactionAction = { [weak self] in
                   let newGuards = UIEdgeInsets(top: 70, left: 8, bottom: 0, right: 8)
                 try! self?.animator?.updateMarginGuards(marginGuards: newGuards, duration: .medium)
            }
        }
       
        mapView.mapScene.loadScene(mapStyle: .normalDay, callback: onLoadScene)
    }
    
    func onLoadScene(errorCode: MapSceneLite.ErrorCode?) {
        if let error = errorCode {
            print("Error: Map scene not loaded, \(error)")
        } else {
            // Configure the map.
            mapView.camera.setTarget(GeoCoordinates(latitude: 52.518043, longitude: 13.405991))
            mapView.camera.setZoomLevel(13)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        mapView.handleLowMemory()
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
