import UIKit

public class UIViewLayoutComponent<T: UIView>: ViewLayoutComponent<T>, UIViewLayoutComponentType, ConstraintAndViewCollectionDelegate {
    var downcastedView: UIView { return view as UIView }
    var constraints = Set<LayoutConstraint>()
    private var _allSubviews = Set<UIView>()
    
    override init(view: T) {
        super.init(view: view)
        
        collectionDelegate = self
    }
    
    func activate(_ constraints: Set<LayoutConstraint>) {
        self.constraints.formUnion(constraints)
    }
    
    func addSubview(_ subview: UIView) {
        _allSubviews.insert(subview)
    }
    
    func allSubviews() -> Set<UIView> {
        return _allSubviews
    }
}
