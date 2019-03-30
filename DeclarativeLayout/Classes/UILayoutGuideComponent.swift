import UIKit

public final class UILayoutGuideComponent<R: UIView>: LayoutGuideComponentType {
    
    /**
     The component's layout guide.
     */
    public unowned final let layoutGuide: UILayoutGuide
    
    /**
     The component's layoutGuide's owningView
     */
    public unowned final let owningView: R

    private var constraints = [LayoutConstraint]()
    
    init(layoutGuide: UILayoutGuide, owningView: R) {
        self.layoutGuide = layoutGuide
        self.owningView = owningView
    }

    /**
     Define constraints that should be activated

     - parameters:
        - constraints: Constraints to activate

     - important: Do not activate these constraints yourself, the framework will do that for you.
     If these constraints are activated at the wrong time it can cause your application to crash.
     */
    public func activate(_ constraints: NSLayoutConstraint...) {
        activate(constraints)
    }
    
    /**
     Define constraints that should be activated
     
     - parameters:
        - constraints: Constraints to activate
     
     - important: Do not activate these constraints yourself, the framework will do that for you.
     If these constraints are activated at the wrong time it can cause your application to crash.
     */
    public func activate(_ constraints: [NSLayoutConstraint]) {
        self.constraints += constraints.map(LayoutConstraint.init(wrappedConstraint:))
    }
    
    func allConstraints() -> [LayoutConstraint] {
        return constraints
    }
}
