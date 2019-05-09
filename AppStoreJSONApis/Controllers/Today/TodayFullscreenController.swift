//
//  TodayFullscreenController.swift
//  AppStoreJSONApis
//
//  Created by DARRELL A PAYNE on 5/5/19.
//  Copyright © 2019 DARRELL A PAYNE. All rights reserved.
//

import UIKit

class TodayFullscreenController: UITableViewController {
    
    var dismissHandler: (() ->())?
    var todayItem: TodayItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.item == 0 {
            return 400
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            let headerCell = TodayFullscreenHeaderCell()
            headerCell.closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
            headerCell.todayCell.todayItem = todayItem
            return headerCell
        }
        
        let cell = TodayFullscreenDescriptionCell()
        
        return cell
    }
    
    @objc fileprivate func handleDismiss(button: UIButton){
        button.isHidden = true
        dismissHandler?()
    }
}
