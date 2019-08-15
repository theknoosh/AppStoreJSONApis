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
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss(){
        dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mode == .fullscreen {
            setupCloseButton()
        } else {
            collectionView.isScrollEnabled = false
        }
        
        collectionView.backgroundColor = .white
        
        collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)
        
        // Mark: Removes space above list
        navigationController?.isNavigationBarHidden = true
        
    }
    
    override var prefersStatusBarHidden: Bool {return true}
    
    func setupCloseButton(){
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 16), size: .init(width: 44, height: 44))
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appId = self.results[indexPath.item].id
        let appDetailController = AppsDetailController(appId: appId)
        navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(appDetailController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if mode == .fullscreen {
            return results.count
        }
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
        let height:CGFloat = 74
        
        if mode == .fullscreen {
            return .init(width: view.frame.width - 48, height: height)
        }
        return .init(width: view.frame.width, height: height)
    }
    
    fileprivate let spacing: CGFloat = 16
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if mode == .fullscreen {
            return .init(top: 48, left: 24, bottom: 12, right: 24)
        }
        return .zero
    }
    
    fileprivate let mode: Mode
    
    enum Mode {
        case small, fullscreen
    }
    
    init(mode: Mode){
        self.mode = mode
        super.init()   
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
