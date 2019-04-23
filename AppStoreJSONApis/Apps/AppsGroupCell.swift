//
//  AppsGroupCell.swift
//  AppStoreJSONApis
//
//  Created by DARRELL A PAYNE on 4/21/19.
//  Copyright © 2019 DARRELL A PAYNE. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
    }
}

class AppsGroupCell: UICollectionViewCell {
    
    let titleLabel = UILabel(text: "App Section", font: .boldSystemFont(ofSize: 20))
    
    let horizontalController = AppsHorizontalController()
    
    
//    let titleLabel:UILabel = {
//        let label = UILabel()
//        label.text = "App Section"
//        label.font = .boldSystemFont(ofSize: 30)
//        return label
//
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
        addSubview(horizontalController.view)
        horizontalController.view.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
