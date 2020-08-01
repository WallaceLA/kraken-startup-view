import UIKit

class ThumbnailCustom: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    private var imageName = ""
    private var title = ""
    private var message = ""
    private var color: UIColor?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setInformation(imageName: String, title: String, message: String, color: UIColor) {
        self.imageName = imageName
        self.title = title
        self.message = message
        self.color = color
    }
    
    func loadNib() -> UIView {        
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    override func didMoveToSuperview() {
        imageView.image = UIImage(named: imageName)
        
        titleLabel.text = title
        //titleLabel.textColor = color
        
        textLabel.text = message
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
