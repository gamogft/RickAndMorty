//
//  RMEpisodesResponse.swift
//  RickAndMorty
//
//  Created by Montorio Lopez, Georgina on 8/1/26.
//

// MARK: - RMEpisodesResponse
struct RMEpisodesResponse: Codable {
    
    let info: RMInfoDTO
    let results: [RMEpisodeDTO]
}

// MARK: - RMEpisodeDTO
struct RMEpisodeDTO: Codable {
    
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
