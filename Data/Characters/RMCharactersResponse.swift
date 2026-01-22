//
//  RMCharactersResponse.swift
//  RickAndMorty
//
//  Created by Montorio Lopez, Georgina on 8/1/26.
//

// MARK: - CharactersResponse
struct RMCharactersResponse: Codable {
    
    let info: RMInfoDTO
    let results: [RMCharacterDTO]
}

// MARK: - RMInfoDTO
struct RMInfoDTO: Codable {
    
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// MARK: - RMCharacterDTO
struct RMCharacterDTO: Codable {
    
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let origin: LocationDTO
    let location: LocationDTO
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - LocationDTO
struct LocationDTO: Codable {
    
    let name: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name, url
    }
}

enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
}
