import UIKit

public class UIStackViewSubviewLayout: SubviewLayout<UIStackView> {
    
    public var axis: UILayoutConstraintAxis {
        didSet {
            view.axis = axis
        }
    }
    public var distribution: UIStackViewDistribution {
        didSet {
            view.distribution = distribution
        }
    }
    public var alignment: UIStackViewAlignment {
        didSet {
            view.alignment = alignment
        }
    }
    public var spacing: CGFloat {
        didSet {
            view.spacing = spacing
        }
    }
    public var isBaselineRelativeArrangement: Bool {
        didSet {
            view.isBaselineRelativeArrangement = isBaselineRelativeArrangement
        }
    }
    public var isLayoutMarginsRelativeArrangement: Bool {
        didSet {
            view.isLayoutMarginsRelativeArrangement = isLayoutMarginsRelativeArrangement
        }
    }
    
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
    
}
