//
//  ProfileViewController.swift
//  unsplash_practice
//
//  Created by Денис Петров on 14.06.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userCredentialsLabel: UILabel!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var userTagLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    private var profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        setNotificationObserver()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        removeObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfileDetails(profile: profileService.profile)
        setNotificationObserver()
        updateAvatar()
    }
    
    private func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
        userCredentialsLabel.text = profile.name
        userTagLabel.text = profile.username
        descriptionLabel.text = profile.bio
    }
    
    @IBAction func didLogoutTap(_ sender: UIButton) {
        
    }
    
    private func setNotificationObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
    }
    
    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL)
        else {
            return
        }
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        avatarImageView.kf.setImage(with: url, placeholder: UIImage(named: "avatar"), options: [.processor(processor)])
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: ProfileImageService.didChangeNotification,
            object: nil)
    }
}

