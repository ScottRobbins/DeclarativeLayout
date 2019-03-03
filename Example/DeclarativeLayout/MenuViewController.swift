import UIKit
import DeclarativeLayout

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum Row {
        case quickStart
        case registrationWithoutFramework
        case registrationWithFramework
        case registrationWithFrameworkAndAnchorage
        case registrationWithFrameworkAndSnapkit
        
        static var allRows: [Row] {
            return [
                .quickStart,
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
                component.activate([
                    component.view.topAnchor.constraint(equalTo: component.superview.topAnchor),
                    component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor),
                    component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor),
                    component.view.bottomAnchor.constraint(equalTo: component.superview.bottomAnchor),
                ])
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
        case .quickStart:
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
        case .quickStart:
            navigationController?.pushViewController(QuickStartViewController(), animated: true)
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
