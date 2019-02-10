import UIKit
import DeclarativeLayout

class RegistrationExampleWithFrameworkViewController: UIViewController {
    
    private lazy var viewLayout = ViewLayout(view: view)
    private let registerOrSignInSegmentedControl = UISegmentedControl()
    private let headerLabel = UILabel()
    private let stackView = UIStackView()
    private let emailContainerView = UIView()
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordContainerView = UIView()
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
        
        viewLayout.updateLayoutTo { (component, view) in
            component.addStackView(self.stackView) { (component, view, superview) in
                view.axis = .vertical
                component.activate([
                    view.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: 35),
                    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 20),
                    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -20),
                ])
                
                component.addArrangedView(self.registerOrSignInSegmentedControl)
                component.addSpace(30)
                component.addArrangedView(self.headerLabel)
                component.addSpace(20)
                component.addArrangedView(self.emailContainerView) { (component, view, superview) in
                    component.addView(self.emailLabel) { (component, view, superview) in
                        component.activate([
                            view.topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor),
                            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                            view.trailingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor, constant: -20),
                            view.bottomAnchor.constraint(lessThanOrEqualTo: superview.bottomAnchor),
                            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
                        ])
                    }
                    
                    component.addView(self.emailTextField) { (component, view, superview) in
                        component.activate([
                            view.topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor),
                            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                            view.bottomAnchor.constraint(greaterThanOrEqualTo: superview.bottomAnchor),
                            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
                        ])
                    }
                }
                
                component.addSpace(40)
                component.addArrangedView(self.passwordContainerView) { (component, view, superview) in
                    component.addView(self.passwordLabel) { (component, view, superview) in
                        component.activate([
                            view.topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor),
                            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                            view.trailingAnchor.constraint(equalTo: self.passwordTextField.leadingAnchor, constant: -20),
                            view.bottomAnchor.constraint(lessThanOrEqualTo: superview.bottomAnchor),
                            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
                        ])
                    }
                    
                    component.addView(self.passwordTextField) { (component, view, superview) in
                        component.activate([
                            view.topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor),
                            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                            view.bottomAnchor.constraint(greaterThanOrEqualTo: superview.bottomAnchor),
                            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
                            view.leadingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor),
                        ])
                    }
                }
                
                component.addSpace(40)
                component.addArrangedView(self.submitButton)
            }
            
            component.addView(self.forgotMyPasswordButton) { (component, view, superview) in
                component.activate([
                    view.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 20),
                    view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                ])
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
