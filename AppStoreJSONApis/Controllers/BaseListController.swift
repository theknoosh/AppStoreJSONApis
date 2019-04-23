//
//  BaseListController.swift
//  AppStoreJSONApis
//
//  Created by DARRELL A PAYNE on 4/21/19.
//  Copyright © 2019 DARRELL A PAYNE. All rights reserved.
//

import UIKit

class BaseListController: UICollectionViewController {
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
