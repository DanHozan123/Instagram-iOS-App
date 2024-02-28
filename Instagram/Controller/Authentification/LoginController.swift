//
//  LoginController.swift
//  Instagram
//
//  Created by Dan Hozan on 19.02.2024.
//

import UIKit

protocol AuthentificationDelegate: AnyObject {
    func authentificationDidComplete()
}

class LoginController: UIViewController{
    
    //MARK: - Properties
    
    private var viewModel = LoginViewModel()
    weak var delegate: AuthentificationDelegate?
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Instagram_logo_white")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
        button.backgroundColor = .systemPurple.withAlphaComponent(0.1)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Forgot your password?", secondPart: "Get help signing in.")
        button.addTarget(self, action: #selector(handleShowResetPassword), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an account?", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
 
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    //MARK: - Actions
    
    @objc func handleShowResetPassword(){
        let controller = ResetPasswordContorller()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleShowSignUp() {
        let vc = RegistrationController()
        vc.delegate = delegate
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = emailTextField.text
        }
        else if sender == passwordTextField {
            viewModel.password = passwordTextField.text
        }
        updateForm()
    }
    
    @objc func handleSignIn(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        AuthService.signInUser(withEmail: email, password: password) { error in
            if let error = error {
                print("DEBUG: Failed to sing in user \(error.localizedDescription)")
                return
            }
            self.delegate?.authentificationDidComplete()
        }
        
    }
    
    //MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(height: 100, width: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signInButton, forgotPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
    }
    
    func configureNotificationObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    
}

//MARK: - FormViewModel
extension LoginController: FormViewModel{
    func updateForm() {
        signInButton.backgroundColor = viewModel.buttonBackgroudColor
        signInButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        signInButton.isEnabled = viewModel.formIsValid
    }
    
    
}
//MARK: - ResetPasswordContorllerDelegate
extension LoginController: ResetPasswordContorllerDelegate {
    func controllerDidSentResetPasswordLink(_ controller: ResetPasswordContorller) {
        
        navigationController?.popViewController(animated: true)
        showMessage(withTitle: "Success", message: "We sent a link to your mail to reset your password")
    }
    
    
}
