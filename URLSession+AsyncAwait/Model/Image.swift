//
//  Image.swift
//  URLSession+AsyncAwait
//
//  Created by ChangMin on 2022/12/17.
//

import Foundation

struct Image: Codable {
    let width: Int
    let height: Int
    let links: ImageLink
    let urls: ImageURL
}

struct ImageLink: Codable {
    let downloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case downloadURL = "download"
    }
}

struct ImageURL: Codable {
    let thumbURL: String
    
    enum CodingKeys: String, CodingKey {
        case thumbURL = "small"
    }
}
