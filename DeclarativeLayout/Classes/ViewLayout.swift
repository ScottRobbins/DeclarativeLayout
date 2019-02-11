public class ViewLayout<T: UIView> {
    
    private unowned var view: T
    private var currentLayoutComponent: UIViewLayoutComponent<T>
    
    /**
     Initialize your view layout with the root view you are defining a layout for
     
     - parameters:
        - view: The root view you would like to define a layout for
     */
    public init(view: T) {
        self.view = view
        self.currentLayoutComponent = UIViewLayoutComponent(view: view)
    }
    
    /**
     Update your layout
     
     - parameters:
        - layoutClosure: A closure that will define the layout component for the ViewLayout's view
     */
    public func updateLayoutTo(_ layoutClosure: (UIViewLayoutComponent<T>, T) -> ()) {
        let layoutComponent = UIViewLayoutComponent(view: view)
        layoutClosure(layoutComponent, view)
        
        removeUnneededArrangedSubviews(with: layoutComponent)
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
                
                if #available(iOS 11.0, *) {
                    for customSpacing in layoutComponent.customSpacings {
                        layoutComponent.downcastedView.setCustomSpacing(customSpacing.space, after: customSpacing.afterView)
                    }
                }
            }
        }
    }
    
    private func removeUnneededSubviews(with layoutComponent: UIViewLayoutComponent<T>) {
        let layoutComponentSubviews = Set(layoutComponent.allSubviews())
        currentLayoutComponent.allSubviews()
            .filter { !layoutComponentSubviews.contains($0) }
            .forEach { $0.removeFromSuperview() }
    }
    
    private func removeUnneededArrangedSubviews(with layoutComponent: ViewLayoutComponentType) {
        let currentArrangedSubviews = currentLayoutComponent.allArrangedSubviews()
        let newArrangedSubviews = layoutComponent.allArrangedSubviews()
        
        for (view, currentLayoutComponent) in currentArrangedSubviews {
            if newArrangedSubviews[view] == nil {
                view.removeFromSuperview()
            } else if let newComponent = newArrangedSubviews[view],
                newComponent.downcastedView != currentLayoutComponent.downcastedView
            {
                view.removeFromSuperview()
            }
        }
    }
    
    private func updateConstraints(with layoutComponent: UIViewLayoutComponent<T>) {
        let newConstraintsArray = layoutComponent.allConstraints()
        let currentConstraintsArray = currentLayoutComponent.allConstraints()
        
        if currentConstraintsArray.isEmpty {
            NSLayoutConstraint.activate(newConstraintsArray.map { $0.wrappedConstraint })
        } else {
            let newConstraints = Set(newConstraintsArray)
            var currentConstraints = Set(currentConstraintsArray)
            let matchingConstraints = newConstraints.intersection(currentConstraints)
            let constraintsToRemove = currentConstraints.subtracting(matchingConstraints)
            let constraintsToAdd = newConstraints.subtracting(matchingConstraints)
            
            for constraint in matchingConstraints {
                let matchingWrappedConstraint = currentConstraints.remove(constraint)!.wrappedConstraint
                let wrappedConstraint = constraint.wrappedConstraint
                if matchingWrappedConstraint.constant != wrappedConstraint.constant {
                    matchingWrappedConstraint.constant = wrappedConstraint.constant
                }
                
                if matchingWrappedConstraint.priority != wrappedConstraint.priority {
                    matchingWrappedConstraint.priority = wrappedConstraint.priority
                }
                
                if matchingWrappedConstraint.identifier != wrappedConstraint.identifier {
                    matchingWrappedConstraint.identifier = wrappedConstraint.identifier
                }
            }
            
            NSLayoutConstraint.deactivate(constraintsToRemove.map { $0.wrappedConstraint })
            NSLayoutConstraint.activate(constraintsToAdd.map { $0.wrappedConstraint })
        }
    }
}
