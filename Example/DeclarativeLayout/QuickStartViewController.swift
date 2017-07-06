import DeclarativeLayout

class QuickStartViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewLayout: ViewLayout!
    
    private let headerLabel = UILabel()
    private let stackView = UIStackView()
    private let redBox = UIView()
    private let blueBox = UIView()
    private let greenBox = UIView()
    
    enum LayoutType {
        case layout1
        case layout2
    }
    
    private var layoutType: LayoutType = .layout1
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Quick Start"
        
        viewLayout = ViewLayout(view: view)
        layoutAllViews()
        configureAllViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 2) {
                self.layoutType = .layout2
                self.layoutAllViews()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Layout
    
    private func layoutAllViews() {
        
        viewLayout.updateLayoutTo { (layout) in
            
            layout.add(self.headerLabel) { (layout) in
                
                // layout.view is the headerLabel
                // layout.superview is the VC's view
                layout.activate([
                    layout.view.topAnchor.constraint(equalTo: layout.superview.topAnchor, constant: 75),
                    layout.view.leadingAnchor.constraint(equalTo: layout.superview.leadingAnchor, constant: 20),
                    layout.view.trailingAnchor.constraint(equalTo: layout.superview.trailingAnchor, constant: -20),
                ])
            }
            
            layout.addStack(self.stackView) { (layout) in
                
                layout.activate([
                    layout.view.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 20),
                    layout.view.leadingAnchor.constraint(equalTo: layout.superview.leadingAnchor, constant: 20),
                    layout.view.trailingAnchor.constraint(equalTo: layout.superview.trailingAnchor, constant: -20),
                ])
                
                layout.addArranged(self.redBox) { (layout) in
                    
                    layout.activate([
                        layout.view.leadingAnchor.constraint(equalTo: layout.superview.leadingAnchor),
                        layout.view.trailingAnchor.constraint(equalTo: layout.superview.trailingAnchor),
                    ])
                    
                    if self.layoutType == .layout1 { // In layout1 the blue box will be inside of the red box
                        layout.add(self.blueBox) { (layout) in
                            
                            layout.activate([
                                layout.view.topAnchor.constraint(equalTo: layout.superview.topAnchor, constant: 20),
                                layout.view.leadingAnchor.constraint(equalTo: layout.superview.leadingAnchor, constant: 20),
                                layout.view.trailingAnchor.constraint(equalTo: layout.superview.trailingAnchor, constant: -20),
                                layout.view.bottomAnchor.constraint(equalTo: layout.superview.bottomAnchor, constant: -20),
                                layout.view.heightAnchor.constraint(equalToConstant: 100)
                            ])
                        }
                    } else {
                        layout.activate([
                            layout.view.heightAnchor.constraint(equalToConstant: 200)
                        ])
                    }
                }
                
                if self.layoutType == .layout1 { // layout1 has a green box, layout 2 does not
                    layout.addArranged(self.greenBox) { (layout) in
                        
                        layout.activate([
                            layout.view.leadingAnchor.constraint(equalTo: layout.superview.leadingAnchor),
                            layout.view.trailingAnchor.constraint(equalTo: layout.superview.trailingAnchor),
                        ])
                        
                        layout.activate([
                            layout.view.heightAnchor.constraint(equalToConstant: 300),
                        ])
                    }
                }
                
                if self.layoutType == .layout2 { // In layout2 the blue box will be below the red box
                    layout.addArranged(self.blueBox) { (layout) in
                        
                        layout.activate([
                            layout.view.heightAnchor.constraint(equalToConstant: 100)
                        ])
                    }
                }
            }
        }
    }
    
    // MARK: - Configuration
    
    private func configureAllViews() {
        headerLabel.font = .systemFont(ofSize: 25)
        headerLabel.numberOfLines = 0
        headerLabel.lineBreakMode = .byWordWrapping
        headerLabel.text = "This is a quick start example"
        
        redBox.backgroundColor = .red
        blueBox.backgroundColor = .blue
        greenBox.backgroundColor = .green
        
        stackView.axis = .vertical
    }
}
