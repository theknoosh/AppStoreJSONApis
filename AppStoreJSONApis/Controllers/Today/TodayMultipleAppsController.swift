//
//  TodayMultipleAppsController.swift
//  AppStoreJSONApis
//
//  Created by DARRELL A PAYNE on 6/7/19.
//  Copyright © 2019 DARRELL A PAYNE. All rights reserved.
//

import UIKit

class TodayMultipleAppsController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    var results = [FeedResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        
        collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)
                
        Service.shared.fetchPopular{(appGroup,err) in
            self.results = appGroup?.feed.results ?? []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(4, results.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MultipleAppCell
        
        cell.nameLabel.text = results[indexPath.item].name
        cell.companyLabel.text = results[indexPath.item].artistName
//        cell.imageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
        cell.imageView.sd_setImage(with: URL(string: results[indexPath.item].artworkUrl100))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Calculate space needed to fit all cells and spacing between
        let height:CGFloat = (collectionView.frame.height - 3 * spacing) / 4
        
        return .init(width: view.frame.width, height: height)
    }
    
    fileprivate let spacing: CGFloat = 16
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
}
