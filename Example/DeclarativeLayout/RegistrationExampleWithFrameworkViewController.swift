import UIKit
import DeclarativeLayout

class RegistrationExampleWithFrameworkViewController: UIViewController {
    
    private var viewLayout: ViewLayout!
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
        
        viewLayout = ViewLayout(view: view)
        layoutAllViews()
        configureAllViews()
    }
    
    private func layoutAllViews() {
        
        viewLayout.updateLayoutTo { (component) in
            
            component.addView(self.registerOrSignInSegmentedControl) { (component) in
                
                component.activate([
                    component.view.topAnchor.constraint(equalTo: component.superview.topAnchor, constant: 84),
                    component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
                    component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: -20),
                ])
            }
            
            component.addView(self.headerLabel) { (component) in
                
                component.activate([
                    component.view.topAnchor.constraint(equalTo: self.registerOrSignInSegmentedControl.bottomAnchor, constant: 30),
                    component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
                    component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: -20),
                ])
            }
            
            component.addStackView(stackView) { (component) in
                
                component.activate([
                    component.view.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor),
                    component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor),
                    component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor),
                ])
                
                component.addArrangedView(self.emailContainerView) { (component) in
                    
                    component.addView(self.emailLabel) { (component) in
                        
                        component.activate([
                            component.view.topAnchor.constraint(greaterThanOrEqualTo: component.superview.topAnchor, constant: 20),
                            component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
                            component.view.trailingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor, constant: -20),
                            component.view.bottomAnchor.constraint(lessThanOrEqualTo: component.superview.bottomAnchor, constant: -20),
                            component.view.centerYAnchor.constraint(equalTo: component.superview.centerYAnchor),
                        ])
                    }
                    
                    component.addView(self.emailTextField) { (component) in
                        
                        component.activate([
                            component.view.topAnchor.constraint(greaterThanOrEqualTo: component.superview.topAnchor, constant: 20),
                            component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: -20),
                            component.view.bottomAnchor.constraint(greaterThanOrEqualTo: component.superview.bottomAnchor, constant: -20),
                            component.view.centerYAnchor.constraint(equalTo: component.superview.centerYAnchor),
                        ])
                    }
                }
                
                component.addArrangedView(self.passwordContainerView) { (component) in
                    
                    component.addView(self.passwordLabel) { (component) in
                        
                        component.activate([
                            component.view.topAnchor.constraint(greaterThanOrEqualTo: component.superview.topAnchor, constant: 20),
                            component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
                            component.view.trailingAnchor.constraint(equalTo: self.passwordTextField.leadingAnchor, constant: -20),
                            component.view.bottomAnchor.constraint(lessThanOrEqualTo: component.superview.bottomAnchor, constant: -20),
                            component.view.centerYAnchor.constraint(equalTo: component.superview.centerYAnchor),
                        ])
                    }
                    
                    component.addView(self.passwordTextField) { (component) in
                        
                        component.activate([
                            component.view.topAnchor.constraint(greaterThanOrEqualTo: component.superview.topAnchor, constant: 20),
                            component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: -20),
                            component.view.bottomAnchor.constraint(greaterThanOrEqualTo: component.superview.bottomAnchor, constant: -20),
                            component.view.centerYAnchor.constraint(equalTo: component.superview.centerYAnchor),
                            component.view.leadingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor),
                        ])
                    }
                }
            }
            
            component.addView(self.submitButton) { (component) in
                
                component.activate([
                    component.view.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 20),
                    component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
                    component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: -20),
                ])
            }
            
            component.addView(self.forgotMyPasswordButton) { (component) in
                
                component.activate([
                    component.view.topAnchor.constraint(equalTo: self.submitButton.bottomAnchor, constant: 20),
                    component.view.centerXAnchor.constraint(equalTo: component.superview.centerXAnchor),
                ])
            }
        }
    }
    
    private func configureAllViews() {        
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
