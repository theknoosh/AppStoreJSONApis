//
//  AppGroup.swift
//  AppStoreJSONApis
//
//  Created by DARRELL A PAYNE on 4/25/19.
//  Copyright © 2019 DARRELL A PAYNE. All rights reserved.
//

import Foundation

struct AppGroup: Decodable {
    let feed: Feed
}

struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}

struct FeedResult: Decodable {
    let name, artistName, artworkUrl100: String
    
}
