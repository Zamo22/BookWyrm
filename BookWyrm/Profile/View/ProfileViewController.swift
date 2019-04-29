//
//  AccountViewController.swift
//  BookWyrm
//
//  Created by Zaheer Moola on 2019/04/29.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit
import SafariServices

class ProfileViewController: UIViewController, SFSafariViewControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var joinedDateLabel: UILabel!
    @IBOutlet weak var numFriendsLabel: UILabel!
    @IBOutlet weak var numGroupsLabel: UILabel!
    @IBOutlet weak var numReviewsLabel: UILabel!
    @IBOutlet weak var friendsView: UIView!
    @IBOutlet weak var groupsView: UIView!
    @IBOutlet weak var reviewsView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    lazy var vModel: ProfileViewModelling = { return ProfileViewModel(view: self, repo: ProfileRepository()) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vModel.getUserInfo()
        loadingIndicator.startAnimating()
        loadingIndicator.hidesWhenStopped = true
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        let preferences = UserDefaults.standard
        let idKey = "userID"
        let ouathKey = "oauth"
        
        preferences.removeObject(forKey: idKey)
        preferences.removeObject(forKey: ouathKey)
        
        let urlString = "https://www.goodreads.com/user/sign_out"
        
        let safariVC = SFSafariViewController(url: NSURL(string: urlString)! as URL)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        closeApplication()
    }
    
    func closeApplication () {
        let exitAppAlert = UIAlertController(title: "Restart is needed",
                                             message: "We need to restart to properly log you out.\n Please reopen the app after this.",
                                             preferredStyle: .alert)
        
        let resetApp = UIAlertAction(title: "Close Now", style: .destructive) {
            (alert) -> Void in
            // home button pressed programmatically - to thorw app to background
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            // terminaing app in background
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                exit(EXIT_SUCCESS)
            })
        }
        
        let laterAction = UIAlertAction(title: "Later", style: .cancel) {
            (alert) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        
        exitAppAlert.addAction(resetApp)
        exitAppAlert.addAction(laterAction)
        present(exitAppAlert, animated: true, completion: nil)
    }
    
    @objc func friendsButtonTapped(gesture: UIGestureRecognizer) {
        //Temporary code to show that buttons would be clickable
        self.friendsView.backgroundColor = .groupTableViewBackground
    }
}

extension ProfileViewController: ProfileViewControllable {
    
    func setUserInfo(userProfile: ProfileModel) {
        self.profileImage.fetchImage(url: userProfile.profileImageLink)
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.masksToBounds = false
        self.profileImage.layer.borderColor = UIColor.black.cgColor
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
        self.profileImage.clipsToBounds = true
        
        self.userNameLabel.text = userProfile.name
        self.joinedDateLabel.text = userProfile.joinDate
        self.numFriendsLabel.text = userProfile.numFriends
        self.numGroupsLabel.text = userProfile.numGroups
        self.numReviewsLabel.text = userProfile.numReviews
        
         let friendTapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.friendsButtonTapped(gesture:)))
         self.friendsView.addGestureRecognizer(friendTapGesture)
        
        loadingIndicator.stopAnimating()
    }
}
