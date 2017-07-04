import UIKit

public class UIStackViewSubviewLayoutComponent: SubviewLayoutComponent<UIStackView> {
    
    private var arrangedSubviewsToAdd = [UIView]()
    
    public func addArranged(_ subview: UIView,
                            layoutClosure: ((UIViewSubviewLayoutComponent) -> Void)?)
    {
        arrangedSubviewsToAdd.append(subview)
        
        add(subview, layoutClosure: layoutClosure)
    }
    
    public func addArrangedStack(_ subview: UIStackView,
                                 layoutClosure: ((UIStackViewSubviewLayoutComponent) -> Void)?)
    {
        arrangedSubviewsToAdd.append(subview)

        addStack(subview, layoutClosure: layoutClosure)
    }
    
    override func executeAddSubviews() {
        
        super.executeAddSubviews()
        
        for (i, subview) in arrangedSubviewsToAdd.enumerated() {
            view.insertArrangedSubview(subview, at: i)
        }
    }
    
}
