import UIKit

public final class UIStackViewSubviewLayoutComponent<T: UIStackView, R: UIView>: SubviewLayoutComponent<T, R>, UIStackViewLayoutComponentType {
    
    unowned var downcastedView: UIStackView { return ownedView as UIStackView }
    private(set) var arrangedSubviews = [UIView]()
    private(set) var customSpacings = [(afterView: UIView, space: CGFloat)]()

    /**
     Add an arranged subview to the component's view.

     - parameters:
        - identifier: An identifier to give for this view.
        - layoutClosure: A closure that will define the layout component for the subview.
     - returns: The layout component for the subview (the same one passed into the optional closure)

     * This will just add a regular UIView (`UIView()`).
     * Using an identifier will let you refer to the same created instance of a `UIView` in subsequent layout updates.
     */
    @discardableResult public func arrangedView(identifier: String,
                                                   layoutClosure: ((UIViewSubviewLayoutComponent<UIView, T>)
        -> Void)? = nil) -> UIViewSubviewLayoutComponent<UIView, T>
    {
        if let _view = cachedLayoutObjectStore.viewStorage[identifier] {
            return arrangedView(_view, layoutClosure: layoutClosure)
        } else {
            let _view = UIView()
            cachedLayoutObjectStore.viewStorage[identifier] = _view
            return arrangedView(_view, layoutClosure: layoutClosure)
        }
    }
    
    /**
     Add an arranged subview to the component's view.
     
     - parameters:
         - layoutClosure: A closure that will define the layout component for the subview.
     - returns: The layout component for the subview (the same one passed into the optional closure)

     * This will just add a regular UIView (`UIView()`).
     * If you are calling `updateLayoutTo` more than once, you should not use this as it will cause
     unnecessary layout recalculations to occur.
     Consider using `arrangedView(identifier:layoutClosure:)` instead for that situation.
     */
    @discardableResult public func arrangedView(layoutClosure: ((UIViewSubviewLayoutComponent<UIView, T>) -> Void)? = nil) -> UIViewSubviewLayoutComponent<UIView, T>
    {
        return arrangedView(UIView(), layoutClosure: layoutClosure)
    }
    
    /**
     Add an arranged subview to the component's view.
     
     - parameters:
        - subview: The view you would like to add as a subview to the component's view.
        - layoutClosure: A closure that will define the layout component for the subview.
     - returns: The layout component for the subview (the same one passed into the optional closure)
     */
    @discardableResult public func arrangedView<Q>(_ subview: Q,
                                                      layoutClosure: ((UIViewSubviewLayoutComponent<Q, T>) -> Void)? = nil) -> UIViewSubviewLayoutComponent<Q, T>
    {
        arrangedSubviews.append(subview)
        
        return view(subview, layoutClosure: layoutClosure)
    }

    /**
     Add an arranged subview, that is a stack view, to the component's view.

     - parameters:
        - identifier: An identifier to give for this view.
        - layoutClosure: A closure that will define the layout component for the subview.
     - returns: The layout component for the subview (the same one passed into the optional closure)

     * This will just add a regular UIStackView (`UIStackView()`).
     * This will allow you to, in the layout closure, add arranged views for the passed in stack view.
     */
    @discardableResult public func arrangedStackView(identifier: String,
                                                        layoutClosure: ((UIStackViewSubviewLayoutComponent<UIStackView, T>) -> Void)? = nil)
        -> UIStackViewSubviewLayoutComponent<UIStackView, T>
    {
        if let view = cachedLayoutObjectStore.stackViewStorage[identifier] {
            return arrangedStackView(view, layoutClosure: layoutClosure)
        } else {
            let view = UIStackView()
            cachedLayoutObjectStore.viewStorage[identifier] = view
            return arrangedStackView(view, layoutClosure: layoutClosure)
        }
    }
    
    /**
     Add an arranged subview, that is a stack view, to the component's view.
     
     - parameters:
         - layoutClosure: A closure that will define the layout component for the subview.
     - returns: The layout component for the subview (the same one passed into the optional closure)

     * This will just add a regular UIStackView (`UIStackView()`).
     * This will allow you to, in the layout closure, add arranged views for the passed in stack view.
     * If you are calling `updateLayoutTo` more than once, you should not use this as it will cause
     unnecessary layout recalculations to occur.
     Consider using `arrangedStackView(identifier:layoutClosure:)` instead for that situation.
     */
    @discardableResult public func arrangedStackView(layoutClosure: ((UIStackViewSubviewLayoutComponent<UIStackView, T>) -> Void)? = nil) -> UIStackViewSubviewLayoutComponent<UIStackView, T>
    {
        return arrangedStackView(UIStackView(), layoutClosure: layoutClosure)
    }
    
    /**
     Add an arranged subview, that is a stack view, to the component's view.
     
     - parameters:
        - subview: The view you would like to add as a subview to the component's view.
        - layoutClosure: A closure that will define the layout component for the subview.
     - returns: The layout component for the subview (the same one passed into the optional closure)
     
     This will allow you to, in the layout closure, add arranged views for the passed in stack view.
     */
    @discardableResult public func arrangedStackView<Q>(_ subview: Q,
                                                           layoutClosure: ((UIStackViewSubviewLayoutComponent<Q, T>) -> Void)? = nil) -> UIStackViewSubviewLayoutComponent<Q, T>
    {
        arrangedSubviews.append(subview)

        return stackView(subview, layoutClosure: layoutClosure)
    }
    
    /**
     This is a convenience method to add a space after an arranged subview.
     
     - parameters:
        - space: The amount of space to add along the UIStackView's axis.

     If this is called before any arranged subviews are added, it will do nothing.
     Similarly, if no arranged subviews are added after it is called, it will do nothing.
     */
    @available(iOS 11.0, *)
    public func space(_ space: CGFloat) {
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
