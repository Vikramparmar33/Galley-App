//
//  AlertManager.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import UIKit
import Toast

final class AppToastManager {

    static let shared = AppToastManager()

    private init() {
        configureAppearance()
    }

    private func configureAppearance() {
        var style = ToastStyle()

        style.cornerRadius = 12
        style.messageColor = .white
        style.titleColor = .white

        ToastManager.shared.style = style
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.isQueueEnabled = true
    }

    func show(message: String, in view: UIView, duration: TimeInterval = 3.0) {
        showOnWindow(message: message, duration: duration)
    }

    func showSuccess(message: String, in view: UIView) {
        showOnWindow(message: message, duration: 3.0)
    }

    func showError(message: String, in view: UIView) {
        showOnWindow(message: message, duration: 3.0)
    }
    
    // MARK: - Private Core Method
    private func showOnWindow(message: String, duration: TimeInterval) {

        guard let window = UIApplication.shared.currentKeyWindow else {
            return
        }

        window.hideAllToasts()
        window.makeToast(message, duration: duration, position: .top)
    }
}
