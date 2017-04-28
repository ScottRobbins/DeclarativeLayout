import UIKit

public extension UIView {
    
    public func updateLayoutTo(_ layoutClosure: (UIViewLayout) -> ()) {
        let layout = UIViewLayout(view: self)
        layoutClosure(layout)
        
        layout.executeAddSubviews()
        layout.executeActivateConstraints()
    }
}
