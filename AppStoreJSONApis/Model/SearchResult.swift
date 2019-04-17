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
    let trackName: String
    let primaryGenreName: String
    var averageUserRating: Float?
}
