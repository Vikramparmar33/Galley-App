//
//  SplashVC.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigateAfterDelay()
    }
    
    private func navigateAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            NavigationManager.shared.setupRootViewController()
        }
    }
    
}
