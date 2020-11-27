//
//  FeedController.swift
//  Instagram2020
//
//  Created by ParteekSJamwal on 11/22/20.
//  Copyright © 2020 ParteekSJamwal. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

private let cellIdentifier = "FeedCell"

class FeedController : UICollectionViewController {
    //MARK: - Properties
    private var posts = [Post]() {
        didSet { collectionView.reloadData() }
    }
    var post : Post?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
    }
    
    //MARK: - API
    func fetchPosts() {
        guard post == nil else { return }
        PostService.fetchPosts { posts in
            self.posts = posts
            self.collectionView.refreshControl?.endRefreshing()
            self.checkIfUserLikedPosts()
        }
    }
    
    func checkIfUserLikedPosts() {
        self.posts.forEach { post in
            PostService.checkIfUserLikedPost(post: post) { isLiked in
                if let index = self.posts.firstIndex(where: {$0.postID == post.postID }) {
                    self.posts[index].isLiked = isLiked
                }
            }
        }
    }
    
    //MARK: - Selectors
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            controller.delegate = self.tabBarController as? MainTabController
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG : FailedToSignOut")
        }
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchPosts()
    }
    
    //MARK: - Helpers
    func configureUI() {
        collectionView.backgroundColor = .white
        
        configureCollectionView()
        addRefreshControl()
        
        if post == nil {
            navigationItem.title = "Feed"
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        }
        
        navigationItem.title = "Post"
        
    }
    
    func configureCollectionView() {
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func addRefreshControl() {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
}

//MARK: - UICollectionViewDataSource
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if post == nil {
            return posts.count
        } else {
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        if let post = post {
            cell.post = post
        } else {
            cell.post = posts[indexPath.row]
        }
        
        return cell
    }
}


//MARK: - UICollectionViewDelegate
extension FeedController {
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FeedController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 110
        
        return CGSize(width: width, height: height)
    }
}

//MARK: - FeedCellDelegate
extension FeedController : FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String) {
        print("UID : \(uid)")
        UserService.fetchUser(withuid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeedCell, didLike post: Post) {
        guard let tab = tabBarController as? MainTabController else { return }
        guard let user = tab.user else { return }
        
        cell.post?.isLiked.toggle()
        
        if post.isLiked {
            PostService.unlikePost(post: post) { error in
                if let error = error {
                    print("DEBUG: FailedToUnlikePost - \(error.localizedDescription)")
                    return }
                cell.likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.post?.likes = post.likes - 1
            }
        } else {
            PostService.likePost(post: post) { error in
                if let error = error {
                    print("DEBUG: FailedToLikePost - \(error.localizedDescription)")
                    return }
                cell.likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.post?.likes = post.likes + 1
                
                NotificationService.uploadNotification(toUid: post.owneruid, fromUser: user, type: .like, post: post)
            }
        }
    }
    
    
}
