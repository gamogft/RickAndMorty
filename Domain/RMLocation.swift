//
//  RMLocation.swift
//  RickAndMorty
//
//  Created by Montorio Lopez, Georgina on 13/1/26.
//

struct RMLocation: Hashable  {
    
    let id: Int
    let name: String
    let type: String
    let dimension: String
    
    init(id: Int, name: String, type: String, dimension: String) {
        self.id = id
        self.name = name
        self.type = type
        self.dimension = dimension
    }
}
