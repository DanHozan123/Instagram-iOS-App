//
//  ProfileController.swift
//  Instagram
//
//  Created by Dan Hozan on 18.02.2024.
//

import UIKit

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController{
    
    //MARK: - Properties
    private var user: User
    private var posts = [Post]()
    
    //MARK: - Lifecycle
    init(user: User){
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        checkIfUserIsFollowed()
        fetchUserStats()
        fetchPosts()
        
    }
    
    //MARK: - API
    func checkIfUserIsFollowed() {
        UserService.checkFfUserIsFollowed(uid: user.uid) { isFollow in
            self.user.isFollowed = isFollow
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats(){
        UserService.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    func fetchPosts() {
        PostService.fetchPosts(forUser: user.uid) { posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - Helpers
    func configureCollectionView(){
        navigationItem.title = user.username
        collectionView.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
}
//MARK: - UICollectionViewDataSource
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        header.delegate = self
        header.viewModel = ProfileHeaderViewModel(user: user)
        
          
        return header
    }
    
}

//MARK: - UICollectionViewDelegate
extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.post = posts[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
}


//MARK: - UICollectionViewDeleagteFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
    
}

//MARK: - ProfileHeaderDelegete
extension ProfileController : ProfileHeaderDelegate {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        guard let tab = tabBarController as? MainTabController else { return }
        guard let currentUser = tab.user else { return }
        
        if user.isCurrentUser{
            print("show edit profile")
        }else if user.isFollowed{
            UserService.unfollow(uid: user.uid) {error in
                self.user.isFollowed = false
                self.collectionView.reloadData()
                PostService.undateUserFeedAfterFollowing(user: user, didFollow: false)
                
            }
        } else {
            UserService.follow(uid: user.uid) {error in
                self.user.isFollowed = true
                self.collectionView.reloadData()
            }
            NotificationService.uploadNotification(toUid: user.uid, fromUser: currentUser, type: .follow)
            PostService.undateUserFeedAfterFollowing(user: user, didFollow: true)
        }
    }

    
}
