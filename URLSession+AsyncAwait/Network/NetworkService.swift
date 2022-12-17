//
//  NetworkService.swift
//  URLSession+AsyncAwait
//
//  Created by ChangMin on 2022/12/17.
//

import Foundation

final class NetworkService {
    private let key = "_qHlB1wp5K6j4OdRuXa_AXImQonuJjDDOIHUDJ27ppE"
    
    func fetchImage(page: Int = 1) {
        let urlString = "https://api.unsplash.com/photos?client_id=\(key)&page=\(page)&per_page=30&orientation=landscape"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    
                } else if let response = response as? HTTPURLResponse, let data = data {
                    print(response)
                    print(data)
                }
            }.resume()
        }
    }
}
