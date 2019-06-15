//
//  TodayMultipleAppCell.swift
//  AppStoreJSONApis
//
//  Created by DARRELL A PAYNE on 5/10/19.
//  Copyright © 2019 DARRELL A PAYNE. All rights reserved.
//

import UIKit

class TodayMultipleAppCell: BaseTodayCell {
    
    override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
        }
    }
    
    let categoryLabel = UILabel(text: " Not", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "Nothing", font: .boldSystemFont(ofSize: 24),numberOfLines: 2)
    
    let multipleAppsViewController = TodayMultipleAppsController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        let stackView = VerticalStackView(arrangedSubviews: [
            categoryLabel,
            titleLabel,
            multipleAppsViewController.view
        ], spacing: 12)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
        
        backgroundColor = .white
        layer.cornerRadius = 16
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
