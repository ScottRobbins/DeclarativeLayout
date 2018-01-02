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
        
        viewLayout.updateLayoutTo { (component, view) in
            
            view.backgroundColor = .white
            
            component.addView(self.registerOrSignInSegmentedControl) { (component, view, superview) in
                
                view.insertSegment(withTitle: "Register", at: 0, animated: false)
                view.insertSegment(withTitle: "Sign In", at: 1, animated: false)
                if view.selectedSegmentIndex == -1 {
                    view.selectedSegmentIndex = 0
                }
                
                component.activate([
                    view.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: 35),
                    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 20),
                    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -20),
                ])
            }
            
            component.addView(self.headerLabel) { (component, view, superview) in
                
                view.font = UIFont.boldSystemFont(ofSize: 18)
                if self.registerOrSignInSegmentedControl.selectedSegmentIndex == 0 {
                    view.text = "Register"
                } else {
                    view.text = "Sign In"
                }
                
                component.activate([
                    view.topAnchor.constraint(equalTo: self.registerOrSignInSegmentedControl.bottomAnchor, constant: 30),
                    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 20),
                    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -20),
                ])
            }
            
            component.addStackView(self.stackView) { (component, view, superview) in
                
                view.axis = .vertical
                
                component.activate([
                    view.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor),
                    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                ])
                
                component.addArrangedView(self.emailContainerView) { (component, view, superview) in
                    
                    component.addView(self.emailLabel) { (component, view, superview) in
                        
                        view.text = "Email"
                        
                        component.activate([
                            view.topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor, constant: 20),
                            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 20),
                            view.trailingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor, constant: -20),
                            view.bottomAnchor.constraint(lessThanOrEqualTo: superview.bottomAnchor, constant: -20),
                            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
                        ])
                    }
                    
                    component.addView(self.emailTextField) { (component, view, superview) in
                        
                        view.placeholder = "example@example.com"
                        if #available(iOS 10.0, *) {
                            view.textContentType = .emailAddress
                        }
                        view.layer.borderColor = UIColor.blue.cgColor
                        view.layer.borderWidth = 1
                        view.textAlignment = .center
                        view.isUserInteractionEnabled = false
                        
                        component.activate([
                            view.topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor, constant: 20),
                            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -20),
                            view.bottomAnchor.constraint(greaterThanOrEqualTo: superview.bottomAnchor, constant: -20),
                            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
                        ])
                    }
                }
                
                component.addArrangedView(self.passwordContainerView) { (component, view, superview) in
                    
                    component.addView(self.passwordLabel) { (component, view, superview) in
                        
                        view.text = "Password"
                        
                        component.activate([
                            view.topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor, constant: 20),
                            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 20),
                            view.trailingAnchor.constraint(equalTo: self.passwordTextField.leadingAnchor, constant: -20),
                            view.bottomAnchor.constraint(lessThanOrEqualTo: superview.bottomAnchor, constant: -20),
                            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
                        ])
                    }
                    
                    component.addView(self.passwordTextField) { (component, view, superview) in
                        
                        view.placeholder = "secure password here"
                        view.isSecureTextEntry = true
                        view.layer.borderColor = UIColor.blue.cgColor
                        view.layer.borderWidth = 1
                        view.textAlignment = .center
                        view.isUserInteractionEnabled = false
                        
                        component.activate([
                            view.topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor, constant: 20),
                            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -20),
                            view.bottomAnchor.constraint(greaterThanOrEqualTo: superview.bottomAnchor, constant: -20),
                            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
                            view.leadingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor),
                        ])
                    }
                }
            }
            
            component.addView(self.submitButton) { (component, view, superview) in
                
                view.setTitle("Submit", for: .normal)
                view.backgroundColor = UIColor.blue
                view.setTitleColor(.white, for: .normal)
                view.layer.cornerRadius = 10
                view.clipsToBounds = true
                view.titleLabel?.textAlignment = .center
                
                component.activate([
                    view.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 20),
                    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 20),
                    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -20),
                ])
            }
            
            component.addView(self.forgotMyPasswordButton) { (component, view, superview) in
                
                view.setTitle("forgot your password?", for: .normal)
                view.setTitleColor(.blue, for: .normal)
                
                component.activate([
                    view.topAnchor.constraint(equalTo: self.submitButton.bottomAnchor, constant: 20),
                    view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                ])
            }
        }
    }
}
