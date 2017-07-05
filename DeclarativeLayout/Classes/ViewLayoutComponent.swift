import UIKit

public class ViewLayoutComponent<T: UIView> {
    
    enum LayoutComponentType {
        case uiview(layout: UIViewSubviewLayoutComponent)
        case uistackview(layout: UIStackViewSubviewLayoutComponent)
    }
    
    public let view: T
    
    private(set) var subviews = [UIView]()
    private(set) var sublayoutComponents = [LayoutComponentType]()
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
        subviews.append(subview)
        
        layoutClosure?(subLayoutComponent)
    }
    
    public func addStack(_ stackview: UIStackView,
                         layoutClosure: ((UIStackViewSubviewLayoutComponent) -> Void)?)
    {
        stackview.translatesAutoresizingMaskIntoConstraints = false
        let subLayoutComponent = UIStackViewSubviewLayoutComponent(view: stackview,
                                                                   superview: view)
        
        sublayoutComponents.append(.uistackview(layout: subLayoutComponent))
        subviews.append(stackview)
        
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
    
    func allConstraints() -> [NSLayoutConstraint] {
        let initialConstraints = constraintClosures.flatMap { $0() }
        return sublayoutComponents.reduce(initialConstraints) { (combinedConstraints, layoutComponent) -> [NSLayoutConstraint] in
            switch layoutComponent {
            case .uistackview(let layoutComponent):
                return combinedConstraints + layoutComponent.allConstraints()
            case .uiview(let layoutComponent):
                return combinedConstraints + layoutComponent.allConstraints()
            }
        }
    }
    
    func allSubviews() -> [UIView] {
        return sublayoutComponents.reduce(subviews) { (subviews, layoutComponent) -> [UIView] in
            switch layoutComponent {
            case .uistackview(let layoutComponent):
                return subviews + layoutComponent.allSubviews()
            case .uiview(let layoutComponent):
                return subviews + layoutComponent.allSubviews()
            }
        }
    }
}
