import UIKit

public class UIStackViewSubviewLayout: SubviewLayout<UIStackView> {
    
    private var arrangedSubviewsToAdd = [UIView]()
    
    public func addArranged(_ subview: UIView,
                            layoutClosure: ((UIViewSubviewLayout) -> Void)?)
    {
        arrangedSubviewsToAdd.append(subview)
        
        add(subview, layoutClosure: layoutClosure)
    }
    
    public func addArrangedStack(_ subview: UIStackView,
                                 layoutClosure: ((UIStackViewSubviewLayout) -> Void)?)
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
