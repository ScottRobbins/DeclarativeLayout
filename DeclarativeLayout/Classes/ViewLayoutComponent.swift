import UIKit

enum LayoutComponentType {
    case uiview(layout: UIViewLayoutComponentType)
    case uistackview(layout: UIStackViewLayoutComponentType)
}

protocol ConstraintAndViewCollectionDelegate: class {
    func activate(_ constraints: Set<LayoutConstraint>)
    func addSubview(_ subview: UIView)
}

protocol ViewLayoutComponentType {
    var subviews: [UIView] { get }
    var sublayoutComponents: [LayoutComponentType] { get }
}

protocol UIViewLayoutComponentType: ViewLayoutComponentType {
    var downcastedView: UIView { get }
}

protocol UIStackViewLayoutComponentType: ViewLayoutComponentType {
    var downcastedView: UIStackView { get }
    var arrangedSubviews: [UIView] { get }
    var customSpacings: [(afterView: UIView, space: CGFloat)] { get }
}

public class ViewLayoutComponent<T: UIView>: ViewLayoutComponentType {
    
    /**
     The component's view. 
     */
    public let view: T
    private(set) var subviews = [UIView]()
    private(set) var sublayoutComponents = [LayoutComponentType]()
    
    weak var collectionDelegate: ConstraintAndViewCollectionDelegate?
    
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
                                                              superview: view,
                                                              collectionDelegate: collectionDelegate)
        
        sublayoutComponents.append(.uiview(layout: subLayoutComponent))
        subviews.append(subview)
        collectionDelegate?.addSubview(subview)
        
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
                                                                   superview: view,
                                                                   collectionDelegate: collectionDelegate)
        
        sublayoutComponents.append(.uistackview(layout: subLayoutComponent))
        subviews.append(subview)
        collectionDelegate?.addSubview(subview)
        
        layoutClosure?(subLayoutComponent, subview, view)
    }
    
    /**
     Define constraints that should be activated
     
     - parameters:
        - constraints: Constraints to activate
     
     - important: Do not activate these constraints yourself, the framework will do that for you.
        If these constraints are activated at the wrong time it can cause your application to crash.
     */
    public func activate(_ constraints: [NSLayoutConstraint]) {
        let layoutConstraints = Set(constraints.map(LayoutConstraint.init(wrappedConstraint:)))
        collectionDelegate?.activate(layoutConstraints)
    }
}
