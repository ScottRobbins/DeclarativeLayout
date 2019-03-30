import UIKit
import DeclarativeLayout

class READMEExample: UIViewController {

    private lazy var viewLayout = ViewLayout(view: view)
    private lazy var stackView = UIStackView()
    private lazy var redView = UIView()
    private lazy var orangeView = UIView()
    private lazy var yellowView = UIView()
    private lazy var greenView = UIView()
    private lazy var blueView = UIView()
    private lazy var purpleView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

         title = "README Example"

        layoutAllViews()
        configureAllViews()
        animationLoop()
    }

    private func animationLoop() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { timer in
            UIView.animate(withDuration: 1.0, animations: {
                self.layoutAllViews()
                self.stackView.layoutIfNeeded()
            })
        })
    }

    private func layoutAllViews() {
        let views = [redView,
                     orangeView,
                     yellowView,
                     greenView,
                     blueView,
                     purpleView]

        viewLayout.updateLayoutTo { (component) in
            component.addStackView(self.stackView) { (component) in
                component.activate(
                    component.ownedView.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor),
                    component.ownedView.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor),
                    component.ownedView.topAnchor.constraint(equalTo: component.superview.safeAreaLayoutGuide.topAnchor,
                                                        constant: 35)
                )

                component.ownedView.axis = .vertical
                for view in views.shuffled() {
                    component.addArrangedView(view) { (component) in
                        let random = CGFloat(Int.random(in: 20..<100))
                        component.activate(
                            component.ownedView.heightAnchor.constraint(equalToConstant: random)
                        )
                    }
                    component.addSpace(CGFloat(Int.random(in: 0..<50)))
                }
            }
        }
    }

    // Don't worry about this below here

    private func configureAllViews() {
        view.backgroundColor = .white
        redView.backgroundColor = .red
        orangeView.backgroundColor = .orange
        yellowView.backgroundColor = .yellow
        greenView.backgroundColor = .green
        blueView.backgroundColor = .blue
        purpleView.backgroundColor = .purple

        redView.accessibilityLabel = "red"
        orangeView.accessibilityLabel = "orange"
        yellowView.accessibilityLabel = "yellow"
        greenView.accessibilityLabel = "green"
        blueView.accessibilityLabel = "blue"
        purpleView.accessibilityLabel = "purple"
        redView.accessibilityLabel = "red"
    }
}
