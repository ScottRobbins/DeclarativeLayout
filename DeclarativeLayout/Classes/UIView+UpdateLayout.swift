import UIKit

public extension UIView {
    
    public func updateLayoutTo(_ layoutClosure: (UIViewLayout) -> ()) {
        let layout = UIViewLayout(view: self)
        layoutClosure(layout)
        
        layout.executeAddSubviews()

        let newConstraints = layout.allconstraints()
        let currentConstraints = allConstraintsRecursively(fromView: self)
        
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
            }
        }
        
        NSLayoutConstraint.deactivate(constraintsToRemove)
        NSLayoutConstraint.activate(constraintsToActivate)
    }
    
    private func allConstraintsRecursively(fromView view: UIView) -> [NSLayoutConstraint] {
        return view.constraints + view.subviews.flatMap { allConstraintsRecursively(fromView: $0) }
    }
}
