import UIKit

public class UIStackViewSubviewLayoutComponent<T: UIStackView, R: UIView>: SubviewLayoutComponent<T, R>, UIStackViewLayoutComponentType {
    
    var downcastedView: UIStackView { return view as UIStackView }
    private(set) var arrangedSubviews = [UIView]()
    
    public func addArrangedView<Q>(_ subview: Q,
                            layoutClosure: ((UIViewSubviewLayoutComponent<Q, T>) -> Void)?)
    {
        arrangedSubviews.append(subview)
        
        addView(subview, layoutClosure: layoutClosure)
    }
    
    public func addArrangedStackView<Q>(_ subview: Q,
                                 layoutClosure: ((UIStackViewSubviewLayoutComponent<Q, T>) -> Void)?)
    {
        arrangedSubviews.append(subview)

        addStackView(subview, layoutClosure: layoutClosure)
    }
}
