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
        let subLayout = UIViewSubviewLayout(view: subview,
                                            superview: view)
        
        sublayouts.append(.uiview(layout: subLayout))
        arrangedSubviewsToAdd.append(subview)
        
        layoutClosure?(subLayout)
    }
    
    public func addArrangedStack(_ subview: UIStackView,
                                 layoutClosure: ((UIStackViewSubviewLayout) -> Void)?)
    {
        let subLayout = UIStackViewSubviewLayout(view: subview,
                                                 superview: view)
        
        sublayouts.append(.uistackview(layout: subLayout))
        arrangedSubviewsToAdd.append(subview)
        
        layoutClosure?(subLayout)
    }
    
    override func executeAddSubviews() {
        
        for (i, subview) in subviewsToAdd.enumerated() {
            view.insertSubview(subview, at: i)
        }
        
        for (i, subview) in arrangedSubviewsToAdd.enumerated() {
            view.insertArrangedSubview(subview, at: i)
        }
        
        (view.subviews + arrangedSubviewsToAdd)
            .filter { !subviewsToAdd.contains($0) && !arrangedSubviewsToAdd.contains($0) }
            .forEach { $0.removeFromSuperview() }
        
        for sublayout in sublayouts {
            switch sublayout {
            case .uiview(let layout):
                layout.executeAddSubviews()
            case .uistackview(let layout):
                layout.executeAddSubviews()
            }
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
