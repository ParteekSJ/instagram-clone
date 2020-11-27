//
//  LoginController.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/22/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit

protocol AuthenticationDelegate : class {
    func authenticationDidComplete()
}

class LoginController : UIViewController {
    //MARK: - Properties
    
    private var LoginVModel = LoginViewModel()
    
    weak var delegate : AuthenticationDelegate?
    
    private let iconImageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Instagram_logo_white")
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 120, height: 80)
        return iv
    }()
    
    private let emailTextField : UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTextField : UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton : UIButton = {
        let button = Utilities().createAuthenticationButton(title: "Log In")
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let forgotPasswordButton : UIButton = {
        let button = Utilities().createAttributedButton(text1: "Forgot your password? ", text2: "Get help signing in.")
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton : UIButton = {
        let button = Utilities().createAttributedButton(text1: "Don't have an account? ", text2: "Sign Up")
        button.addTarget(self, action: #selector(handleDontHaveAccountButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationsObservers()
    }
    
    //MARK: - API
    
    //MARK: - Selectors
    @objc func handleForgotPassword() {
        print("DEBUG : handleForgotPassword..")
    }
    
    @objc func handleDontHaveAccountButton() {
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender : UITextField) {
        if sender == emailTextField {
            LoginVModel.email = sender.text
        } else if sender == passwordTextField {
            LoginVModel.password = sender.text
        }
        updateForm()
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        AuthService.logUserIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG : FailedToLogIn \(error.localizedDescription)")
            }
            self.delegate?.authenticationDidComplete()
            self.dismiss(animated: true, completion: nil)
        }
    }
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureTextFields()
        Utilities().configureGradientLayer(view: view)
        
        view.addSubview(iconImageView)
        iconImageView.centerX(inView: view)
        iconImageView.anchor(top : view.safeAreaLayoutGuide.topAnchor, paddingTop: 28)
        
        let fieldStack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        fieldStack.axis = .vertical
        fieldStack.spacing = 12
        
        view.addSubview(fieldStack)
        fieldStack.anchor(top : iconImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.centerX(inView: view)
        forgotPasswordButton.anchor(top : fieldStack.bottomAnchor, paddingTop: 20)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom : view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
    }
    
    func configureTextFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func configureNotificationsObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

    }

}

//MARK: - UITextFieldDelegate
extension LoginController : UITextFieldDelegate {
    //ReturnButtonIsTapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    //AnyPartOfTheScreenIsTapped
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK: - FormViewModel
extension LoginController : FormViewModel {
    func updateForm() {
        loginButton.backgroundColor = LoginVModel.buttonBackgroundColor
        loginButton.setTitleColor(LoginVModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = LoginVModel.formIsValid
    }
}
