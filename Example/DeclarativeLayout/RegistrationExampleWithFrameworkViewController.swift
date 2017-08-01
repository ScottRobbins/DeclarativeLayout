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
        
        viewLayout.updateLayoutTo { (layout) in
            
            layout.addView(self.registerOrSignInSegmentedControl) { (layout) in
                
                layout.activate([
                    layout.view.topAnchor.constraint(equalTo: layout.superview.topAnchor, constant: 84),
                    layout.view.leadingAnchor.constraint(equalTo: layout.superview.leadingAnchor, constant: 20),
                    layout.view.trailingAnchor.constraint(equalTo: layout.superview.trailingAnchor, constant: -20),
                ])
            }
            
            layout.addView(self.headerLabel) { (layout) in
                
                layout.activate([
                    layout.view.topAnchor.constraint(equalTo: self.registerOrSignInSegmentedControl.bottomAnchor, constant: 30),
                    layout.view.leadingAnchor.constraint(equalTo: layout.superview.leadingAnchor, constant: 20),
                    layout.view.trailingAnchor.constraint(equalTo: layout.superview.trailingAnchor, constant: -20),
                ])
            }
            
            layout.addStackView(stackView) { (layout) in
                
                layout.activate([
                    layout.view.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor),
                    layout.view.leadingAnchor.constraint(equalTo: layout.superview.leadingAnchor),
                    layout.view.trailingAnchor.constraint(equalTo: layout.superview.trailingAnchor),
                ])
                
                layout.addArrangedView(self.emailContainerView) { (layout) in
                    
                    layout.addView(self.emailLabel) { (layout) in
                        
                        layout.activate([
                            layout.view.topAnchor.constraint(greaterThanOrEqualTo: layout.superview.topAnchor, constant: 20),
                            layout.view.leadingAnchor.constraint(equalTo: layout.superview.leadingAnchor, constant: 20),
                            layout.view.trailingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor, constant: -20),
                            layout.view.bottomAnchor.constraint(lessThanOrEqualTo: layout.superview.bottomAnchor, constant: -20),
                            layout.view.centerYAnchor.constraint(equalTo: layout.superview.centerYAnchor),
                        ])
                    }
                    
                    layout.addView(self.emailTextField) { (layout) in
                        
                        layout.activate([
                            layout.view.topAnchor.constraint(greaterThanOrEqualTo: layout.superview.topAnchor, constant: 20),
                            layout.view.trailingAnchor.constraint(equalTo: layout.superview.trailingAnchor, constant: -20),
                            layout.view.bottomAnchor.constraint(greaterThanOrEqualTo: layout.superview.bottomAnchor, constant: -20),
                            layout.view.centerYAnchor.constraint(equalTo: layout.superview.centerYAnchor),
                        ])
                    }
                }
                
                layout.addArrangedView(self.passwordContainerView) { (layout) in
                    
                    layout.addView(self.passwordLabel) { (layout) in
                        
                        layout.activate([
                            layout.view.topAnchor.constraint(greaterThanOrEqualTo: layout.superview.topAnchor, constant: 20),
                            layout.view.leadingAnchor.constraint(equalTo: layout.superview.leadingAnchor, constant: 20),
                            layout.view.trailingAnchor.constraint(equalTo: self.passwordTextField.leadingAnchor, constant: -20),
                            layout.view.bottomAnchor.constraint(lessThanOrEqualTo: layout.superview.bottomAnchor, constant: -20),
                            layout.view.centerYAnchor.constraint(equalTo: layout.superview.centerYAnchor),
                        ])
                    }
                    
                    layout.addView(self.passwordTextField) { (layout) in
                        
                        layout.activate([
                            layout.view.topAnchor.constraint(greaterThanOrEqualTo: layout.superview.topAnchor, constant: 20),
                            layout.view.trailingAnchor.constraint(equalTo: layout.superview.trailingAnchor, constant: -20),
                            layout.view.bottomAnchor.constraint(greaterThanOrEqualTo: layout.superview.bottomAnchor, constant: -20),
                            layout.view.centerYAnchor.constraint(equalTo: layout.superview.centerYAnchor),
                            layout.view.leadingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor),
                        ])
                    }
                }
            }
            
            layout.addView(self.submitButton) { (layout) in
                
                layout.activate([
                    layout.view.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 20),
                    layout.view.leadingAnchor.constraint(equalTo: layout.superview.leadingAnchor, constant: 20),
                    layout.view.trailingAnchor.constraint(equalTo: layout.superview.trailingAnchor, constant: -20),
                ])
            }
            
            layout.addView(self.forgotMyPasswordButton) { (layout) in
                
                layout.activate([
                    layout.view.topAnchor.constraint(equalTo: self.submitButton.bottomAnchor, constant: 20),
                    layout.view.centerXAnchor.constraint(equalTo: layout.superview.centerXAnchor),
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
