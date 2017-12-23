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
        
        layoutAndConfigureAllViews()
    }
    
    private func layoutAndConfigureAllViews() {
        
        viewLayout.updateLayoutTo { (component) in
            
            component.view.backgroundColor = .white
            
            component.addView(self.registerOrSignInSegmentedControl) { (component) in
                
                component.view.insertSegment(withTitle: "Register", at: 0, animated: false)
                component.view.insertSegment(withTitle: "Sign In", at: 1, animated: false)
                if component.view.selectedSegmentIndex == -1 {
                    component.view.selectedSegmentIndex = 0
                }
                
                component.activate([
                    component.view.topAnchor.constraint(equalTo: component.superview.safeAreaLayoutGuide.topAnchor, constant: 35),
                    component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
                    component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: -20),
                ])
            }
            
            component.addView(self.headerLabel) { (component) in
                
                component.view.font = UIFont.boldSystemFont(ofSize: 18)
                if self.registerOrSignInSegmentedControl.selectedSegmentIndex == 0 {
                    component.view.text = "Register"
                } else {
                    component.view.text = "Sign In"
                }
                
                component.activate([
                    component.view.topAnchor.constraint(equalTo: self.registerOrSignInSegmentedControl.bottomAnchor, constant: 30),
                    component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
                    component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: -20),
                ])
            }
            
            component.addStackView(self.stackView) { (component) in
                
                component.view.axis = .vertical
                
                component.activate([
                    component.view.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor),
                    component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor),
                    component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor),
                ])
                
                component.addArrangedView(self.emailContainerView) { (component) in
                    
                    component.addView(self.emailLabel) { (component) in
                        
                        component.view.text = "Email"
                        
                        component.activate([
                            component.view.topAnchor.constraint(greaterThanOrEqualTo: component.superview.topAnchor, constant: 20),
                            component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
                            component.view.trailingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor, constant: -20),
                            component.view.bottomAnchor.constraint(lessThanOrEqualTo: component.superview.bottomAnchor, constant: -20),
                            component.view.centerYAnchor.constraint(equalTo: component.superview.centerYAnchor),
                        ])
                    }
                    
                    component.addView(self.emailTextField) { (component) in
                        
                        component.view.placeholder = "example@example.com"
                        if #available(iOS 10.0, *) {
                            component.view.textContentType = .emailAddress
                        }
                        component.view.layer.borderColor = UIColor.blue.cgColor
                        component.view.layer.borderWidth = 1
                        component.view.textAlignment = .center
                        component.view.isUserInteractionEnabled = false
                        
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
                        
                        component.view.text = "Password"
                        
                        component.activate([
                            component.view.topAnchor.constraint(greaterThanOrEqualTo: component.superview.topAnchor, constant: 20),
                            component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
                            component.view.trailingAnchor.constraint(equalTo: self.passwordTextField.leadingAnchor, constant: -20),
                            component.view.bottomAnchor.constraint(lessThanOrEqualTo: component.superview.bottomAnchor, constant: -20),
                            component.view.centerYAnchor.constraint(equalTo: component.superview.centerYAnchor),
                        ])
                    }
                    
                    component.addView(self.passwordTextField) { (component) in
                        
                        component.view.placeholder = "secure password here"
                        component.view.isSecureTextEntry = true
                        component.view.layer.borderColor = UIColor.blue.cgColor
                        component.view.layer.borderWidth = 1
                        component.view.textAlignment = .center
                        component.view.isUserInteractionEnabled = false
                        
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
                
                component.view.setTitle("Submit", for: .normal)
                component.view.backgroundColor = UIColor.blue
                component.view.setTitleColor(.white, for: .normal)
                component.view.layer.cornerRadius = 10
                component.view.clipsToBounds = true
                component.view.titleLabel?.textAlignment = .center
                
                component.activate([
                    component.view.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 20),
                    component.view.leadingAnchor.constraint(equalTo: component.superview.leadingAnchor, constant: 20),
                    component.view.trailingAnchor.constraint(equalTo: component.superview.trailingAnchor, constant: -20),
                ])
            }
            
            component.addView(self.forgotMyPasswordButton) { (component) in
                
                component.view.setTitle("forgot your password?", for: .normal)
                component.view.setTitleColor(.blue, for: .normal)
                
                component.activate([
                    component.view.topAnchor.constraint(equalTo: self.submitButton.bottomAnchor, constant: 20),
                    component.view.centerXAnchor.constraint(equalTo: component.superview.centerXAnchor),
                ])
            }
        }
    }
}
