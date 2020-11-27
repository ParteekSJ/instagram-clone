//
//  UploadPostController.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/25/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

protocol UploadPostControllerDelegate : class {
    func controllerDidFinishUploadingPost(_ controller : UploadPostController)
}

class UploadPostController : UIViewController {
    //MARK: - Properties
    var currentUser : User?
    
    var selectedImage : UIImage? {
        didSet {
            photoImageView.image = selectedImage
        }
    }
    
    weak var delegate : UploadPostControllerDelegate?
    
    private let photoImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 180, height: 180)
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    private let captionTextView : InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "Enter caption.."
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.placeholderShouldCenter = false
        return tv
    }()
    
    private let characterCountLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
        return label
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: - API
    
    //MARK: - Selectors
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
        
    @objc func handleSharePost() {
        guard let image = selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        guard let user = currentUser else  { return }
        
        showLoader(true)
        
        PostService.uploadPost(user : user, caption: caption, image: image) { error in
            self.showLoader(false)
            if let error = error {
                print("DEBUG : FailedToUploadPost - \(error.localizedDescription)")
                return
            }
            self.delegate?.controllerDidFinishUploadingPost(self)
        }
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        configurenNavigationBar()
        
        captionTextView.delegate = self
        
        view.addSubview(photoImageView)
        photoImageView.anchor(top : view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        photoImageView.centerX(inView: view)
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top : photoImageView.bottomAnchor, left : view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingRight: 12, height: 64)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom : captionTextView.bottomAnchor, right: view.rightAnchor, paddingBottom: -8, paddingRight: 12)
    }
    
    func configurenNavigationBar() {
        navigationItem.title = "Upload Post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(handleSharePost))
    }
    
    func checkMaxLength(_ textView : UITextView, maxLength : Int) {
        if textView.text.count > maxLength {
            textView.deleteBackward()
        }
    }
}

//MARK: - UITextViewDelegate
extension UploadPostController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView, maxLength: 100)
        let count = textView.text.count
        characterCountLabel.text = "\(count)/100"
    }
    
    
    //ReturnButtonIsTapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    //AnyPartOfTheScreenIsTapped
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
