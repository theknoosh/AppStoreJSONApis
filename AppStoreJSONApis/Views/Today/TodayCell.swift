//
//  TodayCell.swift
//  AppStoreJSONApis
//
//  Created by DARRELL A PAYNE on 5/4/19.
//  Copyright © 2019 DARRELL A PAYNE. All rights reserved.
//

import UIKit

class TodayCell: UICollectionViewCell {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "garden"))
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        layer.cornerRadius = 16
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.centerInSuperview(size: .init(width: 200, height: 200))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
