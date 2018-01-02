import UIKit

enum LayoutComponentType {
    case uiview(layout: UIViewLayoutComponentType)
    case uistackview(layout: UIStackViewLayoutComponentType)
}

protocol ViewLayoutComponentType {
    func allSubviews() -> [UIView]
    func allConstraints() -> [LayoutConstraint]
    var subviews: [UIView] { get }
    var sublayoutComponents: [LayoutComponentType] { get }
}

protocol UIViewLayoutComponentType: ViewLayoutComponentType {
    var downcastedView: UIView { get }
}

protocol UIStackViewLayoutComponentType: ViewLayoutComponentType {
    var downcastedView: UIStackView { get }
    var arrangedSubviews: [UIView] { get }
}

public class ViewLayoutComponent<T: UIView>: ViewLayoutComponentType {
    
    enum ConstraintContainer {
        case closures(closures: [() -> [NSLayoutConstraint]])
        case constraints(constraints: [LayoutConstraint])
    }
    
    /**
     The component's view. 
     */
    public let view: T
    private(set) var subviews = [UIView]()
    private(set) var sublayoutComponents = [LayoutComponentType]()
    private var constraintContainer = ConstraintContainer.closures(closures: [() -> [NSLayoutConstraint]]())
    
    init(view: T) {
        self.view = view
    }
    
    /**
     Add a subview to the component's view.
     
     - parameters:
        - subview: The view you would like to add as a subview to the component's view.
        - layoutClosure: A closure that will define the layout component for the subview.
     */
    public func addView<R>(_ subview: R,
                           layoutClosure: ((UIViewSubviewLayoutComponent<R, T>, R, T) -> Void)?)
    {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let subLayoutComponent = UIViewSubviewLayoutComponent(view: subview,
                                                              superview: view)
        
        sublayoutComponents.append(.uiview(layout: subLayoutComponent))
        subviews.append(subview)
        
        layoutClosure?(subLayoutComponent, subview, view)
    }
    
    /**
     Add a subview, that is a stack view, to the component's view.
     
     - parameters:
        - subview: The view you would like to add as a subview to the component's view.
        - layoutClosure: A closure that will define the layout component for the subview.
     
     This will allow you to, in the layout closure, add arranged views for the passed in stack view.
     */
    public func addStackView<R>(_ subview: R,
                                layoutClosure: ((UIStackViewSubviewLayoutComponent<R, T>, R, T) -> Void)?)
    {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let subLayoutComponent = UIStackViewSubviewLayoutComponent(view: subview,
                                                                   superview: view)
        
        sublayoutComponents.append(.uistackview(layout: subLayoutComponent))
        subviews.append(subview)
        
        layoutClosure?(subLayoutComponent, subview, view)
    }
    
    /**
     Define constraints that should be activated
     
     - parameters:
        - constraints: Constraints to activate
     
     - important: These are captured as an autoclosure, so that the creation of constraints created in the call to this method will be delayed until after all views are added to the view hierarchy. This will allow users to use libraries that create and activate constraints at the same time.
     */
    public func activate(_ constraints: @escaping @autoclosure () -> [NSLayoutConstraint] ) {
        switch constraintContainer {
        case .closures(let closures):
            constraintContainer = .closures(closures: closures + [constraints])
        case .constraints(_):
            // No code should actually get here
            constraintContainer = .closures(closures: [constraints])
        }
    }
    
    func allConstraints() -> [LayoutConstraint] {
        
        let initialConstraints: [LayoutConstraint]
        switch constraintContainer {
        case .closures(let closures):
            initialConstraints = closures.flatMap { $0() }.map(LayoutConstraint.init)
            constraintContainer = .constraints(constraints: initialConstraints)
        case .constraints(let constraints):
            initialConstraints = constraints
        }
        
        return sublayoutComponents.reduce(initialConstraints) { (combinedConstraints, layoutComponent) -> [LayoutConstraint] in
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
