import UIKit

class DealActionsViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchAddress: UISearchBar!
    @IBOutlet weak var addressTable: UITableView!
    
    var interactionActionMaxime: (() -> ())?
    var interactionActionMinimize: (() -> ())?
    
    let addressListMock = ["Ezra Sloan", "Melie Edwards", "Melinda Taylor", "Hester Case"]
    
    var isSearching = false
    var addressList: [String] = []
    
     override func viewDidLoad() {
         super.viewDidLoad()
         modalPresentationCapturesStatusBarAppearance = true
        
         searchAddress.delegate = self
        
         addressTable.delegate = self
         addressTable.dataSource = self
        
         PrepareAddressListMock()
     }

    func PrepareAddressListMock() {
        for address in addressListMock {
             addressList.append(address)
        }
    }
    
    // funcoes da SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            isSearching = !searchText.isEmpty
            
        if isSearching, let interactionAction = interactionActionMaxime {
            interactionAction()
            addressTable.isHidden = false
        } else if let interactionAction = interactionActionMinimize {
            interactionAction()
            addressTable.isHidden = true
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
