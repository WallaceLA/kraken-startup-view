import UIKit
import Foundation

class PresentationModel: NSObject {
    
    var scrollView: UIScrollView
    var pageControl: UIPageControl
    
    init(scrollView: UIScrollView, pageControl: UIPageControl) {
        self.scrollView = scrollView
        self.pageControl = pageControl
    }
    
}
