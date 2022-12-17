//
//  NetworkService.swift
//  URLSession+AsyncAwait
//
//  Created by ChangMin on 2022/12/17.
//

import Foundation

struct NetworkService {
    static func fetchImage(page: Int = 1, completion: @escaping ([Image]) -> Void) {
        let key = "_qHlB1wp5K6j4OdRuXa_AXImQonuJjDDOIHUDJ27ppE"
        let urlString = "https://api.unsplash.com/photos?client_id=\(key)&page=\(page)&per_page=30&orientation=landscape"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    
                } else if let response = response as? HTTPURLResponse, let data = data {
                    if response.statusCode > 400 { return }
                    
                    do {
                        let imageData = try JSONDecoder().decode([Image].self, from: data)
                        completion(imageData)
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }.resume()
        }
    }
}
