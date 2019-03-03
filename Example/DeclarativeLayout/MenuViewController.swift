import UIKit
import DeclarativeLayout

// MARK: - Layout extensions

private extension UIViewLayoutComponent {
    func layout(closure: (T) -> [NSLayoutConstraint]) {
        activate(closure(view))
    }
}

private extension UIViewSubviewLayoutComponent {
    func layout(closure: (T, R) -> [NSLayoutConstraint]) {
        activate(closure(view, superview))
    }
}

private extension UIStackViewSubviewLayoutComponent {
    func layout(closure: (T, R) -> [NSLayoutConstraint]) {
        activate(closure(view, superview))
    }
}

private extension UILayoutGuideComponent {
    func layout(closure: (R) -> [NSLayoutConstraint]) {
        activate(closure(owningView))
    }
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum Row {
        case readme
        case registrationWithoutFramework
        case registrationWithFramework
        case registrationWithFrameworkAndAnchorage
        case registrationWithFrameworkAndSnapkit
        
        static var allRows: [Row] {
            return [
                .readme,
                .registrationWithoutFramework,
                .registrationWithFramework,
                .registrationWithFrameworkAndAnchorage,
                .registrationWithFrameworkAndSnapkit,
            ]
        }
    }
    
    private let tableView = UITableView()
    private lazy var viewLayout = ViewLayout(view: view)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Menu"
        
        layoutAllViews()
        configureAllViews()
    }
    
    private func layoutAllViews() {
        viewLayout.updateLayoutTo { (component) in
            component.addView(tableView) { (component) in
                component.layout {[
                    $0.topAnchor.constraint(equalTo: $1.topAnchor),
                    $0.leadingAnchor.constraint(equalTo: $1.leadingAnchor),
                    $0.trailingAnchor.constraint(equalTo: $1.trailingAnchor),
                    $0.bottomAnchor.constraint(equalTo: $1.bottomAnchor),
                ]}
            }
        }
    }
    
    // Don't worry about this below here
    
    private func configureAllViews() {
        view.backgroundColor = .white
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        switch Row.allRows[indexPath.row] {
        case .readme:
            cell.textLabel?.text = "Quick Start Example"
        case .registrationWithoutFramework:
            cell.textLabel?.text = "Registration Screen Without Framework"
        case .registrationWithFramework:
            cell.textLabel?.text = "Registration Screen With Framework"
        case .registrationWithFrameworkAndAnchorage:
            cell.textLabel?.text = "Registration Screen With Framework and Anchorage"
        case .registrationWithFrameworkAndSnapkit:
            cell.textLabel?.text = "Registration Screen With Framework and SnapKit"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Row.allRows[indexPath.row] {
        case .readme:
            navigationController?.pushViewController(READMEExample(), animated: true)
        case .registrationWithoutFramework:
            navigationController?.pushViewController(RegistrationWithoutFrameworkViewController(), animated: true)
        case .registrationWithFramework:
            navigationController?.pushViewController(RegistrationExampleWithFrameworkViewController(), animated: true)
        case .registrationWithFrameworkAndAnchorage:
            navigationController?.pushViewController(RegistrationExampleWithFrameworkAndAnchorageViewController(), animated: true)
        case .registrationWithFrameworkAndSnapkit:
            navigationController?.pushViewController(RegistrationExampleWithFrameworkAndSnapKitViewController(), animated: true)
        }
    }
}
