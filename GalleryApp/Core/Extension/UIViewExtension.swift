//
//  UIViewExtension.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import UIKit

class NibView: UIView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        loadContentViewFromNib()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadContentViewFromNib()
    }
}

private extension NibView {
    func loadContentViewFromNib() {
        backgroundColor = UIColor.clear
        let contentView = loadNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
}

extension UIView {
    /// Loads UIView from a XIB file with the same name.
    fileprivate func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
