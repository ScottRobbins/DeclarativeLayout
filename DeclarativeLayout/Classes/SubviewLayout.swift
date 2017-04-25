import UIKit

public class SubviewLayout<T: UIView>: ViewLayout<T> {
    
    public let superview: UIView
    
    init(view: T,
         superview: UIView,
         active: Bool)
    {
        self.superview = superview
        
        super.init(view: view, active: active)
    }
    
    public func `if`(_ condition: Bool) -> UIViewSubviewLayout {
        return UIViewSubviewLayout(view: view, superview: superview, active: condition)
    }
}
