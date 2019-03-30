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

private extension UIViewLayoutComponent {
    func layout(closure: @escaping (ConstraintMaker) -> Void) {
        constraints(ownedView.snp.prepareConstraints(closure).flatMap { $0.layoutConstraints })
    }
}

private extension UIViewSubviewLayoutComponent {
    func layout(closure: @escaping (ConstraintMaker, R) -> Void) {
        let wrappingClosure: (ConstraintMaker) -> Void = {
            closure($0, self.superview)
        }
        constraints(ownedView.snp.prepareConstraints(wrappingClosure).flatMap { $0.layoutConstraints })
    }
}

private extension UIStackViewSubviewLayoutComponent {
    func layout(closure: @escaping (ConstraintMaker, R) -> Void) {
        let wrappingClosure: (ConstraintMaker) -> Void = {
            closure($0, self.superview)
        }
        constraints(ownedView.snp.prepareConstraints(wrappingClosure).flatMap { $0.layoutConstraints })
    }
}

private extension UILayoutGuideComponent {
    func layout(closure: @escaping (ConstraintMaker, R) -> Void) {
        let wrappingClosure: (ConstraintMaker) -> Void = {
            closure($0, self.owningView)
        }
        constraints(layoutGuide.snp.prepareConstraints(wrappingClosure).flatMap { $0.layoutConstraints })
    }
}

// MARK: - Example

class RegistrationExampleWithFrameworkAndSnapKitViewController: UIViewController {
    
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
                component.layout { // $0 is ConstraintMaker, $1 is superview
                    $0.top.equalTo($1.safeAreaLayoutGuide).offset(35)
                    $0.leading.equalTo($1).offset(20)
                    $0.trailing.equalTo($1).offset(-20)
                }
                
                component.arrangedView(self.registerOrSignInSegmentedControl)
                component.space(30)
                component.arrangedView(self.headerLabel)
                component.space(20)
                component.arrangedView { (component) in
                    component.view(self.emailLabel) { (component) in
                        component.layout {
                            $0.top.greaterThanOrEqualTo($1)
                            $0.leading.equalTo($1)
                            $0.trailing.equalTo(self.emailTextField.snp.leading).offset(-20)
                            $0.bottom.lessThanOrEqualTo($1)
                            $0.centerY.equalTo($1)
                        }
                    }
                    
                    component.view(self.emailTextField) { (component) in
                        component.layout {
                            $0.top.greaterThanOrEqualTo($1)
                            $0.trailing.equalTo($1)
                            $0.bottom.lessThanOrEqualTo($1)
                            $0.centerY.equalTo($1)
                        }
                    }
                }
                
                component.space(40)
                component.arrangedView { (component) in
                    component.view(self.passwordLabel) { (component) in
                        component.layout {
                            $0.top.greaterThanOrEqualTo($1)
                            $0.leading.equalTo($1)
                            $0.trailing.equalTo(self.passwordTextField.snp.leading).offset(-20)
                            $0.bottom.lessThanOrEqualTo($1)
                            $0.centerY.equalTo($1)
                        }
                    }
                    
                    component.view(self.passwordTextField) { (component) in
                        component.layout {
                            $0.top.greaterThanOrEqualTo($1)
                            $0.trailing.equalTo($1)
                            $0.bottom.lessThanOrEqualTo($1)
                            $0.centerY.equalTo($1)
                            $0.leading.equalTo(self.emailTextField)
                        }
                    }
                }
                
                component.space(40)
                component.arrangedView(self.submitButton)
            }
            
            component.view(self.forgotMyPasswordButton) { (component) in
                component.layout {
                    $0.top.equalTo(self.stackView.snp.bottom).offset(20)
                    $0.centerX.equalTo($1)
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

