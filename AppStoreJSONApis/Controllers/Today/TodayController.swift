//
//  TodayController.swift
//  AppStoreJSONApis
//
//  Created by DARRELL A PAYNE on 5/4/19.
//  Copyright © 2019 DARRELL A PAYNE. All rights reserved.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
    
//    fileprivate let cellId = "todayCellId"
//    fileprivate let multCellId = "multCellId"
    
//    let items = [
//        TodayItem.init(category: "THE DAILY LIST", title: "Top Grossing Games", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple),
//        TodayItem.init(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way", backgroundColor: .white, cellType: .single),
//        TodayItem.init(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything", backgroundColor: #colorLiteral(red: 0.9834489226, green: 0.9625311494, blue: 0.7273532748, alpha: 1), cellType: .single),
//        TodayItem.init(category: "MULTIPLE CELL", title: "Editors' Choice Games", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple)
//
//    ]
    
    var items = [TodayItem]()
    
    // Spinner when loading
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        
        fetchData()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = #colorLiteral(red: 0.890249042, green: 0.890249042, blue: 0.890249042, alpha: 1)
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.Celltype.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.Celltype.multiple.rawValue)        
    }
    
    fileprivate func fetchData(){
        // dispatch group
        
        var topGrossingGroup: AppGroup?
        var newGamesGroup: AppGroup?
        
    
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        Service.shared.fetchTopGrossing { (appGroup, err) in
            // Make sure to check errors later
            
            topGrossingGroup = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchGames { (appGroup, err) in
            
            newGamesGroup = appGroup
           dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print("Finished fetching DP")
            self.activityIndicatorView.stopAnimating()
            
            self.items = [
                TodayItem.init(category: "THE DAILY LIST", title: topGrossingGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: topGrossingGroup?.feed.results ?? []),
                TodayItem.init(category: "THE DAILY LIST", title: newGamesGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: newGamesGroup?.feed.results ?? []),
                TodayItem.init(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way", backgroundColor: .white, cellType: .single, apps: []),
                TodayItem.init(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything", backgroundColor: #colorLiteral(red: 0.9834489226, green: 0.9625311494, blue: 0.7273532748, alpha: 1), cellType: .single, apps: [])
            ]
            
            self.collectionView.reloadData()
        }
        
    }
    
    var todayFullscreenController: TodayFullscreenController!
    
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if items[indexPath.item].cellType == .multiple {
            let fullController = TodayMultipleAppsController(mode: .fullscreen)
            fullController.results = self.items[indexPath.item].apps
            present(fullController, animated: true)
            return
        }
        
        let todayFullscreenController = TodayFullscreenController()
        todayFullscreenController.todayItem = items[indexPath.row]
        
        todayFullscreenController.dismissHandler = {
            self.handleRemoveRedView()
        }
        
        let fullscreenView = todayFullscreenController.view!
        fullscreenView.layer.cornerRadius = 16
        view.addSubview(fullscreenView)
        
        addChild(todayFullscreenController)
        self.todayFullscreenController = todayFullscreenController
        
//        self.collectionView.isUserInteractionEnabled = false
        
        guard let cell = collectionView.cellForItem(at: indexPath) else {return}
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else {return}
        
        self.startingFrame = startingFrame
        
        // frame animations are not accurate
        // Instead use auto layout constraint animations
        fullscreenView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = fullscreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = fullscreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        widthConstraint = fullscreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = fullscreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)
        
        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach({$0?.isActive = true})
        self.view.layoutIfNeeded() // starts the animation
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded() // starts the animation
            
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            guard let cell = self.todayFullscreenController.tableView.cellForRow(at: [0,0]) as? TodayFullscreenHeaderCell else {return}
            
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    var startingFrame: CGRect?
    
    @objc func handleRemoveRedView() {
        
        // Access starting frame
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.todayFullscreenController.tableView.contentOffset = .zero
            
            guard let startingFrame = self.startingFrame else {return}
            
            self.topConstraint?.constant = startingFrame.origin.y
            self.leadingConstraint?.constant = startingFrame.origin.x
            self.widthConstraint?.constant = startingFrame.width
            self.heightConstraint?.constant = startingFrame.height
            
            self.view.layoutIfNeeded() // starts the animation
            
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 0)
            
            guard let cell = self.todayFullscreenController.tableView.cellForRow(at: [0,0]) as? TodayFullscreenHeaderCell else {return}
            
            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
            
        }, completion: {_ in
            
            self.todayFullscreenController.view.removeFromSuperview()
            self.todayFullscreenController.removeFromParent() // keeps from creating duplicates over and over again
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = items[indexPath.item].cellType
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId.rawValue, for: indexPath) as! BaseTodayCell
        
        cell.todayItem = items[indexPath.item]
        
        return cell
    }
    
    static let cellSize:CGFloat = 450
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}
