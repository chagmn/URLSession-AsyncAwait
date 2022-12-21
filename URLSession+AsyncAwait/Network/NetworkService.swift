//
//  NetworkService.swift
//  URLSession+AsyncAwait
//
//  Created by ChangMin on 2022/12/17.
//

import Foundation

// 임시 에러정의
enum FetchError: Error {
    case invaildURL
    case invaildServerResponse
}

struct NetworkService {
    static func fetchImage(page: Int = 1) async throws -> [Image] {
        let key = "_qHlB1wp5K6j4OdRuXa_AXImQonuJjDDOIHUDJ27ppE"
        let urlString = "https://api.unsplash.com/photos?client_id=\(key)&page=\(page)&per_page=30&orientation=landscape"
        
        guard let url = URL(string: urlString) else { throw FetchError.invaildURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.invaildServerResponse }
        let imageData = try JSONDecoder().decode([Image].self, from: data)
        return imageData
    }
}
