//
//  UILabelX.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import UIKit

@IBDesignable
class UILabelX: UILabel {
    
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
    
    @IBInspectable var letterSpacing: CGFloat = 0 {
        didSet {
            updateAttributedText()
        }
    }
    
    @IBInspectable var isUpperCase: Bool = false {
        didSet {
            updateAttributedText()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        updateFont()
        updateAttributedText()
    }

    private func updateFont() {
        guard let weight = FontWeight(rawValue: fontWeight) else { return }
        let fontName = "\(FontManager.fontName)-\(weight.suffix)"
        self.font = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    private func updateAttributedText() {
        guard let originalText = self.text else { return }
        let processedText = isUpperCase ? originalText.uppercased() : originalText
        let attributedString = NSMutableAttributedString(string: processedText)
        attributedString.addAttribute(.kern, value: letterSpacing, range: NSRange(location: 0, length: processedText.count))
        self.attributedText = attributedString
    }
}
