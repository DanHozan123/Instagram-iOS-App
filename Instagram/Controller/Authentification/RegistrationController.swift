//
//  RegistrationController.swift
//  Instagram
//
//  Created by Dan Hozan on 19.02.2024.
//

import UIKit

class RegistrationController: UIViewController{
    
    //MARK: - Properties
    
    private var registrationViewModel = RegistrationViewModel()
    
    private lazy var plusPhotoButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
        return button
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
    
    private let fullnameField = CustomTextField(placeholder: "Fullname")
    
    private let usernameField = CustomTextField(placeholder: "Username")

    
    private lazy var singUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.5) , for: .normal)
        button.backgroundColor = .systemPurple.withAlphaComponent(0.1)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Already have an account?", secondPart: "Sign In")
        button.addTarget(self, action: #selector(handleShowLogIn), for: .touchUpInside)
        return button
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    //MARK: - Actions
    @objc func handleShowLogIn() {
        navigationController?.popViewController(animated: true)
    }

    
    //MARK: - Actions
    
    @objc func handleSignUp() {
        
    }
    
    @objc func handleShowSignUp() {
     
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            registrationViewModel.email = emailTextField.text
        }
        else if sender == passwordTextField {
            registrationViewModel.password = passwordTextField.text
        }
        else if sender == fullnameField {
            registrationViewModel.fullname = fullnameField.text
        }
        else if sender == usernameField {
            registrationViewModel.username = usernameField.text
        }
        updateForm()
        
    }
    
    
    @objc func handleProfilePhotoSelect() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Helpers
    func configureUI(){
        configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        plusPhotoButton.setDimensions(height: 140, width: 140)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullnameField, usernameField, singUpButton])
        stack.spacing = 20
        stack.axis = .vertical
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
       
    }
    
    func configureNotificationObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    
    
}

extension RegistrationController: FormViewModel{
    func updateForm() {
        singUpButton.backgroundColor = registrationViewModel.buttonBackgroudColor
        singUpButton.setTitleColor(registrationViewModel.buttonTitleColor, for: .normal)
        singUpButton.isEnabled = registrationViewModel.formIsValid
    }
    
}

    //MARK: - Extensions

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
}
