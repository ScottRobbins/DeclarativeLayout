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
    public final unowned let ownedView: T
    let cachedLayoutObjectStore: CachedLayoutObjectStore
    private(set) var subviews = [UIView]()
    private(set) var sublayoutComponents = [LayoutComponentType]()
    private(set) var layoutGuides = [UILayoutGuide]()
    private var constraints = [LayoutConstraint]()

    init(view: T, cachedLayoutObjectStore: CachedLayoutObjectStore) {
        ownedView = view
        self.cachedLayoutObjectStore = cachedLayoutObjectStore
    }

    /**
     Add a subview to the component's view.

     - parameters:
        - identifier: An identifier to give for this view.
        - layoutClosure: A closure that will define the layout component for the subview.
     - returns: The layout component for the subview (the same one passed into the optional closure)

     * This will just add a regular UIView (`UIView()`).
     * Using an identifier will let you refer to the same
     created instance of a `UIView` in subsequent layout updates.
     */
    @discardableResult public func view(identifier: String,
                                        layoutClosure: ((UIViewSubviewLayoutComponent<UIView, T>) -> Void)? = nil)
        -> UIViewSubviewLayoutComponent<UIView, T> {
        if let _view = cachedLayoutObjectStore.viewStorage[identifier] {
            return view(_view, layoutClosure: layoutClosure)
        } else {
            let _view = UIView()
            cachedLayoutObjectStore.viewStorage[identifier] = _view
            return view(_view, layoutClosure: layoutClosure)
        }
    }

    /**
     Add a subview to the component's view.

     - parameters:
         - layoutClosure: A closure that will define the layout component for the subview.
     - returns: The layout component for the subview (the same one passed into the optional closure)

     * This will just add a regular UIView (`UIView()`).
     * If you are calling `updateLayoutTo` more than once, you should not use this as it will cause
     unnecessary layout recalculations to occur.
     Consider using `view(identifier:layoutClosure:)` instead for that situation.
     */
    @discardableResult public func view(layoutClosure: ((UIViewSubviewLayoutComponent<UIView, T>) -> Void)? = nil) -> UIViewSubviewLayoutComponent<UIView, T> {
        return view(UIView(), layoutClosure: layoutClosure)
    }

    /**
     Add a subview to the component's view.

     - parameters:
        - subview: The view you would like to add as a subview to the component's view.
        - layoutClosure: A closure that will define the layout component for the subview.
     - returns: The layout component for the subview (the same one passed into the optional closure)
     */
    @discardableResult public func view<R>(_ subview: R,
                                           layoutClosure: ((UIViewSubviewLayoutComponent<R, T>) -> Void)? = nil) -> UIViewSubviewLayoutComponent<R, T> {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let subLayoutComponent = UIViewSubviewLayoutComponent(view: subview,
                                                              superview: ownedView,
                                                              cachedLayoutObjectStore: cachedLayoutObjectStore)

        sublayoutComponents.append(.uiview(layout: subLayoutComponent))
        subviews.append(subview)

        layoutClosure?(subLayoutComponent)
        return subLayoutComponent
    }

    /**
     Add a subview, that is a stack view, to the component's view.

     - parameters:
        - identifier: An identifier to give for this view.
        - layoutClosure: A closure that will define the layout component for the subview.
     - returns: The layout component for the subview (the same one passed into the optional closure)

     * This will just add a regular UIStackView (`UIStackView()`).
     * Using an identifier will let you refer to the same created instance of a `UIStackView` in subsequent layout updates.
     * This will allow you to, in the layout closure, add arranged views for the passed in stack view.
     */
    @discardableResult public func stackView(identifier: String,
                                             layoutClosure: ((UIStackViewSubviewLayoutComponent<UIStackView, T>)
                                                 -> Void)? = nil) -> UIStackViewSubviewLayoutComponent<UIStackView, T> {
        if let view = cachedLayoutObjectStore.stackViewStorage[identifier] {
            return stackView(view, layoutClosure: layoutClosure)
        } else {
            let view = UIStackView()
            cachedLayoutObjectStore.stackViewStorage[identifier] = view
            return stackView(view, layoutClosure: layoutClosure)
        }
    }

    /**
     Add a subview, that is a stack view, to the component's view.

     - parameters:
         - layoutClosure: A closure that will define the layout component for the subview.
     - returns: The layout component for the subview (the same one passed into the optional closure)

     * This will just add a regular UIStackView (`UIStackView()`).
     * This will allow you to, in the layout closure, add arranged views for the passed in stack view.
     * If you are calling `updateLayoutTo` more than once, you should not use this as it will cause
     unnecessary layout recalculations to occur.
     Consider using `addStackView(identifier:layoutClosure:)` instead for that situation.
     */
    @discardableResult public func stackView(layoutClosure: ((UIStackViewSubviewLayoutComponent<UIStackView, T>) -> Void)? = nil) -> UIStackViewSubviewLayoutComponent<UIStackView, T> {
        return stackView(UIStackView(), layoutClosure: layoutClosure)
    }

    /**
     Add a subview, that is a stack view, to the component's view.

     - parameters:
        - subview: The view you would like to add as a subview to the component's view.
        - layoutClosure: A closure that will define the layout component for the subview.
     - returns: The layout component for the subview (the same one passed into the optional closure)

     This will allow you to, in the layout closure, add arranged views for the passed in stack view.
     */
    @discardableResult public func stackView<R>(_ subview: R,
                                                layoutClosure: ((UIStackViewSubviewLayoutComponent<R, T>) -> Void)? = nil) -> UIStackViewSubviewLayoutComponent<R, T> {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let subLayoutComponent = UIStackViewSubviewLayoutComponent(view: subview,
                                                                   superview: ownedView,
                                                                   cachedLayoutObjectStore: cachedLayoutObjectStore)

        sublayoutComponents.append(.uistackview(layout: subLayoutComponent))
        subviews.append(subview)

        layoutClosure?(subLayoutComponent)
        return subLayoutComponent
    }

    /**
     Add a layout guide to the component's view.

     - parameters:
        - identifier: An identifier to give for this layout guide.
        - layoutClosure: A closure that will define the layout component for the layout guide.
     - returns: The layout component for the layout guide (the same one passed into the optional closure)

     * This will just add a regular UILayoutGuide (`UILayoutGuide()`).
     * Using an identifier will let you refer to the same created instance of a `UILayoutGuide`
     in subsequent layout updates.
     */
    @discardableResult public func layoutGuide(identifier: String,
                                               layoutClosure: ((UILayoutGuideComponent<T>) -> Void)? = nil)
        -> UILayoutGuideComponent<T> {
        if let _layoutGuide = cachedLayoutObjectStore.layoutGuideStorage[identifier] {
            return layoutGuide(_layoutGuide, layoutClosure: layoutClosure)
        } else {
            let _layoutGuide = UILayoutGuide()
            cachedLayoutObjectStore.layoutGuideStorage[identifier] = _layoutGuide
            return layoutGuide(_layoutGuide, layoutClosure: layoutClosure)
        }
    }

    /**
     Add a layout guide to the component's view.

     - parameters:
         - layoutClosure: A closure that will define the layout component for the layout guide.
     - returns: The layout component for the layout guide (the same one passed into the optional closure)

     * This will just add a regular UILayoutGuide (`UILayoutGuide()`).
     * If you are calling `updateLayoutTo` more than once, you should not use this as it will cause
     unnecessary layout recalculations to occur.
     Consider using `addLayoutGuide(identifier:layoutClosure:)` instead for that situation.
     */
    @discardableResult public func layoutGuide(layoutClosure: ((UILayoutGuideComponent<T>) -> Void)? = nil) -> UILayoutGuideComponent<T> {
        return layoutGuide(UILayoutGuide(), layoutClosure: layoutClosure)
    }

    /**
     Add a layout guide to the component's view.

     - parameters:
         - layoutGuide: The layout guide you would like ot add to the component's view.
         - layoutClosure: A closure that will define the layout component for the layout guide.
     - returns: The layout component for the layout guide (the same one passed into the optional closure)
     */
    @discardableResult public func layoutGuide(_ layoutGuide: UILayoutGuide,
                                               layoutClosure: ((UILayoutGuideComponent<T>) -> Void)? = nil) -> UILayoutGuideComponent<T> {
        let subLayoutComponent = UILayoutGuideComponent(layoutGuide: layoutGuide,
                                                        owningView: ownedView)
        sublayoutComponents.append(.layoutGuide(layout: subLayoutComponent))
        layoutGuides.append(layoutGuide)

        layoutClosure?(subLayoutComponent)
        return subLayoutComponent
    }

    /**
     Define constraints that should be activated

     - parameters:
        - constraints: Constraints to activate

     - important: Do not activate these constraints yourself, the framework will do that for you.
     If these constraints are activated at the wrong time it can cause your application to crash.
     */
    public func constraints(_ _constraints: NSLayoutConstraint...) {
        constraints(_constraints)
    }

    /**
     Define constraints that should be activated

     - parameters:
        - constraints: Constraints to activate

     - important: Do not activate these constraints yourself, the framework will do that for you.
     If these constraints are activated at the wrong time it can cause your application to crash.
     */
    public func constraints(_ _constraints: [NSLayoutConstraint]) {
        constraints += _constraints.map(LayoutConstraint.init(wrappedConstraint:))
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
            case .layoutGuide:
                return subviews
            }
        }
    }

    func allArrangedSubviews() -> [UIView: UIStackViewLayoutComponentType] {
        return sublayoutComponents.reduce([:]) { (arrangedSubviews, layoutComponent) -> [UIView: UIStackViewLayoutComponentType] in
            switch layoutComponent {
            case .uistackview(let layoutComponent):
                return arrangedSubviews.merging(layoutComponent.allArrangedSubviews()) { a, _ in a }
            case .uiview(let layoutComponent):
                return arrangedSubviews.merging(layoutComponent.allArrangedSubviews()) { a, _ in a }
            case .layoutGuide:
                return arrangedSubviews
            }
        }
    }

    func allLayoutGuides() -> [UILayoutGuide: UIView] {
        let layoutGuideDict = layoutGuides.reduce([:]) { (dict, layoutGuide) -> [UILayoutGuide: UIView] in
            var mutableDict = dict
            mutableDict[layoutGuide] = ownedView
            return mutableDict
        }

        return sublayoutComponents.reduce(layoutGuideDict) { (dict, layoutComponent) -> [UILayoutGuide: UIView] in
            switch layoutComponent {
            case .uistackview(let layoutComponent):
                return dict.merging(layoutComponent.allLayoutGuides()) { a, _ in a }
            case .uiview(let layoutComponent):
                return dict.merging(layoutComponent.allLayoutGuides()) { a, _ in a }
            case .layoutGuide:
                return dict
            }
        }
    }
}
