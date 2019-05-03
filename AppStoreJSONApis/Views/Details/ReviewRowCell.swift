//
//  ReviewRowCell.swift
//  AppStoreJSONApis
//
//  Created by DARRELL A PAYNE on 5/1/19.
//  Copyright © 2019 DARRELL A PAYNE. All rights reserved.
//

import UIKit

class ReviewRowCell: UICollectionViewCell {
    
    let reviewsController = ReviewsController()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        
        addSubview(reviewsController.view)
        reviewsController.view.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
