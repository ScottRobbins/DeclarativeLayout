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
        
        viewLayout.updateLayoutTo { (com) in
            
            com.view(views[0]) { (com) in
                
                com.constraints([
                    com.ownedView.leadingAnchor.constraint(equalTo: com.superview.leadingAnchor, constant: constant),
                    com.ownedView.trailingAnchor.constraint(equalTo: com.superview.trailingAnchor, constant: constant),
                    com.ownedView.topAnchor.constraint(equalTo: com.superview.topAnchor, constant: constant),
                    com.ownedView.heightAnchor.constraint(equalToConstant: 10),
                    ])
            }
            
            let viewsSlice = views.dropFirst().dropLast()
            for viewTuple in viewsSlice.enumerated() {
                
                com.view(viewTuple.element) { (com) in
                    
                    com.constraints([
                        com.ownedView.leadingAnchor.constraint(equalTo: com.superview.leadingAnchor, constant: constant),
                        com.ownedView.trailingAnchor.constraint(equalTo: com.superview.trailingAnchor, constant: constant),
                        com.ownedView.topAnchor.constraint(equalTo: views[viewTuple.offset].bottomAnchor, constant: constant),
                        com.ownedView.heightAnchor.constraint(equalToConstant: 10),
                        ])
                }
            }
            
            com.view(views.last!) { (com) in
                
                com.constraints([
                    com.ownedView.leadingAnchor.constraint(equalTo: com.superview.leadingAnchor, constant: constant),
                    com.ownedView.trailingAnchor.constraint(equalTo: com.superview.trailingAnchor, constant: constant),
                    com.ownedView.topAnchor.constraint(equalTo: views[views.count - 2].bottomAnchor, constant: constant),
                    com.ownedView.heightAnchor.constraint(equalToConstant: 10),
                    com.ownedView.bottomAnchor.constraint(equalTo: com.superview.bottomAnchor, constant: constant),
                    ])
            }
        }
    }
    
    private func layoutNewConstraints(with viewLayout: ViewLayout<ExampleView>, views: [UIView], constant: CGFloat) {
        
        viewLayout.updateLayoutTo { (com) in
            
            com.view(views[0]) { (com) in
                
                com.constraints([
                    com.ownedView.centerXAnchor.constraint(equalTo: com.superview.centerXAnchor),
                    com.ownedView.topAnchor.constraint(equalTo: com.superview.topAnchor, constant: constant),
                    com.ownedView.heightAnchor.constraint(equalToConstant: 10),
                    ])
            }
            
            let viewsSlice = views.dropFirst().dropLast()
            for viewTuple in viewsSlice.enumerated() {
                
                com.view(viewTuple.element) { (com) in
                    
                    com.constraints([
                        com.ownedView.centerXAnchor.constraint(equalTo: com.superview.centerXAnchor),
                        com.ownedView.topAnchor.constraint(equalTo: views[viewTuple.offset].bottomAnchor, constant: constant),
                        com.ownedView.heightAnchor.constraint(equalToConstant: 10),
                        ])
                }
            }
            
            com.view(views.last!) { (com) in
                
                com.constraints([
                    com.ownedView.centerXAnchor.constraint(equalTo: com.superview.centerXAnchor),
                    com.ownedView.topAnchor.constraint(equalTo: views[views.count - 2].bottomAnchor, constant: constant),
                    com.ownedView.heightAnchor.constraint(equalToConstant: 10),
                    com.ownedView.bottomAnchor.constraint(equalTo: com.superview.bottomAnchor, constant: constant),
                    ])
            }
        }
    }
}
