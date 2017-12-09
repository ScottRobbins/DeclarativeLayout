import UIKit

public class SubviewLayoutComponent<T: UIView, R: UIView>: ViewLayoutComponent<T> {
    
    public let superview: R
    
    init(view: T,
         superview: R)
    {
        self.superview = superview
        
        super.init(view: view)
    }

}
