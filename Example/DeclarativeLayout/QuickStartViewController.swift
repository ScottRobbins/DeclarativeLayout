import DeclarativeLayout

class QuickStartViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var viewLayout = ViewLayout(view: view)
    private let headerLabel = UILabel() 
    private let stackView = UIStackView()
    private let redBox = UIView()
    private let blueBox = UIView()
    private let greenBox = UIView()
    
    enum LayoutType {
        case layout1
        case layout2
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Quick Start"
        
        layoutAllViews(withLayoutType: .layout1)
        configureAllViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 2) {
                self.layoutAllViews(withLayoutType: .layout2)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Layout
    
    private func layoutAllViews(withLayoutType layoutType: LayoutType) {
        
        viewLayout.updateLayoutTo { (component) in
            component.addView(self.headerLabel) { (component) in
                // view is the headerLabel, superview is the VC's view
                component.activate([
                    component.view.topAnchor.constraint(equalTo: component.superview.safeAreaLayoutGuide.topAnchor, constant: 35),
                    component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
                    component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: -20),
                ])
            }
            
            component.addStackView(self.stackView) { (component) in
                component.view.axis = .vertical
                component.activate([
                    component.view.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 20),
                    component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
                    component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: -20),
                ])
                
                component.addArrangedView(self.redBox) { (component) in
                    component.activate([
                        component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor),
                        component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor),
                    ])
                    
                    if layoutType == .layout1 { // In layout1 the blue box will be inside of the red box
                        component.addView(self.blueBox) { (component) in
                            component.activate([
                                component.view.topAnchor.constraint(equalTo: component.superview.topAnchor, constant: 20),
                                component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
                                component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: -20),
                                component.view.bottomAnchor.constraint(equalTo: component.superview.bottomAnchor, constant: -20),
                                component.view.heightAnchor.constraint(equalToConstant: 100)
                            ])
                        }
                    } else {
                        component.activate([
                            component.view.heightAnchor.constraint(equalToConstant: 200)
                        ])
                    }
                }
                
                if layoutType == .layout1 { // layout1 has a green box, layout 2 does not
                    component.addArrangedView(self.greenBox) { (component) in
                        component.activate([
                            component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor),
                            component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor),
                            component.view.heightAnchor.constraint(equalToConstant: 300),
                        ])
                    }
                }
                
                if layoutType == .layout2 { // In layout2 the blue box will be below the red box
                    component.addArrangedView(self.blueBox) { (component) in
                        component.activate([
                            component.view.heightAnchor.constraint(equalToConstant: 100)
                        ])
                    }
                }
            }
        }
    }
    
    // Don't worry about this below here
    
    private func configureAllViews() {
        view.backgroundColor = .white
        
        headerLabel.font = .systemFont(ofSize: 25)
        headerLabel.numberOfLines = 0
        headerLabel.lineBreakMode = .byWordWrapping
        headerLabel.text = "This is a quick start example"
        
        redBox.backgroundColor = .red
        blueBox.backgroundColor = .blue
        greenBox.backgroundColor = .green
    }
}
