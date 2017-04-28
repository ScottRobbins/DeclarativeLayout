import UIKit

public class UIStackViewSubviewLayout: SubviewLayout<UIStackView> {
    
    public var axis: UILayoutConstraintAxis
    public var distribution: UIStackViewDistribution
    public var alignment: UIStackViewAlignment
    public var spacing: CGFloat
    public var isBaselineRelativeArrangement: Bool
    public var isLayoutMarginsRelativeArrangement: Bool
    
    private var arrangedSubviewsToAdd = [UIView]()
    
    override init(view: UIStackView,
                  superview: UIView)
    {
        axis = view.axis
        distribution = view.distribution
        alignment = view.alignment
        spacing = view.spacing
        isBaselineRelativeArrangement = view.isBaselineRelativeArrangement
        isLayoutMarginsRelativeArrangement = view.isLayoutMarginsRelativeArrangement
        
        super.init(view: view,
                   superview: superview)
    }
    
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
    
    override func executeActivateConstraints() {
        super.executeActivateConstraints()
        
        view.axis = axis
        view.distribution = distribution
        view.alignment = alignment
        view.spacing = spacing
        view.isBaselineRelativeArrangement = isBaselineRelativeArrangement
        view.isLayoutMarginsRelativeArrangement = isLayoutMarginsRelativeArrangement
    }
}
