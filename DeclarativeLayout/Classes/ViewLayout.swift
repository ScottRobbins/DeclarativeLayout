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
    
    private func removeUnneededSubviews(with layoutComponent: UIViewLayoutComponent) {
        currentLayoutComponent.allSubviews()
            .filter { !layoutComponent.allSubviews().contains($0) }
            .forEach { $0.removeFromSuperview() }
    }
    
    private func updateConstraints(with layoutComponent: UIViewLayoutComponent) {
        let newConstraints = layoutComponent.allConstraints()
        let currentConstraints = currentLayoutComponent.allConstraints()
        
        var constraintsToRemove = currentConstraints
        var constraintsToActivate = newConstraints
        
        for constraint in newConstraints {
            let matchingConstraints = currentConstraints.filter { $0 == constraint }
            
            for matchingConstraint in matchingConstraints {
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
