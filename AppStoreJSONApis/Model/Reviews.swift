//
//  Reviews.swift
//  AppStoreJSONApis
//
//  Created by DARRELL A PAYNE on 5/2/19.
//  Copyright © 2019 DARRELL A PAYNE. All rights reserved.
//

import Foundation

struct Reviews: Decodable {
    let feed: ReviewFeed
}

struct ReviewFeed: Decodable {
    let entry: [Entry]
}

struct Entry: Decodable {
    let author: Author
    let title: Label
    let content: Label
}

struct Label: Decodable {
    let label: String
}

struct Author: Decodable {
    let name: Label
}
