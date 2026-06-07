//
//  TabbarVC.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import UIKit

class TabbarVC: UITabBarController {
    // MARK: - Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height = self.view.safeAreaInsets.bottom + 64
        
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = height
        tabFrame.origin.y = self.view.frame.size.height - height
        
        self.tabBar.frame = tabFrame
        self.tabBar.setNeedsLayout()
        self.tabBar.layoutIfNeeded()
        
    }
    
    // MARK: - Functions
    
    // MARK: - Configure TabBar
    func configureTabBar(){
        
        let galleryVC = STORYBOARD.main.instantiateViewController(withIdentifier: "GalleryVC") as! GalleryVC
        let profileVC = STORYBOARD.main.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        
        let galleryViewController      = UINavigationController(rootViewController: galleryVC)
        let profileViewController      = UINavigationController(rootViewController: profileVC)
        
        galleryViewController.isNavigationBarHidden    = true
        profileViewController.isNavigationBarHidden = true
        
        galleryViewController.tabBarItem = UITabBarItem(
            title: "Gallery",
            image: UIImage(systemName: "photo.on.rectangle"),
            selectedImage: UIImage(systemName: "photo.on.rectangle.fill")
        )

        profileViewController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        viewControllers = [
            galleryViewController,
            profileViewController
        ]
        
        self.configureAppearanceAttributes()
        self.setupTabBarAppearance()
        
    }
    
    // MARK: - Configure Appearance Attributes
    private func configureAppearanceAttributes() {
        // Set tint color
        self.tabBar.tintColor = #colorLiteral(red: 0.03137254902, green: 0.1137254902, blue: 0.07450980392, alpha: 1)
        self.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.3803921569, green: 0.4196078431, blue: 0.4039215686, alpha: 1)
        
        // Set the unselected text color for tab bar items
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.03137254902, green: 0.1137254902, blue: 0.07450980392, alpha: 1)], for: .normal)
        
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        
        // Set background color
        self.tabBar.backgroundColor = UIColor.white
        //self.tabBar.backgroundColor = .clear
        
        if let customFont = UIFont(name: "Sarabun-SemiBold", size: 12) { // Adjust font size and name
            // Set the custom font for tab bar items
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: customFont], for: .normal)
            
        }
    }
    
    // MARK: - Setup TabBar Appearance
    private func setupTabBarAppearance() {
    
        // Add drop shadow to the tab bar
        self.tabBar.layer.shadowColor = UIColor.black.cgColor.copy(alpha: 0.25)
        self.tabBar.layer.shadowOpacity = 1
        self.tabBar.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.tabBar.layer.shadowRadius = 9
        
        // Apply corner radius to the tab bar
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.masksToBounds = false
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Optionally, you may want to adjust the bounds or frame to avoid clipping the shadow
        self.tabBar.layer.shadowPath = UIBezierPath(roundedRect: self.tabBar.bounds, cornerRadius: 20).cgPath
        
    }
    
    // MARK: - Create Tabbar Item
    private func createTabBarItem(tag: Int, title: String, imageName: String, selectedImageName: String) -> UITabBarItem{
        let tabBarItem =  UITabBarItem(
            title: title,
            image: UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal))
        tabBarItem.tag = tag
        
        return tabBarItem
    }
    
}
