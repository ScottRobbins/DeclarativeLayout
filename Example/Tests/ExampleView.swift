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
    
    private let views1 = Array(repeating: UIView(), count: 1000)
    private let views2 = Array(repeating: UIView(), count: 1000)
    
    func layoutAndConfigure(with viewLayout: ViewLayout<ExampleView>) {
        
        switch currentState {
        case .initial: layout(with: viewLayout, views: views1, constant: 0)
        case .newConstraints: layoutNewConstraints(with: viewLayout, views: views1, constant: 0)
        case .newViewsAndConstraints: layout(with: viewLayout, views: views2, constant: 0)
        case .changedConstraints: layout(with: viewLayout, views: views1, constant: 10)
        }
    }
    
    private func layout(with viewLayout: ViewLayout<ExampleView>, views: [UIView], constant: CGFloat) {
        
        viewLayout.updateLayoutTo { (component, view) in
            
            component.addView(views[0]) { (component, view, superview) in
                
                component.activate([
                    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant),
                    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: constant),
                    view.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant),
                    view.heightAnchor.constraint(equalToConstant: 10),
                ])
            }
            
            let viewsSlice = views.dropFirst().dropLast()
            for viewTuple in viewsSlice.enumerated() {
                
                component.addView(viewTuple.element) { (component, view, superview) in
                    
                    component.activate([
                        view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant),
                        view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: constant),
                        view.topAnchor.constraint(equalTo: views[viewTuple.offset].bottomAnchor, constant: constant),
                        view.heightAnchor.constraint(equalToConstant: 10),
                    ])
                }
            }
            
            component.addView(views.last!) { (component, view, superview) in
                
                component.activate([
                    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant),
                    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: constant),
                    view.topAnchor.constraint(equalTo: views[views.count - 2].bottomAnchor, constant: constant),
                    view.heightAnchor.constraint(equalToConstant: 10),
                    view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: constant),
                ])
            }
        }
    }
    
    private func layoutNewConstraints(with viewLayout: ViewLayout<ExampleView>, views: [UIView], constant: CGFloat) {
        
        viewLayout.updateLayoutTo { (component, view) in
            
            component.addView(views[0]) { (component, view, superview) in
                
                component.activate([
                    view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                    view.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant),
                    view.heightAnchor.constraint(equalToConstant: 10),
                ])
            }
            
            let viewsSlice = views.dropFirst().dropLast()
            for viewTuple in viewsSlice.enumerated() {
                
                component.addView(viewTuple.element) { (component, view, superview) in
                    
                    component.activate([
                        view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                        view.topAnchor.constraint(equalTo: views[viewTuple.offset].bottomAnchor, constant: constant),
                        view.heightAnchor.constraint(equalToConstant: 10),
                    ])
                }
            }
            
            component.addView(views.last!) { (component, view, superview) in
                
                component.activate([
                    view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                    view.topAnchor.constraint(equalTo: views[views.count - 2].bottomAnchor, constant: constant),
                    view.heightAnchor.constraint(equalToConstant: 10),
                    view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: constant),
                ])
            }
        }
    }
}
