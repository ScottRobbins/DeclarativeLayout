import UIKit

public class UIStackViewSubviewLayoutComponent: SubviewLayoutComponent<UIStackView> {
    
    private(set) var arrangedSubviews = [UIView]()
    
    public func addArrangedView(_ subview: UIView,
                            layoutClosure: ((UIViewSubviewLayoutComponent) -> Void)?)
    {
        arrangedSubviews.append(subview)
        
        addView(subview, layoutClosure: layoutClosure)
    }
    
    public func addArrangedStackView(_ subview: UIStackView,
                                 layoutClosure: ((UIStackViewSubviewLayoutComponent) -> Void)?)
    {
        arrangedSubviews.append(subview)

        addStackView(subview, layoutClosure: layoutClosure)
    }
}
