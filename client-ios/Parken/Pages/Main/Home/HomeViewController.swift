import UIKit
import heresdk
import Jelly
import CoreLocation

class HomeViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var dealPopupSafeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dealPopupHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dealPopupVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dismissPopupButton: UIButton!
    
    @IBOutlet var mapView: MapViewLite!
    
    // first step
    @IBOutlet weak var firstStepView: UIView!
    @IBOutlet weak var searchAddress: UISearchBar!
    @IBOutlet weak var addressTable: UITableView!
    @IBOutlet weak var placesFoundedLabel: UILabel!
    
    // second step
    @IBOutlet weak var secondStepView: UIView!
    @IBOutlet weak var addressSelectedLabel: UILabel!
    
    
    // navbar definitions
    private var navCustomAnimator: Jelly.Animator?
    private var customNavViewController: CustomNavViewController?
    
    // modal definitions
    private let dealPopupMinHeight = CGFloat(0.2)
    private let dealPopupMaxHeight = CGFloat(0.8)
    
    // map definitions
    private var mapController: HereSdkController!
    private var locationManager = CLLocationManager()
    
    
    // first step
    private var isSelecting = false
    private var parkingAddressList: [String] = []
    var suggestAddressList: [Suggestion] = []
    
    
    // second step
    private var isSearching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchAddress.delegate = self
        
        addressTable.delegate = self
        addressTable.dataSource = self
        
        locationManager.delegate = self
        
        loadNavPresentation()
        loadDealModal()
        
        requestGPSAuthorization()
        mapController = HereSdkController(viewController: self, mapView: mapView!)
        mapView.mapScene.loadScene(mapStyle: .normalDay, callback: onLoadMap)
    }
    
    // NavBar Definitions
    @IBAction func openNavClick(_ sender: Any) {
        present(customNavViewController!, animated: true, completion: nil)
    }
    
    @IBAction func dismissPopupClick(_ sender: Any) {
        MinimizeDealModal()
    }
    
    private func loadNavPresentation() {
        let uiConfiguration = PresentationUIConfiguration(
            cornerRadius: 0,
            backgroundStyle: .dimmed(alpha: 0.5),
            isTapBackgroundToDismissEnabled: true)
        
        let size = PresentationSize(
            width: .custom(value: self.view.frame.width * 0.8),
            height: .fullscreen)
        
        let alignment = PresentationAlignment(vertical: .top, horizontal: .left)
        
        let marginGuards = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let timing = PresentationTiming(duration: .normal, presentationCurve: .linear, dismissCurve: .linear)
        
        let interactionConfiguration = InteractionConfiguration(
            presentingViewController: self,
            completionThreshold: 0.5,
            dragMode: .edge)
        
        let dealActionsPresentation = CoverPresentation(
            directionShow: .left,
            directionDismiss: .left,
            uiConfiguration: uiConfiguration,
            size: size,
            alignment: alignment,
            marginGuards: marginGuards,
            timing: timing,
            spring: .none,
            interactionConfiguration: interactionConfiguration)
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        customNavViewController = storyboard.instantiateViewController(withIdentifier: "CustomNav") as? CustomNavViewController
        
        navCustomAnimator = Animator(presentation: dealActionsPresentation)
        navCustomAnimator?.prepare(presentedViewController: customNavViewController!)
    }
    
    private func loadDealModal() {
        firstStepView.isHidden = false
        secondStepView.isHidden = true
        
        secondStepView.frame.origin.x = 0
        
        dismissPopupButton.alpha = 0
        
        dealPopupSafeTopConstraint.constant = self.view.frame.height * dealPopupMaxHeight
        dealPopupHeightConstraint.constant = self.view.frame.height * dealPopupMaxHeight
        dealPopupVerticalConstraint.constant = (self.view.frame.height * (dealPopupMaxHeight - dealPopupMinHeight)) * -1
    }
    
    private func maximizeDealModal() {
        dismissPopupButton.alpha = 0.1
        
        UIView.animate(withDuration: 0.5, animations: {
            self.dealPopupSafeTopConstraint.constant = self.view.frame.height * self.dealPopupMinHeight
            self.dealPopupVerticalConstraint.constant = 0
            self.placesFoundedLabel.isHidden = false
            self.addressTable.isHidden = false
        })
    }
    
    private func MinimizeDealModal() {
        dismissPopupButton.alpha = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.dealPopupSafeTopConstraint.constant = self.view.frame.height * self.dealPopupMaxHeight
            self.dealPopupVerticalConstraint.constant = (self.view.frame.height * (self.dealPopupMaxHeight - self.dealPopupMinHeight)) * -1
            self.placesFoundedLabel.isHidden = true
            self.addressTable.isHidden = true
        })
        
    }
    
    
    // ------ First Step
    // Conforming to SearchBarDelegate protocol.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        
        if isSearching {
            maximizeDealModal()
            
            mapController.getSuggest(textQuery: searchText)
        } else {
            MinimizeDealModal()
        }
        
        addressTable.reloadData()
    }
    
    // Conforming to TableViewDelegate protocol.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? suggestAddressList.count : 0
    }
    
    // Conforming to TableViewDelegate protocol.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addressCell = addressTable.dequeueReusableCell(withIdentifier: "suggestAddressCell", for: indexPath)
        
        let address = suggestAddressList[indexPath.row]
        
        addressCell.textLabel?.text = address.title
        
        return addressCell
    }
    
    // Conforming to TableViewDelegate protocol.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let address = suggestAddressList[indexPath.row]
        
        guard let locValue: GeoCoordinates = address.place?.coordinates else { return }
        
        let addressLocate = GeoCoordinates(latitude: locValue.latitude, longitude: locValue.longitude)
        
        print("focus on address selected")
        
        isSearching = false
        isSelecting = true
        searchAddress.text = ""
        
        firstStepView.isHidden = true
        secondStepView.isHidden = false
        
        addressSelectedLabel.text = address.title
        
        let camera = mapView.camera
        camera.setTarget(addressLocate)
        camera.setZoomLevel(13)
        
        mapController.generateRandomMapMarkers(quantity: Int.random(in: 2...5))
        
        mapController.cleanDestineLocateMarker()
        mapController.setDestineLocateMarker(geoCoordinates: addressLocate)
    }
    
    
    // ------ Second Step
    
    
    
    // Map Definitions
    private func onLoadMap(errorCode: MapSceneLite.ErrorCode?) {
        if let error = errorCode {
            print("Error: Map scene not loaded, \(error)")
        } else {
            guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
            
            let userLocate = GeoCoordinates(latitude: locValue.latitude, longitude: locValue.longitude)
            
            let camera = mapView.camera
            camera.setTarget(userLocate)
            camera.setZoomLevel(13)
            
            print("user locate initial")
            
            mapController.setUserLocateMarker(geoCoordinates: userLocate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        
        print("user locate updating")
        
        guard let locValue: CLLocationCoordinate2D = location?.coordinate else { return }
        
        let userLocate = GeoCoordinates(latitude: locValue.latitude, longitude: locValue.longitude)
        
        mapController.setUserLocateMarker(geoCoordinates: userLocate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Errors: " + error.localizedDescription)
    }
    
    private func requestGPSAuthorization() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func centralizeUserMap(_ sender: Any) {
        guard let userLocate: GeoCoordinates = mapController.userLocateMapMarker?.coordinates else { return }
        
        let camera = mapView.camera
        camera.setTarget(userLocate)
        camera.setZoomLevel(13)
    }
    
    // Native Definitions
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
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
