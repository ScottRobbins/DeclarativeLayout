import UIKit
import DeclarativeLayout

class MenuViewController: UIViewController {
    
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        configureTableView()
    }
    
    private func layout() {
        
        view.updateLayoutTo { (layout) in
            
            layout.add(tableView) { (layout) in
                
                layout.activate([
                    layout.view.leadingAnchor.constraint(equalTo: layout.superview.leadingAnchor),
                    layout.view.trailingAnchor.constraint(equalTo: layout.superview.trailingAnchor),
                    layout.view.topAnchor.constraint(equalTo: layout.superview.topAnchor),
                    layout.view.bottomAnchor.constraint(equalTo: layout.superview.bottomAnchor),
                ])
            }
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
