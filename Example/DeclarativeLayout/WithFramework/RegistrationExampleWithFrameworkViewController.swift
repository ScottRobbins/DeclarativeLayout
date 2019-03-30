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
        
        viewLayout.updateLayoutTo { (component) in
            component.stackView(self.stackView) { (component) in
                component.ownedView.axis = .vertical
                component.layout {[ // $0 is component's view, $1 is its superview
                    $0.topAnchor.constraint(equalTo: $1.safeAreaLayoutGuide.topAnchor, constant: 35),
                    $0.leadingAnchor.constraint(equalTo: $1.leadingAnchor, constant: 20),
                    $0.trailingAnchor.constraint(equalTo: $1.trailingAnchor, constant: -20),
                ]}
                
                component.arrangedView(self.registerOrSignInSegmentedControl)
                component.space(30)
                component.arrangedView(self.headerLabel)
                component.space(20)
                component.arrangedView { (component) in
                    component.view(self.emailLabel) { (component) in
                        component.layout {[
                            $0.topAnchor.constraint(greaterThanOrEqualTo: $1.topAnchor),
                            $0.leadingAnchor.constraint(equalTo: $1.leadingAnchor),
                            $0.trailingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor, constant: -20),
                            $0.bottomAnchor.constraint(lessThanOrEqualTo: $1.bottomAnchor),
                            $0.centerYAnchor.constraint(equalTo: $1.centerYAnchor),
                        ]}
                    }
                    
                    component.view(self.emailTextField) { (component) in
                        component.layout {[
                            $0.topAnchor.constraint(greaterThanOrEqualTo: $1.topAnchor),
                            $0.trailingAnchor.constraint(equalTo: $1.trailingAnchor),
                            $0.bottomAnchor.constraint(lessThanOrEqualTo: $1.bottomAnchor),
                            $0.centerYAnchor.constraint(equalTo: $1.centerYAnchor),
                        ]}
                    }
                }
                
                component.space(40)
                component.arrangedView { (component) in
                    component.view(self.passwordLabel) { (component) in
                        component.layout {[
                            $0.topAnchor.constraint(greaterThanOrEqualTo: $1.topAnchor),
                            $0.leadingAnchor.constraint(equalTo: $1.leadingAnchor),
                            $0.trailingAnchor.constraint(equalTo: self.passwordTextField.leadingAnchor, constant: -20),
                            $0.bottomAnchor.constraint(lessThanOrEqualTo: $1.bottomAnchor),
                            $0.centerYAnchor.constraint(equalTo: $1.centerYAnchor),
                        ]}
                    }
                    
                    component.view(self.passwordTextField) { (component) in
                        component.layout {[
                            $0.topAnchor.constraint(greaterThanOrEqualTo: $1.topAnchor),
                            $0.trailingAnchor.constraint(equalTo: $1.trailingAnchor),
                            $0.bottomAnchor.constraint(lessThanOrEqualTo: $1.bottomAnchor),
                            $0.centerYAnchor.constraint(equalTo: $1.centerYAnchor),
                            $0.leadingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor),
                        ]}
                    }
                }
                
                component.space(40)
                component.arrangedView(self.submitButton)
            }
            
            component.view(self.forgotMyPasswordButton) { (component) in
                component.layout {[
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
