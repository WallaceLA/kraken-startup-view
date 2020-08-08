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
    @IBOutlet weak var suggestAddressTable: UITableView!
    @IBOutlet weak var placesFoundedLabel: UILabel!
    
    // second step
    @IBOutlet weak var secondStepView: UIView!
    @IBOutlet weak var parkingLocateTable: UITableView!
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
    var suggestAddressList: [Suggestion] = []
    
    
    // second step
    private var isSearching = false
    var destineLocateMapMarker: MapMarkerLite?
    var parkingLocateList: [ParkingLocateModel] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchAddress.delegate = self
        
        suggestAddressTable.delegate = self
        suggestAddressTable.dataSource = self
        
        parkingLocateTable.delegate = self
        parkingLocateTable.dataSource = self
        
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
    
    // DealModal definitions
    private func loadDealModal() {
        goToStep(step: 1)
        
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
            self.suggestAddressTable.isHidden = false
        })
    }
    
    private func MinimizeDealModal() {
        dismissPopupButton.alpha = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.dealPopupSafeTopConstraint.constant = self.view.frame.height * self.dealPopupMaxHeight
            self.dealPopupVerticalConstraint.constant = (self.view.frame.height * (self.dealPopupMaxHeight - self.dealPopupMinHeight)) * -1
            self.placesFoundedLabel.isHidden = true
            self.suggestAddressTable.isHidden = true
        })
        
    }
    
    // Map Definitions
    private func requestGPSAuthorization() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
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
    
    @IBAction func centralizeUserMap(_ sender: Any) {
        guard let userLocate: GeoCoordinates = mapController.userLocateMapMarker?.coordinates else { return }
        
        let camera = mapView.camera
        camera.setTarget(userLocate)
        camera.setZoomLevel(13)
    }
    
    private func getRandomGeoCoordinatesInViewport() -> GeoCoordinates {
        let geoBox = mapController.getMapViewGeoBox()
        let northEast = geoBox.northEastCorner
        let southWest = geoBox.southWestCorner
        
        let minLat = southWest.latitude
        let maxLat = northEast.latitude
        let lat = getRandom(min: minLat, max: maxLat)
        
        let minLon = southWest.longitude
        let maxLon = northEast.longitude
        let lon = getRandom(min: minLon, max: maxLon)
        
        return GeoCoordinates(latitude: lat, longitude: lon)
    }
    
    // Conforming to CLLocationManagerDelegate protocol.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        
        print("user locate updating")
        
        guard let locValue: CLLocationCoordinate2D = location?.coordinate else { return }
        
        let userLocate = GeoCoordinates(latitude: locValue.latitude, longitude: locValue.longitude)
        
        mapController.setUserLocateMarker(geoCoordinates: userLocate)
    }
    
    // Conforming to CLLocationManagerDelegate protocol.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Errors: " + error.localizedDescription)
    }
    
    
    private func getRandom(min: Double, max: Double) -> Double {
        return Double.random(in: min ... max)
    }
    
    
    // Conforming to TableViewDelegate protocol.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == parkingLocateTable {
            return parkingLocateTableView(tableView as! ParkingLocateTableView , numberOfRowsInSection: section)
        }
        
        return suggestAddressTableView(tableView as! SuggestAddressTableView , numberOfRowsInSection: section)
    }
    
    // Conforming to TableViewDelegate protocol.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == parkingLocateTable {
            return parkingLocateTableView(tableView as! ParkingLocateTableView, cellForRowAt: indexPath)
        }
        
        return suggestAddressTableView(tableView as! SuggestAddressTableView, cellForRowAt: indexPath)
    }
    
    // Conforming to TableViewDelegate protocol.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == parkingLocateTable {
            parkingLocateTableView(tableView as! ParkingLocateTableView, didSelectRowAt: indexPath)
        }
        else {
            suggestAddressTableView(tableView as! SuggestAddressTableView, didSelectRowAt: indexPath)
        }
    }
    
    
    private func goToStep(step: Int) {
        switch (step) {
        case 1:
            isSearching = false
            isSelecting = false
            
            firstStepView.isHidden = false;
            secondStepView.isHidden = true;
            
            secondStepView.frame.origin.x = 0;
            break;
        case 2:
            searchAddress.text = ""
            suggestAddressList.removeAll()
            suggestAddressTable.reloadData()
            
            parkingLocateList.removeAll()
            
            isSearching = false
            isSelecting = true
            
            firstStepView.isHidden = true;
            secondStepView.isHidden = false;
            break;
        default:
            break;
        }
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
    }
    
    private func suggestAddressTableView(_ tableView: SuggestAddressTableView, numberOfRowsInSection section: Int) -> Int {
        print("suggestAddressTableView numberOfRowsInSection")
        return isSearching ? suggestAddressList.count : 0
    }
    
    private func suggestAddressTableView(_ tableView: SuggestAddressTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("suggestAddressTableView cellForRowAt")
        let addressCell = suggestAddressTable.dequeueReusableCell(withIdentifier: "suggestAddressCell", for: indexPath)
        
        let address = suggestAddressList[indexPath.row]
        
        addressCell.textLabel?.text = address.title
        
        return addressCell
    }
    
    private func suggestAddressTableView(_ tableView: SuggestAddressTableView, didSelectRowAt indexPath: IndexPath) {
        print("suggestAddressTableView didSelectRowAt")
        let address = suggestAddressList[indexPath.row]
        
        guard let locValue: GeoCoordinates = address.place?.coordinates else { return }
        
        let addressLocate = GeoCoordinates(latitude: locValue.latitude, longitude: locValue.longitude)
        
        loadParkingLocateNear(addressTitle: address.title, geoCoordinates: addressLocate)
    }
    
    
    // ------ Second Step
    private func loadParkingLocateNear(addressTitle: String, geoCoordinates: GeoCoordinates) {
        goToStep(step: 2)
        print("focus on address selected")
        
        addressSelectedLabel.text = addressTitle
        
        let camera = mapView.camera
        camera.setTarget(geoCoordinates)
        camera.setZoomLevel(13)
        
        mapController.cleanDestineLocateMarker()
        mapController.setDestineLocateMarker(geoCoordinates: geoCoordinates)
        
        parkingLocateList.removeAll()
        
        // TODO: Obter estacionamentos do servidor
        for _ in 1...Int.random(in: 2...5) {
            let randomCoordenates = getRandomGeoCoordinatesInViewport()
            
            let parking = ParkingLocateModel("R$ 7,40", "7 Avaliações", mapController.createPoiMapMarker(geoCoordinates: randomCoordenates))
            
            parkingLocateList.append(parking)
        }
        parkingLocateTable.reloadData()
        
        mapController.drawMapMarkers(markerList: parkingLocateList.map { $0.Localization } )
    }
    
    private func parkingLocateTableView(_ tableView: ParkingLocateTableView, numberOfRowsInSection section: Int) -> Int {
        print("parkingLocateTableView numberOfRowsInSection")
        return parkingLocateList.count
    }
    
    private func parkingLocateTableView(_ tableView:ParkingLocateTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("parkingLocateTableView cellForRowAt")
        let parkingCell = parkingLocateTable.dequeueReusableCell(withIdentifier: "parkingLocateCell", for: indexPath) as! ParkingLocateTableViewCell
        
        let parking = parkingLocateList[indexPath.row]
        
        parkingCell.AddressNameLabel?.text = "test"
        parkingCell.AmmountLabel?.text = parking.Ammount
        parkingCell.RatesLabel?.text = parking.Rates
        
        return parkingCell
    }
    
    private func parkingLocateTableView(_ tableView: ParkingLocateTableView, didSelectRowAt indexPath: IndexPath) {
        print("parkingLocateTableView didSelectRowAt")
        let parking = parkingLocateList[indexPath.row]
        
        print("focus on parking selected")
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
