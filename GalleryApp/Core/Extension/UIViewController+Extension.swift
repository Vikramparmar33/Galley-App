//
//  UIViewController+Extension.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import UIKit

extension UIViewController {

    func showToast(_ message: String) {
        AppToastManager.shared.show(
            message: message,
            in: view
        )
    }

    func showSuccessToast(_ message: String) {
        AppToastManager.shared.showSuccess(
            message: message,
            in: view
        )
    }

    func showErrorToast(_ message: String) {
        AppToastManager.shared.showError(
            message: message,
            in: view
        )
    }
}
