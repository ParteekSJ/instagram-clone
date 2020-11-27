//
//  RegistrationController.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/22/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit

class RegistrationController : UIViewController {
    //MARK: - Properties
    private var RegistrationVModel = RegistrationViewModel()
    private var profileImage : UIImage?
    weak var delegate : AuthenticationDelegate?
    
    private let plusPhotoButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus_photo")?.withTintColor(.white), for: .normal)
        button.setDimensions(width: 140, height: 140)
        button.addTarget(self, action: #selector(handlePlusPhotoTapped), for: .touchUpInside)
        return button
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
    
    private let usernameTextField : UITextField = {
        let tf = CustomTextField(placeholder: "Username")
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let fullNameTextField : UITextField = {
        let tf = CustomTextField(placeholder: "Full Name")
        tf.autocapitalizationType = .none
        return tf
    }()

    private lazy var signUpButton : UIButton = {
        let button = Utilities().createAuthenticationButton(title: "Sign Up")
        button.addTarget(self, action: #selector(handleSignUpTapped), for: .touchUpInside)
        return button
    }()
    
    private let haveAccountButton : UIButton = {
        let button = Utilities().createAttributedButton(text1: "Already have an account? ", text2: "Log In")
        button.addTarget(self, action: #selector(handleHaveAccountButton), for: .touchUpInside)
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
    @objc func handlePlusPhotoTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleHaveAccountButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender : UITextField) {
        if sender == emailTextField {
            RegistrationVModel.email = sender.text
        } else if sender == passwordTextField {
            RegistrationVModel.password = sender.text
        } else if sender == fullNameTextField {
            RegistrationVModel.fullname = sender.text
        } else if sender == usernameTextField {
            RegistrationVModel.username = sender.text
        }
        updateForm()
    }
    
    @objc func handleSignUpTapped() {
        print("DEBUG : SignUpTapped.")
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        guard let profileImage = profileImage else { return }
        
        let userCredentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
            
        AuthService.registerUser(withCredentials: userCredentials) { error in
            if let error = error {
                print("DEBUG : FailedToRegisterUser - \(error.localizedDescription)")
                return
            }
            self.delegate?.authenticationDidComplete()
        }
    }
    
    //MARK: - Helpers
    func configureUI() {
        Utilities().configureGradientLayer(view: view)
        configureTextField()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top : view.topAnchor, paddingTop: 32)
        
        
        let fieldStack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullNameTextField, usernameTextField, signUpButton])
        fieldStack.axis = .vertical
        fieldStack.spacing = 12
        
        view.addSubview(fieldStack)
        fieldStack.anchor(top : plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingTop: 10 , paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(haveAccountButton)
        haveAccountButton.centerX(inView: view)
        haveAccountButton.anchor(bottom : view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
    }
    
    func configureTextField() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        fullNameTextField.delegate = self
        usernameTextField.delegate = self
    }
    
    func configureNotificationsObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

//MARK: - UITextFieldDelegate
extension RegistrationController : UITextFieldDelegate {
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
extension RegistrationController : FormViewModel {
    func updateForm() {
        signUpButton.backgroundColor = RegistrationVModel.buttonBackgroundColor
        signUpButton.setTitleColor(RegistrationVModel.buttonTitleColor, for: .normal)
        signUpButton.isEnabled = RegistrationVModel.formIsValid
    }
}

//MARK: - ImagePickerControllerDelegate, NavigationControllerDelegate
extension RegistrationController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = selectedImage
        
        plusPhotoButton.layer.cornerRadius = 140 / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
}
