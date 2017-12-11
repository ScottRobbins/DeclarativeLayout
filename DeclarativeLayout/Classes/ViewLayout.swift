public class ViewLayout<T: UIView> {
    
    private let view: T
    private var currentLayoutComponent: UIViewLayoutComponent<T>
    
    public init(view: T) {
        self.view = view
        self.currentLayoutComponent = UIViewLayoutComponent(view: view)
    }
    
    public func updateLayoutTo(_ layoutClosure: (UIViewLayoutComponent<T>) -> ()) {
        let layoutComponent = UIViewLayoutComponent(view: view)
        layoutClosure(layoutComponent)
        
        addSubviews(with: layoutComponent)
        removeUnneededSubviews(with: layoutComponent)
        updateConstraints(with: layoutComponent)
        
        currentLayoutComponent = layoutComponent
    }
    
    private func addSubviews(with layoutComponent: UIViewLayoutComponentType) {
        for (i, subview) in layoutComponent.subviews.enumerated() {
            layoutComponent.downcastedView.insertSubview(subview, at: i)
        }
        
        addSubviewsForSublayoutComponents(with: layoutComponent)
    }
    
    private func addSubviews(with layoutComponent: UIStackViewLayoutComponentType) {
        for (i, subview) in layoutComponent.subviews.enumerated() {
            layoutComponent.downcastedView.insertSubview(subview, at: i)
        }
        
        addSubviewsForSublayoutComponents(with: layoutComponent)
    }
    
    private func addSubviewsForSublayoutComponents(with layoutComponent: ViewLayoutComponentType) {
        for sublayoutComponent in layoutComponent.sublayoutComponents {
            switch sublayoutComponent {
            case .uiview(let layoutComponent):
                addSubviews(with: layoutComponent)
            case .uistackview(let layoutComponent):
                addSubviews(with: layoutComponent)
                
                for (i, subview) in layoutComponent.arrangedSubviews.enumerated() {
                    layoutComponent.downcastedView.insertArrangedSubview(subview, at: i)
                }
            }
        }
    }
    
    private func removeUnneededSubviews(with layoutComponent: UIViewLayoutComponent<T>) {
        currentLayoutComponent.allSubviews()
            .filter { !layoutComponent.allSubviews().contains($0) }
            .forEach { $0.removeFromSuperview() }
    }
    
    private func updateConstraints(with layoutComponent: UIViewLayoutComponent<T>) {
        let newConstraints = layoutComponent.allConstraints()
        let currentConstraints = currentLayoutComponent.allConstraints()
        let currentConstraintDictionary = currentConstraints.constraintDictionary
        
        var constraintsToRemove = currentConstraints
        var constraintsToActivate = newConstraints
        
        for constraint in newConstraints {
            if let matchingConstraint = currentConstraintDictionary[constraint] {
                
                if let index = constraintsToRemove.index(of: matchingConstraint) {
                    constraintsToRemove.remove(at: index)
                }
                
                if let index = constraintsToActivate.index(of: constraint) {
                    constraintsToActivate.remove(at: index)
                }
                
                if matchingConstraint.wrappedConstraint.constant != constraint.wrappedConstraint.constant {
                    matchingConstraint.wrappedConstraint.constant = constraint.wrappedConstraint.constant
                }
                
                if matchingConstraint.wrappedConstraint.priority != constraint.wrappedConstraint.priority {
                    matchingConstraint.wrappedConstraint.priority = constraint.wrappedConstraint.priority
                }
                
                if matchingConstraint.wrappedConstraint.identifier != constraint.wrappedConstraint.identifier {
                    matchingConstraint.wrappedConstraint.identifier = constraint.wrappedConstraint.identifier
                }
            }
        }
        
        NSLayoutConstraint.deactivate(constraintsToRemove.map() { $0.wrappedConstraint })
        NSLayoutConstraint.activate(constraintsToActivate.map() { $0.wrappedConstraint })
    }
}

extension Array where Element == LayoutConstraint {
    
    /// This just maps all of the constraints as keys with themselves as the values. Just makes it a faster operation to find matches of new constraints later on
    var constraintDictionary: [LayoutConstraint: LayoutConstraint] {
        return reduce([:]) { (dictionary, constraint) -> [LayoutConstraint: LayoutConstraint] in
            var mutableDictionary = dictionary
            mutableDictionary[constraint] = constraint
            return mutableDictionary
        }
    }
}
