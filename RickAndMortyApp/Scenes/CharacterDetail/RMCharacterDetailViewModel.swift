//
//  RMCharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by Montorio Lopez, Georgina on 5/1/26.
//

import Foundation

class RMCharacterDetailViewModel: ObservableObject {
    
    let rmCharacter: RMCharacter
    
    init(rmCharacter: RMCharacter) {
        self.rmCharacter = rmCharacter
    }
    
    func getFirstEpisodeName() -> String {
        return rmCharacter.episodes.sorted(by: { $0.key < $1.key }).first?.value ?? ""
    }

    func getOtherEpisodeNames() -> [String] {
        var episodes = rmCharacter.episodes.sorted(by: { $0.key < $1.key }).map( { $0.value })
        episodes.removeFirst()
        return episodes
    }
}
