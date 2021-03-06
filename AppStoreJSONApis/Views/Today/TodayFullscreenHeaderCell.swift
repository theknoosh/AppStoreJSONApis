//
//  TodayFullscreenHeaderCell.swift
//  AppStoreJSONApis
//
//  Created by DARRELL A PAYNE on 5/6/19.
//  Copyright © 2019 DARRELL A PAYNE. All rights reserved.
//

import UIKit

class TodayFullscreenHeaderCell: UITableViewCell {
    let todayCell = TodayCell()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(todayCell)
        todayCell.fillSuperview()
        
//        addSubview(closeButton)
//        closeButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 24, left: 0, bottom: 0, right: 18), size: .init(width: 80, height: 80))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
