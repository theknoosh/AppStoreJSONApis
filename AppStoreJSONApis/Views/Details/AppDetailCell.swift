//
//  AppDetailCell.swift
//  AppStoreJSONApis
//
//  Created by DARRELL A PAYNE on 4/30/19.
//  Copyright © 2019 DARRELL A PAYNE. All rights reserved.
//

import UIKit

class AppDetailCell: UICollectionViewCell {
    
    var app: Result! {
        didSet {
            nameLabel.text = app?.trackName
            releaseNotesLabel.text = app?.releaseNotes
            appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
            priceButton.setTitle(app?.formattedPrice ?? "", for: .normal)
        }
    }
    
    let appIconImageView = UIImageView(cornerRadius: 16)
    let nameLabel = UILabel(text: "App Name", font: .boldSystemFont(ofSize: 24), numberOfLines: 2)
    let priceButton = UIButton(title: "$4.99")
    let whatsNewLabel = UILabel(text: "What's New", font: .boldSystemFont(ofSize: 18))
    let releaseNotesLabel = UILabel(text: "Release Notes", font: .systemFont(ofSize: 16), numberOfLines: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        appIconImageView.backgroundColor = .blue
        appIconImageView.constrainWidth(constant: 100)
        appIconImageView.constrainHeight(constant: 100)
        
        priceButton.backgroundColor = #colorLiteral(red: 0.1726889312, green: 0.2602338791, blue: 0.9182187319, alpha: 1)
        priceButton.constrainHeight(constant: 32)
        priceButton.constrainWidth(constant: 75)
        priceButton.layer.cornerRadius = 32 / 2
        priceButton.setTitleColor(.white, for: .normal)
        priceButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        let stackView = VerticalStackView(arrangedSubviews: [
                UIStackView(arrangedSubviews: [
                    appIconImageView,
                    VerticalStackView(arrangedSubviews: [
                            nameLabel,
                            UIStackView(arrangedSubviews: [priceButton, UIView()]),
                            UIView()
                        ], spacing: 12)
                    ], customSpacing: 20),
                whatsNewLabel,
                releaseNotesLabel
            ], spacing: 6)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], customSpacing:CGFloat = 0) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.spacing = customSpacing
    }
}
