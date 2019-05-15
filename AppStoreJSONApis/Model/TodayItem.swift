//
//  TodayItem.swift
//  AppStoreJSONApis
//
//  Created by DARRELL A PAYNE on 5/8/19.
//  Copyright © 2019 DARRELL A PAYNE. All rights reserved.
//

import UIKit

struct TodayItem {
    
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let backgroundColor: UIColor
    
    // enum
    
    let cellType: Celltype
    
    enum Celltype: String {
        case single, multiple
    }
    
}
