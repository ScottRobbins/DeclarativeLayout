import UIKit

public class UIStackViewSubviewLayoutComponent<T: UIStackView, R: UIView>: SubviewLayoutComponent<T, R>, UIStackViewLayoutComponentType {
    
    var downcastedView: UIStackView { return view as UIStackView }
    private(set) var arrangedSubviews = [UIView]()
    
    /**
     Add an arranged subview to the component's view.
     
     - parameters:
        - subview: The view you would like to add as a subview to the component's view.
        - layoutClosure: A closure that will define the layout component for the subview.
     */
    public func addArrangedView<Q>(_ subview: Q,
                                   layoutClosure: ((UIViewSubviewLayoutComponent<Q, T>) -> Void)?)
    {
        arrangedSubviews.append(subview)
        
        addView(subview, layoutClosure: layoutClosure)
    }
    
    /**
     Add an arranged subview, that is a stack view, to the component's view.
     
     - parameters:
        - subview: The view you would like to add as a subview to the component's view.
        - layoutClosure: A closure that will define the layout component for the subview.
     
     This will allow you to, in the layout closure, add arranged views for the passed in stack view.
     */
    public func addArrangedStackView<Q>(_ subview: Q,
                                        layoutClosure: ((UIStackViewSubviewLayoutComponent<Q, T>) -> Void)?)
    {
        arrangedSubviews.append(subview)

        addStackView(subview, layoutClosure: layoutClosure)
    }
}
