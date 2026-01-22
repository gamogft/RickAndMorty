//
//  RMEpisode.swift
//  RickAndMorty
//
//  Created by Montorio Lopez, Georgina on 13/1/26.
//

struct RMEpisode: Hashable  {
    
    let id: Int
    let name: String
    let airDate: String
    let episodeCode: String
    
    init(id: Int, name: String, airDate: String, episodeCode: String) {
        self.id = id
        self.name = name
        self.airDate = airDate
        self.episodeCode = episodeCode
    }
}
