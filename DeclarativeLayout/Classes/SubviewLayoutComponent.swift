import UIKit

public class SubviewLayoutComponent<T: UIView, R: UIView>: ViewLayoutComponent<T> {
    
    /**
     The component's view's superview
     */
    public unowned let superview: R
    
    init(view: T,
         superview: R,
         cachedLayoutObjectStore: CachedLayoutObjectStore)
    {
        self.superview = superview
        
        super.init(view: view, cachedLayoutObjectStore: cachedLayoutObjectStore)
    }

}
