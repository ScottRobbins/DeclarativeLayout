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
        
        var matchedConstraints = HashSet<LayoutConstraint>()
        
        for constraint in newConstraints.allElements() {
            if let matchingConstraint = currentConstraints.get(constraint) {
                matchedConstraints.insert(matchingConstraint)
                
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
        
        let constraintsToRemove = currentConstraints
            .difference(matchedConstraints)
            .allElements()
            .map { $0.wrappedConstraint }
        let constraintsToActivate = newConstraints
            .difference(matchedConstraints)
            .allElements()
            .map { $0.wrappedConstraint }
        NSLayoutConstraint.deactivate(constraintsToRemove)
        NSLayoutConstraint.activate(constraintsToActivate)
    }
}
