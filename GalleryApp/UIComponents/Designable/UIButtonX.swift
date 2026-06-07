//
//  UIButtonX.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import UIKit

@IBDesignable
class UIButtonX: UIButton {

    // MARK: - Inspectable Properties
    
    @IBInspectable var fontWeight: Int = 400 {
        didSet {
            updateFont()
        }
    }

    @IBInspectable var fontSize: CGFloat = 14 {
        didSet {
            updateFont()
        }
    }


    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var isBlackLoading: Bool = false {
        didSet {
            activityIndicator.color = isBlackLoading ? .black : .white
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        didSet {
            setShadowProperties()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            setShadowProperties()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet {
            setShadowProperties()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            setShadowProperties()
        }
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            buttonBackgroundColor = backgroundColor
        }
    }

    // MARK: - Properties

    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private var originalTitle: String?
    private var originalImage: UIImage?
    private var buttonBackgroundColor: UIColor?

    var isLoading: Bool = false {
        didSet {
            updateLoadingState()
        }
    }

    var isDisable: Bool = false {
        didSet {
            updateDisableState()
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup

    private func setup() {

        buttonBackgroundColor = backgroundColor

        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor

        setupActivityIndicator()
        updateFont()
        setShadowProperties()
    }
    
    private func updateFont() {
        guard let weight = FontWeight(rawValue: fontWeight) else { return }
        titleLabel?.font = FontManager.font(weight: weight, size: fontSize)
    }

    private func setupActivityIndicator() {

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = isBlackLoading ? .black : .white

        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Loading State

    private func updateLoadingState() {

        if isLoading {

            originalTitle = title(for: .normal)
            originalImage = image(for: .normal)

            setTitle("", for: .normal)
            setImage(nil, for: .normal)

            activityIndicator.startAnimating()

            isEnabled = false

            backgroundColor = buttonBackgroundColor?.withAlphaComponent(0.5)

        } else {

            setTitle(originalTitle, for: .normal)
            setImage(originalImage, for: .normal)

            activityIndicator.stopAnimating()

            isEnabled = true

            backgroundColor = buttonBackgroundColor
        }
    }

    // MARK: - Disable State

    private func updateDisableState() {

        if isDisable {

            isEnabled = false
            backgroundColor = buttonBackgroundColor?.withAlphaComponent(0.5)

        } else {

            isEnabled = true
            backgroundColor = buttonBackgroundColor
        }
    }
    
    private func setShadowProperties() {
        guard let shadowColor = shadowColor else { return }
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
    }
}

