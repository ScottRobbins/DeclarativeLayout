import UIKit

public class UIStackViewSubviewLayoutComponent<T: UIStackView, R: UIView>: SubviewLayoutComponent<T, R>, UIStackViewLayoutComponentType {
    
    unowned var downcastedView: UIStackView { return view as UIStackView }
    private(set) var arrangedSubviews = [UIView]()
    private(set) var customSpacings = [(afterView: UIView, space: CGFloat)]()
    
    /**
     Add an arranged subview to the component's view. This will just add a regular UIView (`UIView()`).
     
     - parameters:
         - layoutClosure: A closure that will define the layout component for the subview.
     - returns: The layout component for the subview (the same one passed into the optional closure)
     
     If you are calling `updateLayoutTo` more than once, you should not use this as it will cause
     unnecessary layout recalculations to occur.
     */
    @discardableResult public func addArrangedView<UIView>(layoutClosure: ((UIViewSubviewLayoutComponent<UIView, T>, UIView, T) -> Void)? = nil) -> UIViewSubviewLayoutComponent<UIView, T>
    {
        return addArrangedView(UIView(), layoutClosure: layoutClosure)
    }
    
    /**
     Add an arranged subview to the component's view.
     
     - parameters:
        - subview: The view you would like to add as a subview to the component's view.
        - layoutClosure: A closure that will define the layout component for the subview.
     - returns: The layout component for the subview (the same one passed into the optional closure)
     */
    @discardableResult public func addArrangedView<Q>(_ subview: Q,
                                                      layoutClosure: ((UIViewSubviewLayoutComponent<Q, T>, Q, T) -> Void)? = nil) -> UIViewSubviewLayoutComponent<Q, T>
    {
        arrangedSubviews.append(subview)
        
        return addView(subview, layoutClosure: layoutClosure)
    }
    
    /**
     Add an arranged subview, that is a stack view, to the component's view. This will just add a regular UIStackView (`UIStackView()`).
     
     - parameters:
         - layoutClosure: A closure that will define the layout component for the subview.
     - returns: The layout component for the subview (the same one passed into the optional closure)
     
     * This will allow you to, in the layout closure, add arranged views for the passed in stack view.
     
     * If you are calling `updateLayoutTo` more than once, you should not use this as it will cause
     unnecessary layout recalculations to occur.
     */
    @discardableResult public func addArrangedStackView<UIStackView>(layoutClosure: ((UIStackViewSubviewLayoutComponent<UIStackView, T>, UIStackView, T) -> Void)? = nil) -> UIStackViewSubviewLayoutComponent<UIStackView, T>
    {
        return addArrangedStackView(UIStackView(), layoutClosure: layoutClosure)
    }
    
    /**
     Add an arranged subview, that is a stack view, to the component's view.
     
     - parameters:
        - subview: The view you would like to add as a subview to the component's view.
        - layoutClosure: A closure that will define the layout component for the subview.
     - returns: The layout component for the subview (the same one passed into the optional closure)
     
     This will allow you to, in the layout closure, add arranged views for the passed in stack view.
     */
    @discardableResult public func addArrangedStackView<Q>(_ subview: Q,
                                                           layoutClosure: ((UIStackViewSubviewLayoutComponent<Q, T>, Q, T) -> Void)? = nil) -> UIStackViewSubviewLayoutComponent<Q, T>
    {
        arrangedSubviews.append(subview)

        return addStackView(subview, layoutClosure: layoutClosure)
    }
    
    /**
     This is a convenience method to add a space after an arranged subview.
     If this is called before any arranged subviews are added, it will do nothing.
     Similarly, if no arranged subviews are added after it is called, it will do nothing.
     
     - parameters:
        - space: The amount of space to add along the UIStackView's axis.
     */
    @available(iOS 11.0, *)
    public func addSpace(_ space: CGFloat) {
        if let previouslyAddedArrangedSubview = arrangedSubviews.last {
            customSpacings.append((afterView: previouslyAddedArrangedSubview, space: space))
        }
    }
    
    override func allArrangedSubviews() -> [UIView: UIStackViewLayoutComponentType] {
        let arrangedSubviewsAndComponents = arrangedSubviews.reduce([:]) { (dict, view) -> [UIView: UIStackViewLayoutComponentType] in
            var dict = dict
            dict[view] = self
            return dict
        }
        return sublayoutComponents.reduce(arrangedSubviewsAndComponents) { (arrangedSubviews, layoutComponent) -> [UIView: UIStackViewLayoutComponentType] in
            switch layoutComponent {
            case .uistackview(let layoutComponent):
                return arrangedSubviews.merging(layoutComponent.allArrangedSubviews(), uniquingKeysWith: { a,b in  return a })
            case .uiview(let layoutComponent):
                return arrangedSubviews.merging(layoutComponent.allArrangedSubviews(), uniquingKeysWith: { a,b in  return a })
            case .layoutGuide(_):
                return arrangedSubviews
            }
        }
    }
}
