import UIKit

class PrimaryButtonStyle: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupDefaults()
    }
    
    func setupDefaults() {
        let main = UIColor.init(red: (142/255.0), green: (6/255.0), blue: (201/255.0), alpha: 1.0)
        
        self.layer.borderColor = main.cgColor
        self.backgroundColor = main
        self.tintColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        
        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
