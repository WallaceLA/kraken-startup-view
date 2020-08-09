import UIKit
import heresdk
import Jelly
import CoreLocation

class HomeViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var dealPopup: UIView!
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
    @IBOutlet weak var goFirstStepButton: UIButton!
    
    // third setp
    @IBOutlet weak var addressParkChoosedLabel: UILabel!
    @IBOutlet weak var favoriteParkChoosedButton: UIButton!
    @IBOutlet weak var distanceParkChoosedLabel: UILabel!
    
    
    
    // navbar definitions
    private var navCustomAnimator: Jelly.Animator?
    private var customNavViewController: CustomNavViewController?
    
    // modal definitions
    private let dealPopupMinHeight = CGFloat(0.25)
    private let dealPopupMaxHeight = CGFloat(0.75)
    
    // map definitions
    private var mapController: HereSdkController!
    private var locationManager = CLLocationManager()
    
    
    // first step
    private var isSearching = false
    private var userLocateMapMarker: MapMarkerLite?
    private var suggestAddressList: [Suggestion] = []
    
    
    // second step
    private var destineLocateMapMarker: MapMarkerLite?
    private var parkingLocateList: [ParkingLocateModel] = []
    
    
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
        
        goToStep(step: 1)
        
        requestGPSAuthorization()
        mapController = HereSdkController(mapView: mapView!)
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
        dealPopup.layer.cornerRadius = 25
        dealPopup.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        dealPopup.layer.masksToBounds = true;
        
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
            
            print("user locate initial")
            setUserLocateMarker(geoCoordinates: userLocate, centralize: true)
        }
    }
    
    @IBAction func centralizeUserMap(_ sender: Any) {
        guard let userLocate: GeoCoordinates = userLocateMapMarker?.coordinates else { return }
        
        mapController.centralize(geoCoordinates: userLocate)
    }
    
    // Conforming to CLLocationManagerDelegate protocol.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        
        guard let locValue: CLLocationCoordinate2D = location?.coordinate else { return }
        
        let userLocate = GeoCoordinates(latitude: locValue.latitude, longitude: locValue.longitude)
        
        print("user locate updating")
        setUserLocateMarker(geoCoordinates: userLocate, centralize: false)
    }
    
    // Conforming to CLLocationManagerDelegate protocol.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Errors: " + error.localizedDescription)
    }
    
    
    private func getRandomGeoCoordinatesInViewport() -> GeoCoordinates {
        let geoBox = mapController.getViewGeoBox()
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
            
            firstStepView.isHidden = false;
            secondStepView.isHidden = true;
            
            secondStepView.frame.origin.x = 0;
            
            MinimizeDealModal()
            
            if let mapController = mapController {
                mapController.clearMarkerList(markerList: parkingLocateList.map { $0.Localization } )
                parkingLocateList.removeAll()
            }
            
            if let destineMarker = destineLocateMapMarker {
                mapController.cleanMarker(mapMarker: destineMarker)
                destineLocateMapMarker = nil
            }
            
            break;
        case 2:
            searchAddress.text = ""
            isSearching = false
            
            suggestAddressList.removeAll()
            suggestAddressTable.reloadData()
            
            firstStepView.isHidden = true;
            secondStepView.isHidden = false;
            
            if let mapMarker = destineLocateMapMarker {
                mapController.cleanMarker(mapMarker: mapMarker)
                destineLocateMapMarker = nil
            }
            
            parkingLocateList.removeAll()
            
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
            mapController.getSuggest(
                textQuery: searchText,
                action: { (error: SearchError?, items: [Suggestion]?) -> () in
                    if let searchError = error {
                        print("Autosuggest Error: \(searchError)")
                        return
                    }
                    
                    // If error is nil, it is guaranteed that the items will not be nil.
                    print("Autosuggest: Found \(items!.count) result(s).")
                    
                    self.suggestAddressList = items!
                    self.suggestAddressTable.reloadData()
            })
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
    
    private func setUserLocateMarker(geoCoordinates: GeoCoordinates, centralize: Bool) {
        let imageName = "green_dot"
        
        userLocateMapMarker = mapController.addCircleMarker(imageName: imageName, geoCoordinates: geoCoordinates, lastMarker: userLocateMapMarker)
        
        if centralize {
            mapController.centralize(geoCoordinates: geoCoordinates)
        }
    }
    
    
    // ------ Second Step
    private func loadParkingLocateNear(addressTitle: String, geoCoordinates: GeoCoordinates) {
        goToStep(step: 2)
        print("focus on address selected")
        
        addressSelectedLabel.text = addressTitle
        
        setDestineLocateMarker(geoCoordinates: geoCoordinates)
        
        // TODO: Obter estacionamentos do servidor
        for _ in 1...Int.random(in: 2...5) {
            let randomCoordenates = getRandomGeoCoordinatesInViewport()
            
            let parking = ParkingLocateModel("R$ 7,40", "7 Avaliações", mapController.createPointMarker(geoCoordinates: randomCoordenates))
            
            parkingLocateList.append(parking)
        }
        parkingLocateTable.reloadData()
        
        mapController.addMarkerList(markerList: parkingLocateList.map { $0.Localization } )
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
    
    private func setDestineLocateMarker(geoCoordinates: GeoCoordinates) {
        let imageName = "red_dot"
        
        destineLocateMapMarker = mapController.addCircleMarker(imageName: imageName, geoCoordinates: geoCoordinates, lastMarker: destineLocateMapMarker)
        
        mapController.centralize(geoCoordinates: geoCoordinates)
    }
    
    @IBAction func backToFirstStepClick(_ sender: Any) {
        goToStep(step: 1)
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
