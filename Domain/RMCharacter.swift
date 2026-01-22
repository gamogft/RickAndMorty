//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Montorio Lopez, Georgina on 13/1/26.
//

struct RMCharacter: Hashable  {
    
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let origin: String
    let location: String
    let image: String
    var episodes: [Int:String]
    
    init(id: Int, name: String, status: Status, species: String, type: String, gender: Gender, origin: String, location: String, image: String, episodes: [Int:String]) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.image = image
        self.episodes = episodes
    }
}
