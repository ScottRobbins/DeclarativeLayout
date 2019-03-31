import UIKit
import DeclarativeLayout

// MARK: - Layout extensions

private extension UIViewLayoutComponent {
    func layout(closure: (T) -> [NSLayoutConstraint]) {
        constraints(closure(ownedView))
    }
}

private extension UIViewSubviewLayoutComponent {
    func layout(closure: (T, R) -> [NSLayoutConstraint]) {
        constraints(closure(ownedView, superview))
    }
}

private extension UIStackViewSubviewLayoutComponent {
    func layout(closure: (T, R) -> [NSLayoutConstraint]) {
        constraints(closure(ownedView, superview))
    }
}

private extension UILayoutGuideComponent {
    func layout(closure: (R) -> [NSLayoutConstraint]) {
        constraints(closure(owningView))
    }
}

class RegistrationExampleWithFrameworkViewController: UIViewController {
    
    private lazy var viewLayout = ViewLayout(view: view)
    private let registerOrSignInSegmentedControl = UISegmentedControl()
    private let headerLabel = UILabel()
    private let stackView = UIStackView()
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    private let submitButton = UIButton()
    private let forgotMyPasswordButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "With Framework"
        
        layoutAllViews()
        configureAllViews()
    }
    
    private func layoutAllViews() {
        
        viewLayout.updateLayoutTo { (com) in
            com.stackView(self.stackView) { (com) in
                com.ownedView.axis = .vertical
                com.layout {[ // $0 is component's view, $1 is its superview
                    $0.topAnchor.constraint(equalTo: $1.safeAreaLayoutGuide.topAnchor, constant: 35),
                    $0.leadingAnchor.constraint(equalTo: $1.leadingAnchor, constant: 20),
                    $0.trailingAnchor.constraint(equalTo: $1.trailingAnchor, constant: -20),
                ]}
                
                com.arrangedView(self.registerOrSignInSegmentedControl)
                com.space(30)
                com.arrangedView(self.headerLabel)
                com.space(20)
                com.arrangedView { (com) in
                    com.view(self.emailLabel) { (com) in
                        com.layout {[
                            $0.topAnchor.constraint(greaterThanOrEqualTo: $1.topAnchor),
                            $0.leadingAnchor.constraint(equalTo: $1.leadingAnchor),
                            $0.trailingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor, constant: -20),
                            $0.bottomAnchor.constraint(lessThanOrEqualTo: $1.bottomAnchor),
                            $0.centerYAnchor.constraint(equalTo: $1.centerYAnchor),
                        ]}
                    }
                    
                    com.view(self.emailTextField) { (com) in
                        com.layout {[
                            $0.topAnchor.constraint(greaterThanOrEqualTo: $1.topAnchor),
                            $0.trailingAnchor.constraint(equalTo: $1.trailingAnchor),
                            $0.bottomAnchor.constraint(lessThanOrEqualTo: $1.bottomAnchor),
                            $0.centerYAnchor.constraint(equalTo: $1.centerYAnchor),
                        ]}
                    }
                }
                
                com.space(40)
                com.arrangedView { (com) in
                    com.view(self.passwordLabel) { (com) in
                        com.layout {[
                            $0.topAnchor.constraint(greaterThanOrEqualTo: $1.topAnchor),
                            $0.leadingAnchor.constraint(equalTo: $1.leadingAnchor),
                            $0.trailingAnchor.constraint(equalTo: self.passwordTextField.leadingAnchor, constant: -20),
                            $0.bottomAnchor.constraint(lessThanOrEqualTo: $1.bottomAnchor),
                            $0.centerYAnchor.constraint(equalTo: $1.centerYAnchor),
                        ]}
                    }
                    
                    com.view(self.passwordTextField) { (com) in
                        com.layout {[
                            $0.topAnchor.constraint(greaterThanOrEqualTo: $1.topAnchor),
                            $0.trailingAnchor.constraint(equalTo: $1.trailingAnchor),
                            $0.bottomAnchor.constraint(lessThanOrEqualTo: $1.bottomAnchor),
                            $0.centerYAnchor.constraint(equalTo: $1.centerYAnchor),
                            $0.leadingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor),
                        ]}
                    }
                }
                
                com.space(40)
                com.arrangedView(self.submitButton)
            }
            
            com.view(self.forgotMyPasswordButton) { (com) in
                com.layout {[
                    $0.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 20),
                    $0.centerXAnchor.constraint(equalTo: $1.centerXAnchor),
                ]}
            }
        }
    }
    
    // Don't worry about this below here
    
    private func configureAllViews() {
        view.backgroundColor = .white
        registerOrSignInSegmentedControl.insertSegment(withTitle: "Register", at: 0, animated: false)
        registerOrSignInSegmentedControl.insertSegment(withTitle: "Sign In", at: 1, animated: false)
        
        if registerOrSignInSegmentedControl.selectedSegmentIndex == -1 {
            registerOrSignInSegmentedControl.selectedSegmentIndex = 0
        }
        
        headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        if registerOrSignInSegmentedControl.selectedSegmentIndex == 0 {
            headerLabel.text = "Register"
        } else {
            headerLabel.text = "Sign In"
        }
        
        stackView.axis = .vertical
        
        emailLabel.text = "Email"
        emailTextField.placeholder = "example@example.com"
        if #available(iOS 10.0, *) {
            emailTextField.textContentType = .emailAddress
        }
        emailTextField.layer.borderColor = UIColor.blue.cgColor
        emailTextField.layer.borderWidth = 1
        emailTextField.textAlignment = .center
        emailTextField.isUserInteractionEnabled = false
        
        passwordLabel.text = "Password"
        passwordTextField.placeholder = "secure password here"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.borderColor = UIColor.blue.cgColor
        passwordTextField.layer.borderWidth = 1
        passwordTextField.textAlignment = .center
        passwordTextField.isUserInteractionEnabled = false
        
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = UIColor.blue
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 10
        submitButton.clipsToBounds = true
        submitButton.titleLabel?.textAlignment = .center
        
        forgotMyPasswordButton.setTitle("forgot your password?", for: .normal)
        forgotMyPasswordButton.setTitleColor(.blue, for: .normal)
    }
}
