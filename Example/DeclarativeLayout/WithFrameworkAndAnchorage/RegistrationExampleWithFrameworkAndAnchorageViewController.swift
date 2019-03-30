import UIKit
import DeclarativeLayout
import Anchorage

// MARK: - Layout extensions for Anchorage

private extension UIViewLayoutComponent {
    func layout(closure: @escaping (T) -> Void) {
        let wrappingClosure: () -> Void = {
            closure(self.ownedView)
        }
        activate(Anchorage.batch(active: false, closure: wrappingClosure))
    }
}

private extension UIViewSubviewLayoutComponent {
    func layout(closure: @escaping (T, R) -> Void) {
        let wrappingClosure: () -> Void = {
            closure(self.ownedView, self.superview)
        }
        activate(Anchorage.batch(active: false, closure: wrappingClosure))
    }
}

private extension UIStackViewSubviewLayoutComponent {
    func layout(closure: @escaping (T, R) -> Void) {
        let wrappingClosure: () -> Void = {
            closure(self.ownedView, self.superview)
        }
        activate(Anchorage.batch(active: false, closure: wrappingClosure))
    }
}

private extension UILayoutGuideComponent {
    func layout(closure: @escaping (R) -> Void) {
        let wrappingClosure: () -> Void = {
            closure(self.owningView)
        }
        activate(Anchorage.batch(active: false, closure: wrappingClosure))
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
        
        viewLayout.updateLayoutTo { (component) in
            component.addStackView(self.stackView) { (component) in
                component.ownedView.axis = .vertical
                component.layout { // $0 is component's view, $1 is superview
                    $0.topAnchor == $1.safeAreaLayoutGuide.topAnchor + 35
                    $0.leadingAnchor == $1.leadingAnchor + 20
                    $0.trailingAnchor == $1.trailingAnchor - 20
                }
                
                component.addArrangedView(self.registerOrSignInSegmentedControl)
                component.addSpace(30)
                component.addArrangedView(self.headerLabel)
                component.addSpace(20)
                component.addArrangedView { (component) in
                    component.addView(self.emailLabel) { (component) in
                        component.layout {
                            $0.topAnchor >= $1.topAnchor
                            $0.leadingAnchor == $1.leadingAnchor
                            $0.trailingAnchor == self.emailTextField.leadingAnchor - 20
                            $0.bottomAnchor <= $1.bottomAnchor
                            $0.centerYAnchor == $1.centerYAnchor
                        }
                    }
                    
                    component.addView(self.emailTextField) { (component) in
                        component.layout {
                            $0.topAnchor >= $1.topAnchor
                            $0.trailingAnchor == $1.trailingAnchor
                            $0.bottomAnchor <= $1.bottomAnchor
                            $0.centerYAnchor == $1.centerYAnchor
                        }
                    }
                }
                
                component.addSpace(40)
                component.addArrangedView { (component) in
                    component.addView(self.passwordLabel) { (component) in
                        component.layout {
                            $0.topAnchor >= $1.topAnchor
                            $0.leadingAnchor == $1.leadingAnchor
                            $0.trailingAnchor == self.passwordTextField.leadingAnchor - 20
                            $0.bottomAnchor <= $1.bottomAnchor
                            $0.centerYAnchor == $1.centerYAnchor
                        }
                    }
                    
                    component.addView(self.passwordTextField) { (component) in
                        component.layout {
                            $0.topAnchor >= $1.topAnchor
                            $0.trailingAnchor == $1.trailingAnchor
                            $0.bottomAnchor <= $1.bottomAnchor
                            $0.centerYAnchor == $1.centerYAnchor
                            $0.leadingAnchor == self.emailTextField.leadingAnchor
                        }
                    }
                }
                
                component.addSpace(40)
                component.addArrangedView(self.submitButton)
            }
            
            component.addView(self.forgotMyPasswordButton) { (component) in
                component.layout {
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
