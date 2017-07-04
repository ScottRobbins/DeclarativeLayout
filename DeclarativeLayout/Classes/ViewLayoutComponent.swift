import UIKit

public class ViewLayoutComponent<T: UIView> {
    
    private enum LayoutComponentType {
        case uiview(layout: UIViewSubviewLayoutComponent)
        case uistackview(layout: UIStackViewSubviewLayoutComponent)
    }
    
    public let view: T
    
    private var subviewsToAdd = [UIView]()
    private var sublayoutComponents = [LayoutComponentType]()
    private var constraintClosures = [() -> [NSLayoutConstraint]]()
    
    init(view: T) {
        self.view = view
    }
    
    public func add(_ subview: UIView,
                    layoutClosure: ((UIViewSubviewLayoutComponent) -> Void)?)
    {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let subLayoutComponent = UIViewSubviewLayoutComponent(view: subview,
                                                              superview: view)
        
        sublayoutComponents.append(.uiview(layout: subLayoutComponent))
        subviewsToAdd.append(subview)
        
        layoutClosure?(subLayoutComponent)
    }
    
    public func addStack(_ stackview: UIStackView,
                         layoutClosure: ((UIStackViewSubviewLayoutComponent) -> Void)?)
    {
        stackview.translatesAutoresizingMaskIntoConstraints = false
        let subLayoutComponent = UIStackViewSubviewLayoutComponent(view: stackview,
                                                                   superview: view)
        
        sublayoutComponents.append(.uistackview(layout: subLayoutComponent))
        subviewsToAdd.append(stackview)
        
        layoutClosure?(subLayoutComponent)
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
        return sublayoutComponents.reduce(initialConstraints) { (combinedConstraints, layoutComponent) -> [NSLayoutConstraint] in
            switch layoutComponent {
            case .uistackview(let layoutComponent):
                return combinedConstraints + layoutComponent.allconstraints()
            case .uiview(let layoutComponent):
                return combinedConstraints + layoutComponent.allconstraints()
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
        
        for sublayoutComponent in sublayoutComponents {
            switch sublayoutComponent {
            case .uiview(let layoutComponent):
                layoutComponent.executeAddSubviews()
            case .uistackview(let layoutComponent):
                layoutComponent.executeAddSubviews()
            }
        }
    }
    
}
