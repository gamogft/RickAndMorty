//
//  RickAndMortyAPI.swift
//  RickAndMorty
//
//  Created by Montorio Lopez, Georgina on 8/1/26.
//

struct RickAndMortyAPIConfig {
    static let baseURL = "https://rickandmortyapi.com/api/"
}

enum RickAndMortyAPI {
    
    case characters(Int?)
    case locations(Int?)
    case episodes(Int?)
        
    func getResourcePath() -> String {
        switch self {
        case .characters(let id):
            if let id {
                return RickAndMortyAPIConfig.baseURL + "character/\(id)"
            } else {
                return RickAndMortyAPIConfig.baseURL + "character"
            }
        case .locations(let id):
            if let id {
                return RickAndMortyAPIConfig.baseURL + "location/\(id)"
            } else {
                return RickAndMortyAPIConfig.baseURL + "location"
            }
        case .episodes(let id):
            if let id {
                return RickAndMortyAPIConfig.baseURL + "episode/\(id)"
            } else {
                return RickAndMortyAPIConfig.baseURL + "episode"
            }
        }
    }
}
