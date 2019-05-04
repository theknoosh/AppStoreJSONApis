//
//  SearchResult.swift
//  AppStoreJSONApis
//
//  Created by DARRELL A PAYNE on 4/17/19.
//  Copyright © 2019 DARRELL A PAYNE. All rights reserved.
//

import Foundation

struct SearchResult:Decodable {
    let resultCount:Int
    let results: [Result]
}

struct Result:Decodable {
    let trackId: Int
    let trackName: String
    let primaryGenreName: String
    var averageUserRating: Float?
    let screenshotUrls: [String]
    let artworkUrl100: String // App Icon
    var formattedPrice: String?
    let description: String
    var releaseNotes: String?
}
