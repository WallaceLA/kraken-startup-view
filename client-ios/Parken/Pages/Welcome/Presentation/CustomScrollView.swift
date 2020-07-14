import UIKit

class CustomScrollView: UIScrollView {

    var touchesDisabled = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchesDisabled {
            // here parse the touches, if they go in the horizontal direction, allow scrolling
            // set tolerance for vertical movement
            let tolerance: CGFloat = 5.0
            let variance = touches.reduce(0, { Yvariation, touch in
                Yvariation + abs(touch.location(in: view).y - touch.previousLocation(in: view).y)
            })
            if variance <= tolerance * CGFloat(touches.count) {
                let Xtravelled = touches.reduce(0, { Xstep, touch in
                    Xstep + (touch.location(in: view).x - touch.previousLocation(in: view).x)
                })
                // scroll horizontally by the x component of hand gesture
                var newFrame: CGRect = scrollView.frame
                newFrame.origin.x += Xtravelled
                self.scrollRectToVisible(frame, animated: true)
            }
        }

        else {
            super.touchesBegan(touches: touches, withEvent: event)
        }
    }
}
