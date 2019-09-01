//
//  TodayController.swift
//  AppStoreJSONApis
//
//  Created by DARRELL A PAYNE on 5/4/19.
//  Copyright © 2019 DARRELL A PAYNE. All rights reserved.
//

import UIKit

class TodayController: BaseListController,UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout {
    
    var items = [TodayItem]()
    
    // Spinner when loading
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0
        
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
                TodayItem.init(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way", backgroundColor: .white, cellType: .single, apps: []),
                TodayItem.init(category: "THE DAILY LIST", title: topGrossingGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: topGrossingGroup?.feed.results ?? []),
                TodayItem.init(category: "THE DAILY LIST", title: newGamesGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: newGamesGroup?.feed.results ?? []),
                TodayItem.init(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything", backgroundColor: #colorLiteral(red: 0.9834489226, green: 0.9625311494, blue: 0.7273532748, alpha: 1), cellType: .single, apps: [])
            ]
            
            self.collectionView.reloadData()
        }
        
    }
    
    var todayFullscreenController: TodayFullscreenController!
    
    fileprivate func showDailyListFullScreen(_ indexPath: IndexPath) {
        let fullController = TodayMultipleAppsController(mode: .fullscreen)
        fullController.results = self.items[indexPath.item].apps
        present(UINavigationController(rootViewController: fullController), animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch items[indexPath.item].cellType {
        case .multiple:
            showDailyListFullScreen(indexPath)
        default:
            showSingleAppFullscreen(indexPath: indexPath)
        }
    }
    
    fileprivate func setupSingleAppFullscreenController(_ indexPath: IndexPath){
        
        let todayFullscreenController = TodayFullscreenController()
        todayFullscreenController.todayItem = items[indexPath.row]
        
        todayFullscreenController.dismissHandler = {
            self.handleTodayFullscreenDismissal()
        }
        todayFullscreenController.view.layer.cornerRadius = 16
        self.todayFullscreenController = todayFullscreenController
        
        // #1 setup our pan gesture
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self
        
        todayFullscreenController.view.addGestureRecognizer(gesture)
        // #2 add a blur effect on view
        
        // #3 not to interfere with our UITableView scrolling
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    var appFullscreenBeginOffset: CGFloat = 0
    
    @objc fileprivate func handleDrag(gesture: UIPanGestureRecognizer){
        if gesture.state == .began {
            appFullscreenBeginOffset = todayFullscreenController.tableView.contentOffset.y
        }
        
        
        let translationY = gesture.translation(in: todayFullscreenController.view).y
        
        if todayFullscreenController.tableView.contentOffset.y > 0 {
            return
        }
        
        if gesture.state == .changed {
            if translationY > 0 {
                
                let trueOffset = translationY - appFullscreenBeginOffset
                var scale = 1 - trueOffset / 1000
                
                print(trueOffset, scale)
                scale = min(1, scale) // clamps scale to no higher than 1
                scale = max(0.5, scale)
                
                let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
                self.todayFullscreenController.view.transform = transform
            }
            
        }else if gesture.state == .ended {
            if translationY > 0 {
                handleTodayFullscreenDismissal()
            }
        }
        
        
        
        
    }
    
    fileprivate func setupStartingCellFrame(_ indexPath: IndexPath){
        
        guard let cell = collectionView.cellForItem(at: indexPath) else {return}
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else {return}
        
        self.startingFrame = startingFrame
    }
    
    fileprivate func setupAppFullscreenStartingPostion(_ indexPath: IndexPath) {
        let fullscreenView = todayFullscreenController.view!
        view.addSubview(fullscreenView)
        
        addChild(todayFullscreenController)
        
        setupStartingCellFrame(indexPath)
        
        guard let startingFrame = self.startingFrame else {return}
        
        self.anchoredConstraints = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))
        
        self.view.layoutIfNeeded() // starts the animation
    }
    
    var anchoredConstraints: AnchoredConstraints?
    
    fileprivate func beginAnimationAppFullscreen() {
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurVisualEffectView.alpha = 1
            self.anchoredConstraints?.top?.constant = 0
            self.anchoredConstraints?.leading?.constant = 0
            self.anchoredConstraints?.width?.constant = self.view.frame.width
            self.anchoredConstraints?.height?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded() // starts the animation
            
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            guard let cell = self.todayFullscreenController.tableView.cellForRow(at: [0,0]) as? TodayFullscreenHeaderCell else {return}
            
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    fileprivate func showSingleAppFullscreen(indexPath: IndexPath) {
        
        // #1
        setupSingleAppFullscreenController(indexPath)
        
        // #2 setup fullscreen in its starting position
        setupAppFullscreenStartingPostion(indexPath)
        
        // #3 begin the fullscreen animation
        beginAnimationAppFullscreen()
        
    }
    
    var startingFrame: CGRect?
    
    @objc func handleTodayFullscreenDismissal() {
        
        // Access starting frame
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.todayFullscreenController.tableView.contentOffset = .zero
            self.blurVisualEffectView.alpha = 0
            self.todayFullscreenController.view.transform = .identity
            
            guard let startingFrame = self.startingFrame else {return}
            
            self.anchoredConstraints?.top?.constant = startingFrame.origin.y
            self.anchoredConstraints?.leading?.constant = startingFrame.origin.x
            self.anchoredConstraints?.width?.constant = startingFrame.width
            self.anchoredConstraints?.height?.constant = startingFrame.height
            
            self.view.layoutIfNeeded() // starts the animation
            
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 0)
            
            guard let cell = self.todayFullscreenController.tableView.cellForRow(at: [0,0]) as? TodayFullscreenHeaderCell else {return}
            
//            cell.closeButton.alpha = 0
            self.todayFullscreenController.closeButton.alpha = 0
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
        
        (cell as? TodayMultipleAppCell)?.multipleAppsViewController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
        
        return cell
    }
    
    @objc fileprivate func handleMultipleAppsTap(gesture: UIGestureRecognizer) {
       let collectionView = gesture.view
        
        var superview = collectionView?.superview
        while superview != nil {
            if let cell = superview as? TodayMultipleAppCell {
                
                guard let indexPath = self.collectionView.indexPath(for: cell) else {return}
                
                let apps = self.items[indexPath.item].apps
                
                let fullController = TodayMultipleAppsController(mode: .fullscreen)
                
                fullController.results = apps
                present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
                return
            }
            superview = superview?.superview
            
        }
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
