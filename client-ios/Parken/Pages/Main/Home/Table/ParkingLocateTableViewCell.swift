import UIKit

class ParkingLocateTableViewCell: UITableViewCell {

    @IBOutlet weak var DistanceLabel: UILabel!
    @IBOutlet weak var AddressNameLabel: UILabel!
    @IBOutlet weak var AmmountLabel: UILabel!
    @IBOutlet weak var RatesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
