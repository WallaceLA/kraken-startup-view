import UIKit
import heresdk
import Jelly

class HomeViewController: UIViewController {
    
    @IBOutlet var mapView: MapViewLite!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        /*
        let viewController = HomeViewController()
        var slidePresentation = SlidePresentation(direction: .left)
        let animator = Animator(presentation: slidePresentation)
        animator.prepare(presentedViewController: viewController)
        present(viewController, animated: true, completion: nil)
        */
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
