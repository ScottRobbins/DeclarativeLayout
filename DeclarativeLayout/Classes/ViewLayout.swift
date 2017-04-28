import UIKit

public class ViewLayout<T: UIView> {
    
    private enum LayoutType {
        case uiview(layout: UIViewSubviewLayout)
        case uistackview(layout: UIStackViewSubviewLayout)
    }
    
    public let view: T
    
    private var subviewsToAdd = [UIView]()
    private var sublayouts = [LayoutType]()
    private var constraintClosures = [() -> [NSLayoutConstraint]]()
    
    init(view: T) {
        self.view = view
    }
    
    public func add(_ subview: UIView,
                    layoutClosure: ((UIViewSubviewLayout) -> Void)?)
    {
        let subLayout = UIViewSubviewLayout(view: subview,
                                            superview: view)
        
        sublayouts.append(.uiview(layout: subLayout))
        subviewsToAdd.append(subview)
        
        layoutClosure?(subLayout)
    }
    
    public func addStack(_ stackview: UIStackView,
                         layoutClosure: ((UIStackViewSubviewLayout) -> Void)?)
    {
        let subLayout = UIStackViewSubviewLayout(view: stackview,
                                                 superview: view)
        
        sublayouts.append(.uistackview(layout: subLayout))
        subviewsToAdd.append(stackview)
        
        layoutClosure?(subLayout)
    }
    
    /*
     @autoclosure is important so that frameworks like Anchorage that activate constraints on creation can be used.
     This will prevent the constraints from really being created/activated until after we have made sure all of the
     involved views have been added to the view hierarchy. If a constraint, involving one or more views
     that are not in the hierarchy, is activated the application will crash.
     */
    public func activate(_ constraints: @escaping @autoclosure () -> [NSLayoutConstraint] ) {
        constraintClosures.append(constraints)
    }
    
    func allconstraints() -> [NSLayoutConstraint] {
        let initialConstraints = constraintClosures.flatMap { $0() }
        return sublayouts.reduce(initialConstraints) { (combinedConstraints, layout) -> [NSLayoutConstraint] in
            switch layout {
            case .uistackview(let layout):
                return combinedConstraints + layout.allconstraints()
            case .uiview(let layout):
                return combinedConstraints + layout.allconstraints()
            }
        }
    }
    
    func executeAddSubviews() {
        
        for (i, subview) in subviewsToAdd.enumerated() {
            view.insertSubview(subview, at: i)
        }
        
        view
            .subviews
            .filter { !subviewsToAdd.contains($0) }
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
    
    func executeActivateConstraints() {

        view
            .constraints
            .forEach { $0.isActive = false }
        
        if constraintClosures.count > 0 {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        constraintClosures
            .flatMap { $0() }
            .forEach { $0.isActive = true }
        
        for sublayout in sublayouts {
            switch sublayout {
            case .uiview(let layout):
                layout.executeActivateConstraints()
            case .uistackview(let layout):
                layout.executeActivateConstraints()
            }
        }
    }
}
