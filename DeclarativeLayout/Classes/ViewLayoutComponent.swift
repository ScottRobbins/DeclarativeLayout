import UIKit

enum LayoutComponentType {
    case uiview(layout: UIViewLayoutComponentType)
    case uistackview(layout: UIStackViewLayoutComponentType)
    case layoutGuide(layout: LayoutGuideComponentType)
}

protocol ViewLayoutComponentType {
    func allSubviews() -> [UIView]
    func allArrangedSubviews() -> [UIView: UIStackViewLayoutComponentType]
    func allConstraints() -> [LayoutConstraint]
    func allLayoutGuides() -> [UILayoutGuide: UIView]
    var subviews: [UIView] { get }
    var sublayoutComponents: [LayoutComponentType] { get }
    var layoutGuides: [UILayoutGuide] { get }
}

protocol LayoutGuideComponentType {
    func allConstraints() -> [LayoutConstraint]
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
    public unowned let view: T
    private(set) var subviews = [UIView]()
    private(set) var sublayoutComponents = [LayoutComponentType]()
    private(set) var layoutGuides = [UILayoutGuide]()
    private var constraints = [LayoutConstraint]()
    
    init(view: T) {
        self.view = view
    }
    
    /**
     Add a subview to the component's view.
     
     - parameters:
        - subview: The view you would like to add as a subview to the component's view.
        - layoutClosure: A closure that will define the layout component for the subview.
     - returns: The layout component for the subview (the same one passed into the optional closure)
     */
    @discardableResult public func addView<R>(_ subview: R,
                                              layoutClosure: ((UIViewSubviewLayoutComponent<R, T>, R, T) -> Void)? = nil) -> UIViewSubviewLayoutComponent<R, T>
    {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let subLayoutComponent = UIViewSubviewLayoutComponent(view: subview,
                                                              superview: view)
        
        sublayoutComponents.append(.uiview(layout: subLayoutComponent))
        subviews.append(subview)
        
        layoutClosure?(subLayoutComponent, subview, view)
        return subLayoutComponent
    }
    
    /**
     Add a subview, that is a stack view, to the component's view.
     
     - parameters:
        - subview: The view you would like to add as a subview to the component's view.
        - layoutClosure: A closure that will define the layout component for the subview.
     - returns: The layout component for the subview (the same one passed into the optional closure)
     
     This will allow you to, in the layout closure, add arranged views for the passed in stack view.
     */
    @discardableResult public func addStackView<R>(_ subview: R,
                                                   layoutClosure: ((UIStackViewSubviewLayoutComponent<R, T>, R, T) -> Void)? = nil) -> UIStackViewSubviewLayoutComponent<R, T>
    {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let subLayoutComponent = UIStackViewSubviewLayoutComponent(view: subview,
                                                                   superview: view)
        
        sublayoutComponents.append(.uistackview(layout: subLayoutComponent))
        subviews.append(subview)
        
        layoutClosure?(subLayoutComponent, subview, view)
        return subLayoutComponent
    }
    
    /**
     Add a layout guide to the component's view.
     
     - parameters:
         - layoutGuide: The layout guide you would like ot add to the component's view.
         - layoutClosure: A closure that will define the layout component for the layout guide.
     - returns: The layout component for the layout guide (the same one passed into the optional closure)
     */
    @discardableResult public func addLayoutGuide(_ layoutGuide: UILayoutGuide,
                                                  layoutClosure: ((UILayoutGuideComponent<T>, UILayoutGuide, T) -> Void)? = nil) -> UILayoutGuideComponent<T> {
        let subLayoutComponent = UILayoutGuideComponent(layoutGuide: layoutGuide,
                                                        owningView: view)
        sublayoutComponents.append(.layoutGuide(layout: subLayoutComponent))
        layoutGuides.append(layoutGuide)
        
        layoutClosure?(subLayoutComponent, layoutGuide, view)
        return subLayoutComponent
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
        return sublayoutComponents.reduce(constraints) { (combinedConstraints, layoutComponent) -> [LayoutConstraint] in
            switch layoutComponent {
            case .uistackview(let layoutComponent):
                return combinedConstraints + layoutComponent.allConstraints()
            case .uiview(let layoutComponent):
                return combinedConstraints + layoutComponent.allConstraints()
            case .layoutGuide(let layoutComponent):
                return combinedConstraints + layoutComponent.allConstraints()
            }
        }
    }
    
    func allSubviews() -> [UIView] {
        return sublayoutComponents.reduce(subviews) { (subviews, layoutComponent) -> [UIView] in
            switch layoutComponent {
            case .uistackview(let layoutComponent):
                return subviews + layoutComponent.allSubviews()
            case .uiview(let layoutComponent):
                return subviews + layoutComponent.allSubviews()
            case .layoutGuide(_):
                return subviews
            }
        }
    }
    
    func allArrangedSubviews() -> [UIView: UIStackViewLayoutComponentType] {
        return sublayoutComponents.reduce([:]) { (arrangedSubviews, layoutComponent) -> [UIView: UIStackViewLayoutComponentType] in
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
    
    func allLayoutGuides() -> [UILayoutGuide: UIView] {
        let layoutGuideDict = layoutGuides.reduce([:]) { (dict, layoutGuide) -> [UILayoutGuide: UIView] in
            var mutableDict = dict
            mutableDict[layoutGuide] = view
            return mutableDict
        }
        
        return sublayoutComponents.reduce(layoutGuideDict) { (dict, layoutComponent) -> [UILayoutGuide: UIView] in
            switch layoutComponent {
            case .uistackview(let layoutComponent):
                return dict.merging(layoutComponent.allLayoutGuides(), uniquingKeysWith: { a,b in  return a })
            case .uiview(let layoutComponent):
                return dict.merging(layoutComponent.allLayoutGuides(), uniquingKeysWith: { a,b in  return a })
            case .layoutGuide(_):
                return dict
            }
        }
    }
}
