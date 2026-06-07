//
//  CustomButton.swift
//  Towy Customer
//
//  Created by iMac on 24/07/24.
//

import UIKit

class CustomButtonView: NibView{
    
    // MARK: - Outlets
    @IBOutlet weak var button: UIButtonX!
    
    // MARK: - Clouser
    var onButtonClick: (()->())?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - IBActions
    @IBAction func onButtonClick(_ sender: UIButton) {
        onButtonClick?()
    }
    
    // MARK: - Functions
    func configure(
        titleText: String,
        image: UIImage? = nil,
        backgroundColor: UIColor = .primaryColor,
        titleColor: UIColor = .secondaryColor
    ) {
        button.setTitle(titleText, for: .normal)
        button.setImage(image, for: .normal)

        button.backgroundColor = backgroundColor
        button.setTitleColor(titleColor, for: .normal)

        button.titleEdgeInsets = image == nil
            ? .zero
            : UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
}
