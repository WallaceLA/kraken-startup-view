import UIKit
import heresdk
import Jelly

class HomeViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dealPopupSafeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dealPopupHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dealPopupVerticalConstraint: NSLayoutConstraint!

    @IBOutlet weak var dismissPopupButton: UIButton!
    
    @IBOutlet weak var searchAddress: UISearchBar!
    @IBOutlet weak var addressTable: UITableView!
    @IBOutlet weak var placesFoundedLabel: UILabel!
    
    @IBOutlet var mapView: MapViewLite!
    
    var navCustomAnimator: Jelly.Animator?
    var customNavViewController: CustomNavViewController?
    
    let addressListMock = ["Ezra Sloan", "Melie Edwards", "Melinda Taylor", "Hester Case"]
    
    let dealPopupMinHeight = CGFloat(0.2)
    let dealPopupMaxHeight = CGFloat(0.8)
    var isSearching = false
    var addressList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    
        searchAddress.delegate = self
        
        addressTable.delegate = self
        addressTable.dataSource = self
        
        onLoadCustomNavPresentation()
        loadDealPopup()
        mapView.mapScene.loadScene(mapStyle: .normalDay, callback: onLoadMap)
    }
    
    func onLoadCustomNavPresentation() {
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
    
    func loadDealPopup() {
        PrepareAddressListMock()
        dismissPopupButton.alpha = 0
        
        dealPopupSafeTopConstraint.constant = self.view.frame.height * dealPopupMaxHeight
        dealPopupHeightConstraint.constant = self.view.frame.height * dealPopupMaxHeight
        dealPopupVerticalConstraint.constant = (self.view.frame.height * (dealPopupMaxHeight - dealPopupMinHeight)) * -1
    }
    
    func openDealPopup() {
        dismissPopupButton.alpha = 0.1
        
        UIView.animate(withDuration: 0.5, animations: {
            self.dealPopupSafeTopConstraint.constant = self.view.frame.height * self.dealPopupMinHeight
            self.dealPopupVerticalConstraint.constant = 0
            self.placesFoundedLabel.isHidden = false
            self.addressTable.isHidden = false
        })
    }
    
    func closeDealPopup() {
        dismissPopupButton.alpha = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.dealPopupSafeTopConstraint.constant = self.view.frame.height * self.dealPopupMaxHeight
            self.dealPopupVerticalConstraint.constant = (self.view.frame.height * (self.dealPopupMaxHeight - self.dealPopupMinHeight)) * -1
            self.placesFoundedLabel.isHidden = true
            self.addressTable.isHidden = true
        })
    }
    
    func PrepareAddressListMock() {
        for address in addressListMock {
             addressList.append(address)
        }
    }
    
    @IBAction func dismissPopupClick(_ sender: Any) {
        closeDealPopup()
    }
    
    // funcoes da SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
            
        if isSearching {
            openDealPopup()
        } else {
            closeDealPopup()
        }
            
        addressTable.reloadData()
    }
    
    // funcoes da TableViewCell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? addressList.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addressCell = addressTable.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        
        let address = addressList[indexPath.row]
        
        addressCell.textLabel?.text = address
    
        return addressCell
    }
    
    // funcoes da classe
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         super.touchesBegan(touches, with: event)
         view.endEditing(true)
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
    
    @IBAction func openNavClick(_ sender: Any) {
        present(customNavViewController!, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
