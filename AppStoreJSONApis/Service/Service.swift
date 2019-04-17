//
//  Service.swift
//  AppStoreJSONApis
//
//  Created by DARRELL A PAYNE on 4/17/19.
//  Copyright © 2019 DARRELL A PAYNE. All rights reserved.
//

import Foundation

class Service {
    static let shared = Service() // Singleton
    
    func fetchApps(completion: @escaping ([Result], Error?) -> ()) {
        let urlString = "https://itunes.apple.com/search?term=instagram&entity=software"
        guard let url = URL(string: urlString) else {return}
        
        // fetch data from internet
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch apps:", err)
                completion([], nil)
                return
            }
            // success
            
            guard let data = data else {return}
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(searchResult.results, nil)
                
            } catch {
                print("Failed to decode JSON", error)
                completion([], error)
            }
            
            
            }.resume() // fires off request
    }
}
