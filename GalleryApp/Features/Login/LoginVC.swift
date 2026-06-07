//
//  ViewController.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import UIKit
import GoogleSignIn

class LoginVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var googleSignInButtonView: CustomButtonView!
    
    // MARK: - Variables
    let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    // MARK: - Functions
    private func initializeView(){
        googleSignInButtonView.configure(
            titleText: "Sign in with Google",
            image: UIImage(named: "ic_google"),
            backgroundColor: .white
        )
        
        googleSignInButtonView.onButtonClick = { [weak self] in
            guard let self = self else { return }
            self.setButtonLoader(true)
            GoogleLoginManager.sharedInstance.loginDelegate = self
            GoogleLoginManager.sharedInstance.signIn(from: self)
        }
        
    }
    
    private func setButtonLoader(_ isLoading: Bool) {
        googleSignInButtonView.button.isLoading = isLoading
    }

}

//MARK: - Google Sign In Delegates
extension LoginVC: GoogleLoginDelegate {
    
    func onGoogleLoginSuccess(user: GIDGoogleUser) {
        setButtonLoader(false)
        viewModel.saveUser(user)
        NavigationManager.shared.showTabbarScreen()
        showSuccessToast("Google Sign In Sucessfully")
    }
    
    func onGoogleLoginFailure(error: NSError) {
        setButtonLoader(false)
        debugPrint(error.localizedDescription)
        showErrorToast(error.localizedDescription)
    }
}

