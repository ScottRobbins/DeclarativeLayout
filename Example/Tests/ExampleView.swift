import UIKit
import DeclarativeLayout

class ExampleView: UIView {
    
    enum State {
        case initial
        case newConstraints
        case newViewsAndConstraints
        case changedConstraints
    }
    
    var currentState: State = .initial
    
    private let views1: [UIView]
    private let views2: [UIView]
    
    init(numberOfViews: Int) {
        views1 = Array(repeating: UIView(), count: numberOfViews)
        views2 = Array(repeating: UIView(), count: numberOfViews)
        
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutAndConfigure(with viewLayout: ViewLayout<ExampleView>) {
        
        switch currentState {
        case .initial: layout(with: viewLayout, views: views1, constant: 0)
        case .newConstraints: layoutNewConstraints(with: viewLayout, views: views1, constant: 0)
        case .newViewsAndConstraints: layout(with: viewLayout, views: views2, constant: 0)
        case .changedConstraints: layout(with: viewLayout, views: views1, constant: 10)
        }
    }
    
    private func layout(with viewLayout: ViewLayout<ExampleView>, views: [UIView], constant: CGFloat) {
        
        viewLayout.updateLayoutTo { (component) in
            
            component.view(views[0]) { (component) in
                
                component.constraints([
                    component.ownedView.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: constant),
                    component.ownedView.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: constant),
                    component.ownedView.topAnchor.constraint(equalTo: component.superview.topAnchor, constant: constant),
                    component.ownedView.heightAnchor.constraint(equalToConstant: 10),
                    ])
            }
            
            let viewsSlice = views.dropFirst().dropLast()
            for viewTuple in viewsSlice.enumerated() {
                
                component.view(viewTuple.element) { (component) in
                    
                    component.constraints([
                        component.ownedView.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: constant),
                        component.ownedView.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: constant),
                        component.ownedView.topAnchor.constraint(equalTo: views[viewTuple.offset].bottomAnchor, constant: constant),
                        component.ownedView.heightAnchor.constraint(equalToConstant: 10),
                        ])
                }
            }
            
            component.view(views.last!) { (component) in
                
                component.constraints([
                    component.ownedView.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: constant),
                    component.ownedView.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: constant),
                    component.ownedView.topAnchor.constraint(equalTo: views[views.count - 2].bottomAnchor, constant: constant),
                    component.ownedView.heightAnchor.constraint(equalToConstant: 10),
                    component.ownedView.bottomAnchor.constraint(equalTo: component.superview.bottomAnchor, constant: constant),
                    ])
            }
        }
    }
    
    private func layoutNewConstraints(with viewLayout: ViewLayout<ExampleView>, views: [UIView], constant: CGFloat) {
        
        viewLayout.updateLayoutTo { (component) in
            
            component.view(views[0]) { (component) in
                
                component.constraints([
                    component.ownedView.centerXAnchor.constraint(equalTo: component.superview.centerXAnchor),
                    component.ownedView.topAnchor.constraint(equalTo: component.superview.topAnchor, constant: constant),
                    component.ownedView.heightAnchor.constraint(equalToConstant: 10),
                    ])
            }
            
            let viewsSlice = views.dropFirst().dropLast()
            for viewTuple in viewsSlice.enumerated() {
                
                component.view(viewTuple.element) { (component) in
                    
                    component.constraints([
                        component.ownedView.centerXAnchor.constraint(equalTo: component.superview.centerXAnchor),
                        component.ownedView.topAnchor.constraint(equalTo: views[viewTuple.offset].bottomAnchor, constant: constant),
                        component.ownedView.heightAnchor.constraint(equalToConstant: 10),
                        ])
                }
            }
            
            component.view(views.last!) { (component) in
                
                component.constraints([
                    component.ownedView.centerXAnchor.constraint(equalTo: component.superview.centerXAnchor),
                    component.ownedView.topAnchor.constraint(equalTo: views[views.count - 2].bottomAnchor, constant: constant),
                    component.ownedView.heightAnchor.constraint(equalToConstant: 10),
                    component.ownedView.bottomAnchor.constraint(equalTo: component.superview.bottomAnchor, constant: constant),
                    ])
            }
        }
    }
}
