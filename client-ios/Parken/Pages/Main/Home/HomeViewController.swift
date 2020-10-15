import UIKit
import CoreLocation
import CoreData
import Jelly
import heresdk
import Alamofire
import CoreLocation

class HomeViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    //var myIndex:Int=0
    
    @IBOutlet weak var dealPopup: UIView!
    @IBOutlet weak var dealPopupSafeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dealPopupHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dealPopupVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var togglePopupButton: UIButton!
    @IBOutlet weak var dismissPopupButton: UIButton!
    
    @IBOutlet var mapView: MapViewLite!
    
    // first step
    @IBOutlet weak var firstStepView: UIView!
    @IBOutlet weak var searchAddress: UISearchBar!
    
    @IBOutlet weak var searchResultView: UIView!
    @IBOutlet weak var suggestAddressTable: UITableView!
    
    @IBOutlet weak var favoriteView: UIView!
    @IBOutlet weak var favoriteAddressTable: UITableView!
    
    // second step
    @IBOutlet weak var secondStepView: UIView!
    @IBOutlet weak var parkingLocateTable: UITableView!
    @IBOutlet weak var addressSelectedLabel: UILabel!
    @IBOutlet weak var addressSelectedStartButton: UIButton!
    
    // third setp
    @IBOutlet weak var thirdStepView: UIView!
    @IBOutlet weak var addressParkChoosedLabel: UILabel!
    @IBOutlet weak var distanceParkChoosedLabel: UILabel!
    @IBOutlet weak var ammountParkChoosedLabel: UILabel!
    @IBOutlet weak var ratesParkChoosedLabel: UILabel!
    @IBOutlet weak var descriptionParkChoosedLabal: UITextView!
    
    // navbar definitions
    private var navCustomAnimator: Jelly.Animator?
    private var customNavViewController: CustomNavViewController?
    
    // modal definitions
    private let dealPopupMinHeight = CGFloat(0.25)
    private let dealPopupMaxHeight = CGFloat(0.75)
    private var isPopupOpen = false
    private let maximizeButtonIconName = "chevron.compact"
    
    // map definitions
    private var mapController: HereSdkController!
    private var locationManager = CLLocationManager()
    
    // first step
    private var isSearching = false
    private var userLocateMapMarker: MapMarkerLite?
    private var suggestAddressList: [Suggestion] = []
    private var favoriteAddressList: [String] = []
    
    // second step
    private var destineLocateMapMarker: MapMarkerLite?
    private var parkingLocateList: [ParkingLocateModel] = []
    private var vagas: [NSManagedObject] = []
    private let favoriteSelectedStartIcon = "star"
    
    // third step
    private var parkChoosed: ParkingLocateModel?
    
    var locLat:Double=0.0
    var locLon:Double=0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchAddress.delegate = self
        
        suggestAddressTable.delegate = self
        suggestAddressTable.dataSource = self
        
        favoriteAddressTable.delegate = self
        favoriteAddressTable.dataSource = self
        
        parkingLocateTable.delegate = self
        parkingLocateTable.dataSource = self
        
        locationManager.delegate = self
        
        loadNavPresentation()
        loadDealModal()
        
        loadFavoriteAddress()
        
        goToStep(step: 1)
        
        requestGPSAuthorization()
        mapController = HereSdkController(mapView: mapView!)
        mapView.mapScene.loadScene(mapStyle: .normalDay, callback: onLoadMap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    // NavBar Definitions
    @IBAction func openNavClick(_ sender: Any) {
        present(customNavViewController!, animated: true, completion: nil)
    }
    
    @IBAction func togglePopupClick(_ sender: Any) {
        if isPopupOpen {
            minimizeDealModal()
        } else {
            maximizeDealModal()
        }
    }
    
    @IBAction func dismissPopupClick(_ sender: Any) {
        minimizeDealModal()
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
        isPopupOpen = true
        dismissPopupButton.alpha = 0.1
        togglePopupButton.setImage(UIImage(systemName: "\(maximizeButtonIconName).down"), for: .normal)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.dealPopupSafeTopConstraint.constant = self.view.frame.height * self.dealPopupMinHeight
            self.dealPopupVerticalConstraint.constant = 0
            
            if self.isSearching {
                self.searchResultView.isHidden = false
                self.favoriteView.isHidden = true
            } else {
                self.searchResultView.isHidden = true
                self.favoriteView.isHidden = false
            }
        })
    }
    
    private func minimizeDealModal() {
        isPopupOpen = false
        dismissPopupButton.alpha = 0
        togglePopupButton.setImage(UIImage(systemName: "\(maximizeButtonIconName).up"), for: .normal)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.dealPopupSafeTopConstraint.constant = self.view.frame.height * self.dealPopupMaxHeight
            self.dealPopupVerticalConstraint.constant = (self.view.frame.height * (self.dealPopupMaxHeight - self.dealPopupMinHeight)) * -1
            
            self.searchResultView.isHidden = true
            self.favoriteView.isHidden = true
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
    
    private func loadFavoriteAddress() {
        favoriteAddressList = [
            "São Paulo, SP, Brasil",
            "Guarulhos, SP, Brasil"
        ]
        
        favoriteAddressTable.reloadData()
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
            return parkingLocateTableView(tableView as! ParkingLocateTableView, numberOfRowsInSection: section)
        }
        else if tableView == favoriteAddressTable {
            return favoriteAddressTableView(tableView as! FavoriteAddressTableView, numberOfRowsInSection: section)
        }
        
        return suggestAddressTableView(tableView as! SuggestAddressTableView, numberOfRowsInSection: section)
    }
    
    // Conforming to TableViewDelegate protocol.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == parkingLocateTable {
            return parkingLocateTableView(tableView as! ParkingLocateTableView, cellForRowAt: indexPath)
        }
        else if tableView == favoriteAddressTable {
            return favoriteAddressTableView(tableView as! FavoriteAddressTableView, cellForRowAt: indexPath)
        }
        
        return suggestAddressTableView(tableView as! SuggestAddressTableView, cellForRowAt: indexPath)
    }
    
    // Conforming to TableViewDelegate protocol.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == parkingLocateTable {
            parkingLocateTableView(tableView as! ParkingLocateTableView, didSelectRowAt: indexPath)
        }
        else if tableView == favoriteAddressTable {
            favoriteAddressTableView(tableView as! FavoriteAddressTableView, didSelectRowAt: indexPath)
        }
        else {
            suggestAddressTableView(tableView as! SuggestAddressTableView, didSelectRowAt: indexPath)
        }
    }
    
    
    private func goToStep(step: Int) {
        switch (step) {
        case 1:
            isSearching = false
            
            firstStepView.isHidden = false
            secondStepView.isHidden = true
            thirdStepView.isHidden = true
            
            firstStepView.frame.origin.x = 0;
            secondStepView.frame.origin.x = 0;
            thirdStepView.frame.origin.x = 0;
            
            favoriteView.frame.origin.x = 0;
            searchResultView.frame.origin.x = 0;
            
            minimizeDealModal()
            
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
            
            firstStepView.isHidden = true
            secondStepView.isHidden = false
            thirdStepView.isHidden = true
            
            break;
        case 3:
            firstStepView.isHidden = true
            secondStepView.isHidden = true
            thirdStepView.isHidden = false
            
            break;
        default:
            break;
        }
    }
    
    // ------ First Step
    // Conforming to SearchBarDelegate protocol.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchAddress(addressName: searchText)
    }
    
    private func searchAddress(addressName: String) {
        isSearching = !addressName.isEmpty
        
        if isSearching {
            mapController.getAutoSuggest(
                textQuery: addressName,
                action: { (error: SearchError?, items: [Suggestion]?) -> () in
                    if let searchError = error {
                        print("AutoSuggest Error: \(searchError)")
                        return
                    }
                    
                    // If error is nil, it is guaranteed that the items will not be nil.
                    print("AutoSuggest: Encontrado \(items!.count) resultado(s).")
                    
                    self.suggestAddressList = items!
                    self.suggestAddressTable.reloadData()
            })
            maximizeDealModal()
        } else {
            minimizeDealModal()
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
    
    private func favoriteAddressTableView(_ tableView: FavoriteAddressTableView, numberOfRowsInSection section: Int) -> Int {
        print("favoriteAddressTableView numberOfRowsInSection")
        return favoriteAddressList.count
    }
    
    private func favoriteAddressTableView(_ tableView: FavoriteAddressTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("favoriteAddressTableView cellForRowAt")
        let addressCell = favoriteAddressTable.dequeueReusableCell(withIdentifier: "favoriteAddressCell", for: indexPath) as! FavoriteAddressTableViewCell
        
        let address = favoriteAddressList[indexPath.row]
        
        addressCell.addressNameLabel?.text = address
        
        return addressCell
    }
    
    private func favoriteAddressTableView(_ tableView: FavoriteAddressTableView, didSelectRowAt indexPath: IndexPath) {
        print("favoriteAddressTableView didSelectRowAt")
        let address = favoriteAddressList[indexPath.row]
        
        searchAddress.text = address
        searchAddress(addressName: address)
    }
    
    private func setUserLocateMarker(geoCoordinates: GeoCoordinates, centralize: Bool) {       
        userLocateMapMarker = mapController.addMarker(
            mapMarker: self.mapController.createCircleMarker(geoCoordinates: geoCoordinates, imageName: "location.north.fill", isDefaultImage: true),
            geoCoordinates: geoCoordinates,
            lastMarker: userLocateMapMarker)
        
        if centralize {
            mapController.centralize(geoCoordinates: geoCoordinates)
        }
    }
    
    
    // ------ Second Step
    private func loadParkingLocateNear(addressTitle: String, geoCoordinates: GeoCoordinates) {
        goToStep(step: 2)
        
        if let mapMarker = destineLocateMapMarker {
            mapController.cleanMarker(mapMarker: mapMarker)
            destineLocateMapMarker = nil
        }
        
        parkingLocateList.removeAll()
        
        print("focus on address selected")
        
        addressSelectedLabel.text = addressTitle
        setFavoriteSelectedIcon(addressName: addressTitle, changeIcon: false)
        
        setDestineLocateMarker(geoCoordinates: geoCoordinates)
        
        // TODO: Obter estacionamentos do servidor
        let parameters: Parameters = [
            "latitude": "\(geoCoordinates.latitude)",
            "longitude": "\(geoCoordinates.longitude)",
            "maxDistance": "1000.0",
            "maxResult": "1000"
        ]
        
        AF.request("\(ParkenConstants.apiEndpoint)/Parking/GetParkingListByPerimeter",
            method: .get,
            parameters: parameters,
            encoding: JSONEncoding.default).responseJSON { response in
                print("request API")
                
                //if let json = response.result.value {
                //    print("JSON: \(json)") // serialized json response
                //}
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
        }
        /*
        for _ in 1...Int.random(in: 2...3) {
            let randomCoordinates = getRandomGeoCoordinatesInViewport()
            
            addParkingFound(geoCoordinates: randomCoordinates)
        }*/
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Vaga")

        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "id", ascending: true)]

        do {
            vagas = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Não foi possível buscar os dados \(error), \(error.userInfo)")
        }
 
        for vaga in vagas {
            let latitude = vaga.value(forKeyPath: "latitude") as! Double
            let longitude = vaga.value(forKeyPath: "longitude") as! Double
            let rua = vaga.value(forKeyPath: "rua") as? String ?? "Rua"
            let numero = vaga.value(forKeyPath: "numero") as? String ?? "Numero"
            let bairro = vaga.value(forKeyPath: "bairro") as? String ?? "Bairro"
            let valor = vaga.value(forKeyPath: "valor") as? Double ?? 12.22
            let endereco = "\(rua), \(numero), \(bairro)"
            let titulo = vaga.value(forKeyPath: "titulo") as? String ?? "Titulo"
            let descricao = vaga.value(forKeyPath: "descricao") as? String ?? "Descricao"
            let cep = vaga.value(forKeyPath: "cep") as? String ?? "CEP"
            
            let addressLocate = GeoCoordinates(latitude: latitude, longitude: longitude)
            
            let idVaga:String = "\(rua)-\(numero)-\(cep)-\(titulo)"
            
            //let coordinate0 = CLLocation(latitude: -23.56824, longitude: -46.56816)
            let coordinate0 = CLLocation(latitude: locLat, longitude: locLon)
            let coordinate1 = CLLocation(latitude: latitude, longitude: longitude)

            let distanciaTest:Int = Int(coordinate0.distance(from: coordinate1))
            
            addParkingFound(geoCoordinates: addressLocate, endereco: endereco, valor: valor, titulo: titulo, descricao: descricao, idVaga: idVaga, distanciaTest: distanciaTest)
            
            
        }
        //self.parkingLocateTable.reloadData()
    }

    /*MARK:---------------------------------LISTAGEM DE VAGAS - REQUISICAO---------------------------------*/
                    
     
    private func addParkingFound(geoCoordinates: GeoCoordinates, endereco: String, valor: Double, titulo: String, descricao: String, idVaga: String, distanciaTest: Int) {
        mapController.getAddressByCoordinates(
            geoCoordinates: geoCoordinates,
            action: { (error: SearchError?, item: [Place]?) -> () in
                if let searchError = error {
                    print("AddressByCoordinates Error: \(searchError)")
                    return
                }
                
                if (distanciaTest <= 1000) {
                
                // If error is nil, it is guaranteed that the place list will not be empty.
                print("AddressByCoordinates: Encontrado \(item!.count) resultado(s).")

                //let addressText = item!.first!.title
                //let distance = item!.first!.distanceInMeters!
                let distance = distanciaTest

                print("\n\n\n\n Distancia - \(type(of: distance)) \n\n\n\n")
                
                let parkingModel = ParkingLocateModel(
                    endereco,
                    //"\(distance * 10) M",
                    "\(distance) M",
                    "R$ \(valor)",
                    "",
                    self.mapController.createPointMarker(geoCoordinates: geoCoordinates, imageName: "parking_icon"),
                    descricao,
                    titulo,
                    idVaga)
                
                print("\n \n \n Parking model: \(parkingModel.Id) \n \n \n ")
                
                self.parkingLocateList.append(parkingModel)
                //self.parkingLocateTable.reloadRows(at: , with: UITableView.RowAnimation)
              
                self.mapController.addMarkerList(markerList: self.parkingLocateList.map { $0.Localization } )
                    
                }
                
                self.parkingLocateTable.reloadData()
                })
        
            
    }
    
    @IBAction func toggleFavoriteAddressSelectedClick(_ sender: Any) {
        let addressName = addressSelectedLabel.text!
        setFavoriteSelectedIcon(addressName: addressName, changeIcon: true)
    }
    
    private func setFavoriteSelectedIcon(addressName: String, changeIcon: Bool) {
        var startIcon: UIImage?
        
        if favoriteAddressList.contains(addressName) {
            if changeIcon {
                startIcon = UIImage(systemName: favoriteSelectedStartIcon)
                
                favoriteAddressList = favoriteAddressList.filter(){$0 != addressName}
                favoriteAddressTable.reloadData()
            } else {
                startIcon = UIImage(systemName: "\(favoriteSelectedStartIcon).fill")
            }
        } else {
            if changeIcon {
                startIcon = UIImage(systemName: "\(favoriteSelectedStartIcon).fill")
                
                favoriteAddressList.append(addressName)
                favoriteAddressTable.reloadData()
            } else {
                startIcon = UIImage(systemName: favoriteSelectedStartIcon)
            }
        }
        
        addressSelectedStartButton.setImage(startIcon!, for: .normal)
    }
    
    private func parkingLocateTableView(_ tableView: ParkingLocateTableView, numberOfRowsInSection section: Int) -> Int {
        print("parkingLocateTableView numberOfRowsInSection")
        return parkingLocateList.count
    }
    
    private func parkingLocateTableView(_ tableView:ParkingLocateTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("parkingLocateTableView cellForRowAt")
        let parkingCell = parkingLocateTable.dequeueReusableCell(withIdentifier: "parkingLocateCell", for: indexPath) as! ParkingLocateTableViewCell
        
        let parking = parkingLocateList[indexPath.row]
        
        parkingCell.AddressNameLabel?.text = parking.Address
        parkingCell.DistanceLabel?.text = parking.Distance
        parkingCell.AmmountLabel?.text = parking.Ammount
        parkingCell.RatesLabel?.text = parking.Rates
    
        //myIndex = indexPath.row
        
        return parkingCell
    }
    
    private func parkingLocateTableView(_ tableView: ParkingLocateTableView, didSelectRowAt indexPath: IndexPath) {
        print("parkingLocateTableView didSelectRowAt")
        let parking = parkingLocateList[indexPath.row]
        
        print("focus on parking selected")
        
        loadParkChoosed(park: parking)
    }
    
    private func setDestineLocateMarker(geoCoordinates: GeoCoordinates) {
        destineLocateMapMarker = mapController.addMarker(
            mapMarker: self.mapController.createPointMarker(geoCoordinates: geoCoordinates, imageName: "poi"),
            geoCoordinates: geoCoordinates,
            lastMarker: destineLocateMapMarker)
        
        locLat = geoCoordinates.latitude
        locLon = geoCoordinates.longitude
        
        mapController.centralize(geoCoordinates: geoCoordinates)
    }
    
    @IBAction func backToFirstStepClick(_ sender: Any) {
        goToStep(step: 1)
    }
    
    
    // ------ Third Step
    private func loadParkChoosed(park: ParkingLocateModel) {
        goToStep(step: 3)
        
        parkChoosed = park
        
        addressParkChoosedLabel?.text = park.Address
        distanceParkChoosedLabel?.text = park.Distance
        ammountParkChoosedLabel?.text = park.Ammount
        ratesParkChoosedLabel?.text = park.Rates
        descriptionParkChoosedLabal?.text = park.Description
    }
    
    @IBAction func backToSecondStepClick(_ sender: Any) {
        goToStep(step: 2)
    }
    
    @IBAction func requestParkClick(_ sender: Any) {
        // TODO: call backend
        print("Vaga requisitada")
        
        goToStep(step: 1)
    }
    
    
    private func showDialog(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
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
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "requestSegue" {
            let bugado = segue.destination as! RequestViewController
            let vagaSelecionada = parkingLocateList[parkingLocateTable.indexPathForSelectedRow!.item]
            let id = vagaSelecionada.Id
            
            var vagaFinal:NSManagedObject?
            
            for vaga in vagas{
                
                let idVaga = vaga.value(forKeyPath: "id") as? String ??  "Titulo"
                vagaFinal = vaga
                if idVaga == id {
                    break
                }
                
            }
            
            //let vagaSelecionada:NSManagedObject = vagas[myIndex]
            bugado.vaga = vagaFinal
        }
        
     }
     
    
}
