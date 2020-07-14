import UIKit

class ThumbnailCustom: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!

    var _imageName = ""
    var _title = ""
    var _message = ""
    var _color: UIColor?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setInformation(imageName: String, title: String, message: String, color: UIColor) {
        _imageName = imageName
        _title = title
        _message = message
        _color = color
    }

    func loadNib() -> UIView {        
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    override func didMoveToSuperview() {
        imageView.image = UIImage(named: _imageName)
        
        titleLabel.text = _title
        //titleLabel.textColor = _color
        
        textLabel.text = _message
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
