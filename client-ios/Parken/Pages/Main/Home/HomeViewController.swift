import UIKit
import heresdk
import Jelly

class HomeViewController: UIViewController {
    
    @IBOutlet var mapView: MapViewLite!
    
    var dealActionsAnimator: Jelly.Animator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        onLoadCustomPresentation()
        mapView.mapScene.loadScene(mapStyle: .normalDay, callback: onLoadMap)
    }
    
    func onLoadMap(errorCode: MapSceneLite.ErrorCode?) {
        if let error = errorCode {
            print("Error: Map scene not loaded, \(error)")
        } else {
            // Configure the map.
            mapView.camera.setTarget(GeoCoordinates(latitude: 52.518043, longitude: 13.405991))
            mapView.camera.setZoomLevel(13)
        }
    }
    
    func onLoadCustomPresentation() {
         let uiConfiguration = PresentationUIConfiguration(
             cornerRadius: 25,
             backgroundStyle: .dimmed(alpha: 0.0),
             isTapBackgroundToDismissEnabled: false,
             corners: [.layerMaxXMinYCorner,.layerMinXMinYCorner])
         
         let size = PresentationSize(
             width: .fullscreen,
             height: .custom(value: (self.view.frame.height * 0.2)))
         
         let alignment = PresentationAlignment(vertical: .bottom, horizontal: .center)
         
         let marginGuards = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
         
         let timing = PresentationTiming(duration: .normal, presentationCurve: .linear, dismissCurve: .linear)

         let interactionConfiguration = InteractionConfiguration(
             presentingViewController: self,
             completionThreshold: 0.5,
             dragMode: .edge)
         
        
         let dealActionsPresentation = CoverPresentation(
             directionShow: .bottom,
             directionDismiss: .bottom,
             uiConfiguration: uiConfiguration,
             size: size,
             alignment: alignment,
             marginGuards: marginGuards,
             timing: timing,
             spring: .none,
             interactionConfiguration: interactionConfiguration)
        
         let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
         let viewController = storyboard.instantiateViewController(withIdentifier: "DealActions") as! DealActionsViewController
         
         dealActionsAnimator = Animator(presentation: dealActionsPresentation)
         dealActionsAnimator?.prepare(presentedViewController: viewController)
         present(viewController, animated: true, completion: nil)
         
         viewController.interactionActionMaxime = { [weak self] in
            let newSize = PresentationSize(
                width: .fullscreen,
                height: .custom(value: (self!.view.frame.height * 0.5)))
            try! self?.dealActionsAnimator?.updateSize(presentationSize: newSize, duration: .medium)
         }
        
        viewController.interactionActionMinimize = { [weak self] in
           let newSize = PresentationSize(
               width: .fullscreen,
               height: .custom(value: (self!.view.frame.height * 0.2)))
           try! self?.dealActionsAnimator?.updateSize(presentationSize: newSize, duration: .medium)
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
