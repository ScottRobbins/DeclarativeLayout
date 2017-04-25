import UIKit

public extension UIView {
    
    public func updateLayoutTo(_ layoutClosure: (ViewLayout<UIView>) -> ()) {
        let layout = ViewLayout(view: self, active: true)
        layoutClosure(layout)
        
        layout.executeAddSubviews()
        layout.executeActivateConstraints()
    }
}
