//
//  RMCharactersRequest.swift
//  RickAndMorty
//
//  Created by Montorio Lopez, Georgina on 8/1/26.
//

import Foundation

struct RMCharactersRequest: JSONAPIRequest {
    typealias APIResponse = RMCharactersResponse
    
    var decoder = JSONDecoder()
    var resourcePath: String = ""
    var method: HTTPMethod = .get
    var headers: [String: String] = [:]
    var page: String?
    
    var id: Int? = nil
    
    init(id: Int? = nil, page: String? = nil){
        self.resourcePath = RickAndMortyAPI.getResourcePath(.characters(id))()
        self.page = page
        self.id = id
    }
    
    var queryItems: [URLQueryItem] {
        if let page {
            [ URLQueryItem(name: "page", value: page) ]
        } else {
            []
        }
    }
}
