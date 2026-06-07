//
//  UIApplication+Extension.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import UIKit

extension UIApplication {

    var currentKeyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
