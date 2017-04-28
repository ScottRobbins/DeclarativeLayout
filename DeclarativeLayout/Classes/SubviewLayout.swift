import UIKit

public class SubviewLayout<T: UIView>: ViewLayout<T> {
    
    public let superview: UIView
    
    init(view: T,
         superview: UIView)
    {
        self.superview = superview
        
        super.init(view: view)
    }

}
