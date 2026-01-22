//
//  RMLocationsResponse.swift
//  RickAndMorty
//
//  Created by Montorio Lopez, Georgina on 8/1/26.
//

// MARK: - RMLocationsResponse
struct RMLocationsResponse: Codable {
    
    let info: RMInfoDTO
    let results: [RMLocationDTO]
}

// MARK: - RMLocationsDTO
struct RMLocationDTO: Codable {
    
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
