//
//  AppsController.swift
//  AppStoreJSONApis
//
//  Created by DARRELL A PAYNE on 4/20/19.
//  Copyright © 2019 DARRELL A PAYNE. All rights reserved.
//

import UIKit

class AppsController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "id"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .yellow
        collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellID)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 250)
    }
    
    
    
}
