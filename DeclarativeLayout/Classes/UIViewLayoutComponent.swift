import UIKit

public class UIViewLayoutComponent<T: UIView>: ViewLayoutComponent<T>, UIViewLayoutComponentType, ConstraintAndViewCollectionDelegate {
    var downcastedView: UIView { return view as UIView }
    var constraints = Set<LayoutConstraint>()
    
    override init(view: T) {
        super.init(view: view)
        
        collectionDelegate = self
    }
    
    func activate(_ constraints: Set<LayoutConstraint>) {
        self.constraints.formUnion(constraints)
    }
}
