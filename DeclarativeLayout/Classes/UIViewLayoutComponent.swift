import UIKit

public class UIViewLayoutComponent<T: UIView>: ViewLayoutComponent<T>, UIViewLayoutComponentType, ActivateConstraintsDelegate {
    var downcastedView: UIView { return view as UIView }
    var constraints = Set<LayoutConstraint>()
    
    override init(view: T) {
        super.init(view: view)
        
        activateConstraintsDelegate = self
    }
    
    func activate(_ constraints: Set<LayoutConstraint>) {
        self.constraints.formUnion(constraints)
    }
}
