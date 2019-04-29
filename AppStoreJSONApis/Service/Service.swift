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
    
    func fetchApps(searchTerm: String, completion: @escaping ([Result], Error?) -> ()) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
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
    
    func fetchPopular(completion: @escaping (AppGroup?, Error?) -> ()) {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-apps-we-love/all/50/explicit.json"
        fetchAppGroup(urlString: urlString, completion: completion)
        
    }
    
    func fetchTopFree(completion: @escaping (AppGroup?, Error?) -> ()) {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/50/explicit.json"
        fetchAppGroup(urlString: urlString, completion: completion)
        
    }
    
    func fetchTopGrossing(completion: @escaping (AppGroup?, Error?) -> ()) {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/50/explicit.json"
        fetchAppGroup(urlString: urlString, completion: completion)
        
    }
    
    // Helper
    func fetchAppGroup(urlString: String, completion: @escaping (AppGroup?, Error?)-> Void){
        
        guard let url = URL(string: urlString)
            else {return}
        URLSession.shared.dataTask(with: url){ (data, resp, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            
            do {
                let appGroup = try JSONDecoder().decode(AppGroup.self, from: data!)
                
                // Success
                completion(appGroup, nil)
            } catch {
                // Failure
                completion(nil, error)
                print("Failed to decode:", error)
            }
            
        }.resume() // This will fire your request
    }
    
    func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> Void) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        
        guard let url = URL(string: urlString)
            else {return}
        
        URLSession.shared.dataTask(with: url){ (data, resp, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            
            do {
                let objects = try JSONDecoder().decode([SocialApp].self, from: data!)
                
                // Success
                completion(objects, nil)
            } catch {
                // Failure
                completion(nil, error)
                print("Failed to decode:", error)
            }
            
            }.resume() // This will fire your request
    }
}
