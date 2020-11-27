//
//  MainTabController.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/22/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import YPImagePicker

class MainTabController : UITabBarController {
    //MARK: - Properties
    var user : User? {
        didSet {
            guard let user = user else { return }
            configureTabBarController(withUser: user)
        }
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserLoginStatus()
    }
    
    //MARK: - API
    
    func checkUserLoginStatus() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
            }
        } else {
            configureUI()
            fetchUser()            
        }
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(withuid: uid) { user in
            self.user = user
        }
    }
    
    //MARK: - Selectors
    
    //MARK: - Helpers
    func configureUI() {
        self.delegate = self
        view.backgroundColor = .white
    }
    
    func configureTabBarController(withUser user : User) {
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let feedNC = embedNavigationController(vc: feed, unselectedImagename: "home_unselected", selectedImagename: "home_selected")
        
        let search = SearchController()
        let searchNC = embedNavigationController(vc: search, unselectedImagename: "search_unselected", selectedImagename: "search_selected")
        
        let image = ImageSelectorController()
        let imageNC = embedNavigationController(vc: image, unselectedImagename: "plus_unselected", selectedImagename: "plus_unselected")
        
        let notifications = NotificationsController()
        let notificationsNC = embedNavigationController(vc: notifications, unselectedImagename: "like_unselected", selectedImagename: "like_selected")
        
        let profile = ProfileController(user: user)
        let profileNC = embedNavigationController(vc: profile, unselectedImagename: "profile_unselected", selectedImagename: "profile_selected")
        
        viewControllers = [feedNC, searchNC, imageNC, notificationsNC, profileNC]
    }
    
    func embedNavigationController(vc : UIViewController, unselectedImagename : String, selectedImagename : String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.tintColor = .black
        nav.tabBarItem.image = UIImage(named: unselectedImagename)?.withRenderingMode(.alwaysOriginal)
        nav.tabBarItem.selectedImage = UIImage(named: selectedImagename)?.withRenderingMode(.alwaysOriginal)
        return nav
    }
    
    func didFinshPickingMedia( _ picker : YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                
                let UploadPostVC = UploadPostController()
                UploadPostVC.selectedImage = selectedImage
                UploadPostVC.delegate = self
                UploadPostVC.currentUser = self.user

                let UploadPostNC = UINavigationController(rootViewController: UploadPostVC)
                UploadPostNC.modalPresentationStyle = .fullScreen
                self.present(UploadPostNC, animated: false, completion: nil)
            }
        }
    }
}

//MARK: - AuthenticationDelegate
extension MainTabController : AuthenticationDelegate {
    func authenticationDidComplete() {
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITabBarControllerDelegate
extension MainTabController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            
            didFinshPickingMedia(picker)
        }
        return true
    }
}

//MARK: - UploadPostControllerDelegate
extension MainTabController : UploadPostControllerDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        
        //RefreshingPostsAfterUpload
        guard let feedNC = viewControllers?[0] as? UINavigationController else { return }
        guard let feedVC = feedNC.viewControllers[0] as? FeedController else { return }
        feedVC.handleRefresh()
        
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)
        

        
    }
    
    
}
