import UIKit

public class UIStackViewSubviewLayoutComponent: SubviewLayoutComponent<UIStackView> {
    
    private(set) var arrangedSubviews = [UIView]()
    
    public func addArranged(_ subview: UIView,
                            layoutClosure: ((UIViewSubviewLayoutComponent) -> Void)?)
    {
        arrangedSubviews.append(subview)
        
        add(subview, layoutClosure: layoutClosure)
    }
    
    public func addArrangedStack(_ subview: UIStackView,
                                 layoutClosure: ((UIStackViewSubviewLayoutComponent) -> Void)?)
    {
        arrangedSubviews.append(subview)

        addStack(subview, layoutClosure: layoutClosure)
    }
}
