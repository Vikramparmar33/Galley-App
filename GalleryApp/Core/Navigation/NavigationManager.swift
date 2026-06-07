//
//  NavigationManager.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import UIKit

final class NavigationManager {

    static let shared = NavigationManager()

    private init() {}

    private var window: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first { $0.isKeyWindow }
    }

    func setupRootViewController() {

        DispatchQueue.main.async {

            let isLoggedIn = Utility.getAccessToken() != nil && UserDefaultsManager.getGoogleUser() != nil

            if isLoggedIn {
                self.showTabbarScreen()
            } else {
                self.showLoginScreen()
            }
        }
    }

    func showTabbarScreen() {
        guard let vc = STORYBOARD.main.instantiateViewController(withIdentifier: "TabbarVC") as? TabbarVC else { return }
        setRootViewController(vc)
    }

    func showLoginScreen() {
        guard let vc = STORYBOARD.main.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
        setRootViewController(vc)
    }

    private func setRootViewController(_ vc: UIViewController) {

        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true

        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}
