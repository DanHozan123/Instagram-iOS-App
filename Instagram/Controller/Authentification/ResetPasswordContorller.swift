//
//  ResetPasswordContorller.swift
//  Instagram
//
//  Created by Dan Hozan on 28.02.2024.
//

import UIKit

protocol ResetPasswordContorllerDelegate: AnyObject {
    func controllerDidSentResetPasswordLink(_ controller: ResetPasswordContorller)
}

class ResetPasswordContorller: UIViewController {
  
    //MARK: - Properties
    private let emailTextField = CustomTextField(placeholder: "Email")
    private var viewModel = ResetPasswordViewModel()
    weak var delegate: ResetPasswordContorllerDelegate?
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Instagram_logo_white")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Password", for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
        button.backgroundColor = .systemPurple.withAlphaComponent(0.1)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleResetPasswordButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()

    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Actions
    
    @objc func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleResetPasswordButton(){
        guard let email = emailTextField.text else { return }
        AuthService.resetPassword(email: email) {  error in
            if error == nil {
                self.delegate?.controllerDidSentResetPasswordLink(self)
            } else {
                self.showMessage(withTitle: "Error", message: error!.localizedDescription)
            }
        }
        
    }
    
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = emailTextField.text
        }
        updateForm()
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        configureGradientLayer()
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          left: view.leftAnchor,
                          paddingTop: 16,
                          paddingLeft: 16)
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(height: 100, width: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, resetPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 32, paddingLeft: 32, paddingRight: 32)
    }
    
    
}


extension ResetPasswordContorller: FormViewModel{
    func updateForm() {
        resetPasswordButton.backgroundColor = viewModel.buttonBackgroudColor
        resetPasswordButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        resetPasswordButton.isEnabled = viewModel.formIsValid
    }
    
    
}

