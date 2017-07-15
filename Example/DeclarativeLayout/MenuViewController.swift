import UIKit
import DeclarativeLayout

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum Row {
        case quickStart
        case registrationWithoutFramework
        case registrationWithFramework
        
        static var allRows: [Row] {
            return [.quickStart, .registrationWithoutFramework, .registrationWithFramework]
        }
    }
    
    private let tableView = UITableView()
    private var viewLayout: ViewLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLayout = ViewLayout(view: view)
        title = "Menu"
        tableView.rowHeight = UITableViewAutomaticDimension
        layoutAllViews()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func layoutAllViews() {
        
        viewLayout.updateLayoutTo { (layout) in
            
            layout.add(tableView) { (layout) in
                
                layout.activate([
                    layout.view.topAnchor.constraint(equalTo: layout.superview.topAnchor),
                    layout.view.leadingAnchor.constraint(equalTo: layout.superview.leadingAnchor),
                    layout.view.trailingAnchor.constraint(equalTo: layout.superview.trailingAnchor),
                    layout.view.bottomAnchor.constraint(equalTo: layout.superview.bottomAnchor),
                ])
            }
        }
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
        }
    }
}
