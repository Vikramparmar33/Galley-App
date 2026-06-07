//
//  UIImageViewX.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import UIKit

@IBDesignable
class UIImageViewX: UIImageView {

    private var dashedBorderLayer: CAShapeLayer?

    // MARK: - Inspectables

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
            updateDashedBorder()
        }
    }

    @IBInspectable var borderColor: UIColor? {
        didSet {
            updateDashedBorder()
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            updateDashedBorder()
        }
    }

    @IBInspectable var shadowColor: UIColor? {
        get { guard let cgColor = layer.shadowColor else { return nil }
              return UIColor(cgColor: cgColor) }
        set { layer.shadowColor = newValue?.cgColor }
    }

    @IBInspectable var shadowOpacity: Float {
        get { layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable var isDashedBorder: Bool = false {
        didSet {
            updateDashedBorder()
        }
    }

    @IBInspectable var dashedBorderColor: UIColor = .black {
        didSet {
            updateDashedBorder()
        }
    }

    @IBInspectable var dashLength: Int = 6 {
        didSet {
            updateDashedBorder()
        }
    }

    @IBInspectable var dashGap: Int = 3 {
        didSet {
            updateDashedBorder()
        }
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        updateDashedBorder()
    }

    private func updateDashedBorder() {
        // Remove old dashed border
        dashedBorderLayer?.removeFromSuperlayer()
        dashedBorderLayer = nil

        if isDashedBorder {
            // Clear solid border
            self.layer.borderWidth = 0

            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = dashedBorderColor.cgColor
            shapeLayer.lineDashPattern = [NSNumber(value: dashLength), NSNumber(value: dashGap)]
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = borderWidth
            shapeLayer.frame = bounds
            shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath

            layer.addSublayer(shapeLayer)
            dashedBorderLayer = shapeLayer
        } else {
            // Solid border fallback
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = borderColor?.cgColor
        }
    }
}
