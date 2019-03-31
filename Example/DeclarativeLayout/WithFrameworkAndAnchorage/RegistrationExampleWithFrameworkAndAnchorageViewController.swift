import UIKit
import DeclarativeLayout
import Anchorage

// MARK: - Layout extensions for Anchorage

private extension UIViewLayoutComponent {
    func layout(closure: @escaping (T) -> Void) {
        let wrappingClosure: () -> Void = {
            closure(self.ownedView)
        }
        constraints(Anchorage.batch(active: false, closure: wrappingClosure))
    }
}

private extension UIViewSubviewLayoutComponent {
    func layout(closure: @escaping (T, R) -> Void) {
        let wrappingClosure: () -> Void = {
            closure(self.ownedView, self.superview)
        }
        constraints(Anchorage.batch(active: false, closure: wrappingClosure))
    }
}

private extension UIStackViewSubviewLayoutComponent {
    func layout(closure: @escaping (T, R) -> Void) {
        let wrappingClosure: () -> Void = {
            closure(self.ownedView, self.superview)
        }
        constraints(Anchorage.batch(active: false, closure: wrappingClosure))
    }
}

private extension UILayoutGuideComponent {
    func layout(closure: @escaping (R) -> Void) {
        let wrappingClosure: () -> Void = {
            closure(self.owningView)
        }
        constraints(Anchorage.batch(active: false, closure: wrappingClosure))
    }
}

// MARK: - Example

class RegistrationExampleWithFrameworkAndAnchorageViewController: UIViewController {
    
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
                com.layout { // $0 is component's view, $1 is superview
                    $0.topAnchor == $1.safeAreaLayoutGuide.topAnchor + 35
                    $0.leadingAnchor == $1.leadingAnchor + 20
                    $0.trailingAnchor == $1.trailingAnchor - 20
                }
                
                com.arrangedView(self.registerOrSignInSegmentedControl)
                com.space(30)
                com.arrangedView(self.headerLabel)
                com.space(20)
                com.arrangedView { (com) in
                    com.view(self.emailLabel) { (com) in
                        com.layout {
                            $0.topAnchor >= $1.topAnchor
                            $0.leadingAnchor == $1.leadingAnchor
                            $0.trailingAnchor == self.emailTextField.leadingAnchor - 20
                            $0.bottomAnchor <= $1.bottomAnchor
                            $0.centerYAnchor == $1.centerYAnchor
                        }
                    }
                    
                    com.view(self.emailTextField) { (com) in
                        com.layout {
                            $0.topAnchor >= $1.topAnchor
                            $0.trailingAnchor == $1.trailingAnchor
                            $0.bottomAnchor <= $1.bottomAnchor
                            $0.centerYAnchor == $1.centerYAnchor
                        }
                    }
                }
                
                com.space(40)
                com.arrangedView { (com) in
                    com.view(self.passwordLabel) { (com) in
                        com.layout {
                            $0.topAnchor >= $1.topAnchor
                            $0.leadingAnchor == $1.leadingAnchor
                            $0.trailingAnchor == self.passwordTextField.leadingAnchor - 20
                            $0.bottomAnchor <= $1.bottomAnchor
                            $0.centerYAnchor == $1.centerYAnchor
                        }
                    }
                    
                    com.view(self.passwordTextField) { (com) in
                        com.layout {
                            $0.topAnchor >= $1.topAnchor
                            $0.trailingAnchor == $1.trailingAnchor
                            $0.bottomAnchor <= $1.bottomAnchor
                            $0.centerYAnchor == $1.centerYAnchor
                            $0.leadingAnchor == self.emailTextField.leadingAnchor
                        }
                    }
                }
                
                com.space(40)
                com.arrangedView(self.submitButton)
            }
            
            com.view(self.forgotMyPasswordButton) { (com) in
                com.layout {
                    $0.topAnchor == self.stackView.bottomAnchor + 20
                    $0.centerXAnchor == $1.centerXAnchor
                }
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
