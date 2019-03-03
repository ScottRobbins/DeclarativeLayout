import UIKit
import DeclarativeLayout
import SnapKit

/*
 Note about using Snapkit:
 
 Because DeclarativeLayout doesn't necessarily have the views added to the view hierarchy at the time you are
 creating constraints with snapkit, you cannot use `...ToSuperview()`, it will result in a crash. Additional
 functionality would be needed on snapkit's end to support passing the context of what the superview is to SnapKit.
 */

// MARK: - Layout extensions for Snapkit

private extension ViewLayoutComponent {
    func layout(closure: (ConstraintMaker) -> Void) {
        activate(view.snp.prepareConstraints(closure).flatMap { $0.layoutConstraints })
    }
}

private extension UILayoutGuideComponent {
    func layout(closure: (ConstraintMaker) -> Void) {
        activate(layoutGuide.snp.prepareConstraints(closure).flatMap { $0.layoutConstraints })
    }
}

// MARK: - Example

class RegistrationExampleWithFrameworkAndSnapKitViewController: UIViewController {
    
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
        
        viewLayout.updateLayoutTo { (component) in
            component.addStackView(self.stackView) { (component) in
                component.view.axis = .vertical
                component.layout { (make) -> Void in
                    make.top.equalTo(component.superview.safeAreaLayoutGuide).offset(35)
                    make.leading.equalTo(component.superview).offset(20)
                    make.trailing.equalTo(component.superview).offset(-20)
                }
                
                component.addArrangedView(self.registerOrSignInSegmentedControl)
                component.addSpace(30)
                component.addArrangedView(self.headerLabel)
                component.addSpace(20)
                component.addArrangedView(self.emailContainerView) { (component) in
                    component.addView(self.emailLabel) { (component) in
                        component.layout { (make) in
                            make.top.greaterThanOrEqualTo(component.superview)
                            make.leading.equalTo(component.superview)
                            make.trailing.equalTo(self.emailTextField.snp.leading).offset(-20)
                            make.bottom.lessThanOrEqualTo(component.superview)
                            make.centerY.equalTo(component.superview)
                        }
                    }
                    
                    component.addView(self.emailTextField) { (component) in
                        component.layout { (make) in
                            make.top.greaterThanOrEqualTo(component.superview)
                            make.trailing.equalTo(component.superview)
                            make.bottom.lessThanOrEqualTo(component.superview)
                            make.centerY.equalTo(component.superview)
                        }
                    }
                }
                
                component.addSpace(40)
                component.addArrangedView(self.passwordContainerView) { (component) in
                    component.addView(self.passwordLabel) { (component) in
                        component.layout { (make) in
                            make.top.greaterThanOrEqualTo(component.superview)
                            make.leading.equalTo(component.superview)
                            make.trailing.equalTo(self.passwordTextField.snp.leading).offset(-20)
                            make.bottom.lessThanOrEqualTo(component.superview)
                            make.centerY.equalTo(component.superview)
                        }
                    }
                    
                    component.addView(self.passwordTextField) { (component) in
                        component.layout { (make) in
                            make.top.greaterThanOrEqualTo(component.superview)
                            make.trailing.equalTo(component.superview)
                            make.bottom.lessThanOrEqualTo(component.superview)
                            make.centerY.equalTo(component.superview)
                            make.leading.equalTo(self.emailTextField)
                        }
                    }
                }
                
                component.addSpace(40)
                component.addArrangedView(self.submitButton)
            }
            
            component.addView(self.forgotMyPasswordButton) { (component) in
                component.layout { (make) in
                    make.top.equalTo(self.stackView.snp.bottom).offset(20)
                    make.centerX.equalTo(component.superview)
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

