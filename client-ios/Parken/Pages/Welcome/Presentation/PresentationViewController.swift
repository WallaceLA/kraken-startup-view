import UIKit

class PresentationViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var imageList: [(String, String, String, UIColor)] = [
        ("icon-many-places", "Diversas possibilidades", "Muitas opcoes disponiveis para estacionar, com muita praticidade e conforto.", UIColor(red: 1, green: 0.556, blue: 0.232, alpha: 1)),
        ("icon-connect-people", "Escolha a sua vaga", "Encontre a vaga que melhor te atende, proxima de seu local de destino.", UIColor(red: 1, green: 0.556, blue: 0.232, alpha: 1)),
        ("icon-payment-online", "Seguranca para pagar", "Garanta o melhor valor pagando direto no app usando nossos planos mensais.", UIColor(red: 1, green: 0.556, blue: 0.232, alpha: 1)),
    ]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        pageControl.numberOfPages = imageList.count
        
        for index in (0..<imageList.count).reversed() {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let thumbnailCustom = ThumbnailCustom().loadNib() as! ThumbnailCustom
            thumbnailCustom.setInformation(imageName: imageList[index].0, title: imageList[index].1, message: imageList[index].2, color: imageList[index].3)
            
            thumbnailCustom.frame = frame
            scrollView.addSubview(thumbnailCustom)
        }
        
        scrollView.contentSize = CGSize(
            width: (scrollView.frame.size.width * CGFloat(imageList.count)),
            height: scrollView.frame.size.height)
        
        scrollView.delegate = self
    }
    
    func scrollToPage(pageIndex: Int) {
        pageControl.currentPage = pageIndex
        
        frame.origin.x = frame.size.width * CGFloat(pageIndex) - 36
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = 0.0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x/view.frame.width)
        scrollToPage(pageIndex: Int(pageNumber))
    }
    
    @IBAction func skipClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
