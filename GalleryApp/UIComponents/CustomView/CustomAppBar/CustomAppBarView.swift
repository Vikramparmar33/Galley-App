//
//  CustomAppBarView.swift
//  Towy Customer
//
//  Created by iMac on 01/08/24.
//

import UIKit

class CustomAppBarView: NibView {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonView: UIView!
    
    // MARK: - Variables
    var onBackClick: (()->())?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        self.onBackClick?()
    }
    
    func configure(title: String, isHideBackButton: Bool = false){
        self.titleLabel.text = title
        self.backButtonView.isHidden = isHideBackButton
        
        self.backButton.titleLabel?.font = FontManager.font(weight: FontWeight.regular, size: 12)
        self.backButton.titleLabel?.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
        
    }
    
}
