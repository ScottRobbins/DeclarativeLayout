import UIKit

public class SubviewLayoutComponent<T: UIView>: ViewLayoutComponent<T> {
    
    public let superview: UIView
    
    init(view: T,
         superview: UIView)
    {
        self.superview = superview
        
        super.init(view: view)
    }

}
