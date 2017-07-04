public class ViewLayout {
    
    private let view: UIView
    private var currentLayoutComponent: UIViewLayoutComponent
    
    public init(view: UIView) {
        self.view = view
        self.currentLayoutComponent = UIViewLayoutComponent(view: view)
    }
    
    public func updateLayoutTo(_ layoutClosure: (UIViewLayoutComponent) -> ()) {
        let layoutComponent = UIViewLayoutComponent(view: view)
        layoutClosure(layoutComponent)
        
        layoutComponent.executeAddSubviews()
        
        let newConstraints = layoutComponent.allconstraints()
        let currentConstraints = currentLayoutComponent.allconstraints()
        
        var constraintsToRemove = currentConstraints
        var constraintsToActivate = newConstraints
        
        for constraint in newConstraints {
            let matchingConstraints = currentConstraints.filter { $0 == constraint }
            
            if let matchingConstraint = matchingConstraints.first {
                if let index = constraintsToRemove.index(of: matchingConstraint) {
                    constraintsToRemove.remove(at: index)
                }
                
                if let index = constraintsToActivate.index(of: constraint) {
                    constraintsToActivate.remove(at: index)
                }
                
                if matchingConstraint.constant != constraint.constant {
                    matchingConstraint.constant = constraint.constant
                }
                
                if matchingConstraint.priority != constraint.priority {
                    matchingConstraint.priority = constraint.priority
                }
                
                if matchingConstraint.identifier != constraint.identifier {
                    matchingConstraint.identifier = constraint.identifier
                }
            }
        }
        
        NSLayoutConstraint.deactivate(constraintsToRemove)
        NSLayoutConstraint.activate(constraintsToActivate)
    }
}
