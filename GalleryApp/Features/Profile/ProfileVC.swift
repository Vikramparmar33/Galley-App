//
//  ProfileVC.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import UIKit
import Toast

class ProfileVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var appBarView: CustomAppBarView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signOutButtonView: CustomButtonView!
    
    // MARK: - Variables
    private let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        setProfileData()
    }
    
    // MARK: - Functions
    private func setProfileData() {
        viewModel.loadUser()
        
        nameLabel.text = viewModel.name
        emailLabel.text = viewModel.email
        
        if let url = URL(string: viewModel.profileImageURL) {

            profileImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "img_profile_placeholder"),
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        }
        
    }
    
    private func initializeView() {
        appBarView.configure(title: "Profile", isHideBackButton: true)
        signOutButtonView.configure(
            titleText: "Sign Out",
            backgroundColor: .red,
            titleColor: .white
        )
        
        signOutButtonView.onButtonClick = { [weak self] in
            guard let self = self else { return }
            self.showSigoutAlert()
        }
        
    }
    
}

//MARK: - Google Sign In Delegates
extension ProfileVC: GoogleLogoutDelegate {

    func onGoogleLogoutSuccess() {
        viewModel.clearUser()
        NavigationManager.shared.showLoginScreen()
        showSuccessToast("Google Sign Out Sucessfully")
    }

    func onGoogleLogoutFailure(error: NSError) {
        debugPrint(error.localizedDescription)
        showErrorToast(error.localizedDescription)
    }

}


extension ProfileVC {
    
    private func showSigoutAlert() {
        
        let alert = UIAlertController(
            title: "Sign Out",
            message: "Are you sure you want to sigout?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        )
        
        let logoutAction = UIAlertAction(
            title: "Sigout",
            style: .destructive
        ) { _ in
            GoogleLoginManager.sharedInstance.logoutDelegate = self
            GoogleLoginManager.sharedInstance.signOut()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        
        present(alert, animated: true)
    }
}
