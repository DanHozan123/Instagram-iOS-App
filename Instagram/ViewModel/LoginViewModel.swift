//
//  LoginViewModel.swift
//  Instagram
//
//  Created by Dan Hozan on 20.02.2024.
//

import UIKit


protocol FormViewModel {
    func updateForm()
}

protocol AuthentificationViewModel {
    var formIsValid: Bool { get }
    var buttonBackgroudColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
}

struct LoginViewModel: AuthentificationViewModel{
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroudColor: UIColor {
        return formIsValid ? .systemBlue : .systemPurple.withAlphaComponent(0.1)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : .white.withAlphaComponent(0.5)
    }
    
}

struct RegistrationViewModel: AuthentificationViewModel{
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false && username?.isEmpty == false
    }
    
    var buttonBackgroudColor: UIColor {
        return formIsValid ? .systemBlue : .systemPurple.withAlphaComponent(0.1)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : .white.withAlphaComponent(0.5)
    }
    
    
}
