import UIKit

enum LayoutComponentType {
    case uiview(layout: UIViewLayoutComponentType)
    case uistackview(layout: UIStackViewLayoutComponentType)
}

protocol ViewLayoutComponentType {
    func allSubviews() -> [UIView]
    func allConstraints() -> HashSet<LayoutConstraint>
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
        case constraints(constraints: HashSet<LayoutConstraint>)
    }
    
    public let view: T
    private(set) var subviews = [UIView]()
    private(set) var sublayoutComponents = [LayoutComponentType]()
    private var constraintContainer = ConstraintContainer.closures(closures: [() -> [NSLayoutConstraint]]())
    
    init(view: T) {
        self.view = view
    }
    
    public func addView<R>(_ subview: R,
                    layoutClosure: ((UIViewSubviewLayoutComponent<R, T>) -> Void)?)
    {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let subLayoutComponent = UIViewSubviewLayoutComponent(view: subview,
                                                              superview: view)
        
        sublayoutComponents.append(.uiview(layout: subLayoutComponent))
        subviews.append(subview)
        
        layoutClosure?(subLayoutComponent)
    }
    
    public func addStackView<R>(_ stackview: R,
                         layoutClosure: ((UIStackViewSubviewLayoutComponent<R, T>) -> Void)?)
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
        switch constraintContainer {
        case .closures(let closures):
            constraintContainer = .closures(closures: closures + [constraints])
        case .constraints(_):
            // No code should actually get here
            constraintContainer = .closures(closures: [constraints])
        }
    }
    
    func allConstraints() -> HashSet<LayoutConstraint> {
        
        let initialConstraints: HashSet<LayoutConstraint>
        switch constraintContainer {
        case .closures(let closures):
            initialConstraints = HashSet(closures.flatMap { $0() }.map(LayoutConstraint.init))
            constraintContainer = .constraints(constraints: initialConstraints)
        case .constraints(let constraints):
            initialConstraints = constraints
        }
        
        return sublayoutComponents.reduce(initialConstraints) { (combinedConstraints, layoutComponent) -> HashSet<LayoutConstraint> in
            switch layoutComponent {
            case .uistackview(let layoutComponent):
                return combinedConstraints.union(layoutComponent.allConstraints())
            case .uiview(let layoutComponent):
                return combinedConstraints.union(layoutComponent.allConstraints())
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
