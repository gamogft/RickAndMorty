//
//  RMCharactersListViewModel.swift
//  RickAndMorty
//
//  Created by Montorio Lopez, Georgina on 5/1/26.
//

import SwiftUI
import Foundation

class RMCharactersListViewModel: ObservableObject {
    
    @Published var path = NavigationPath()
    @Published var viewState: RMViewStateModel = .loading
    
    private let dataProvider: RMDataProvider
    private var page: Int = 0
    var moreAvailableChars: Bool? = nil
    
    private var characters: [RMCharacter] = []
    private var locations: [RMLocation] = []
    private var episodes: [RMEpisode] = []
    
    init(dataProvider: RMDataProvider) {
        self.dataProvider = dataProvider
    }
    
    @MainActor
    func fetchCharactersData() async {
        async let charactersFetch: Void = fetchRMCharacters()
        async let locationsFetch: Void = fetchRMLocations()
        async let episodesFetch: Void = fetchRMEpisodes()
        
        let (characters, locations, episodes) = await (charactersFetch, locationsFetch, episodesFetch)
        
        self.characters = mapEpisodesToCharacter(self.characters)
        
        if self.characters.isEmpty {
            viewState = .empty
        } else {
            viewState = .data(self.characters)
        }
    }
    
    private func mapEpisodesToCharacter(_ characters: [RMCharacter]) -> [RMCharacter] {
        characters.map( { character in
            var updatedCharacter = character
            updatedCharacter.episodes.forEach({ episodeData in
                guard let episode = self.episodes.first(where: { $0.id == episodeData.key }) else { return }
                updatedCharacter.episodes.updateValue(episode.name + " (" + episode.episodeCode + ")", forKey: episodeData.key)
            })
            return updatedCharacter
        })
    }
    
    @MainActor
    func fetchRMCharacters() async {
        do {
            page += 1
            let rmCharsResponse = try await dataProvider.getCharacters(page: page)
            var characters = rmCharsResponse.results.map { parseCharacter($0) }
            characters = page > 1 ? mapEpisodesToCharacter(characters) : characters
            self.characters.append(contentsOf: characters)
            moreAvailableChars = page < rmCharsResponse.info.pages
            if page > 1 {
                viewState = .data(self.characters)
            }
        } catch let error {
            viewState = .error
        }
    }
        
    private func parseCharacter(_ characterDTO: RMCharacterDTO) -> RMCharacter {
        return .init(
            id: characterDTO.id,
            name: characterDTO.name,
            status: characterDTO.status,
            species: characterDTO.species,
            type: characterDTO.type,
            gender: characterDTO.gender,
            origin: characterDTO.origin.name,
            location: characterDTO.location.name,
            image: characterDTO.image,
            episodes: characterDTO.episode.reduce(into: [Int: String]()) { episodes, episode in
                if let episodeId = Int(episode.split(separator: "/").last!) {
                    episodes[episodeId] = ""
                }
            })
    }
    
    @MainActor
    private func fetchRMLocations() async {
        do {
            var locationsResponse = try await dataProvider.getLocations()
            locations.append(contentsOf: locationsResponse.results.map( { parseLocation($0) }))
            for page in 2...locationsResponse.info.pages {
                locationsResponse = try await dataProvider.getLocations(page: page)
                locations.append(contentsOf: locationsResponse.results.map( { parseLocation($0) }))
            }
        } catch let error {
            viewState = .error
        }
    }
    
    private func parseLocation(_ locationDTO: RMLocationDTO) -> RMLocation {
        return .init(
            id: locationDTO.id,
            name: locationDTO.name,
            type: locationDTO.type,
            dimension: locationDTO.dimension)
    }
    
    @MainActor
    private func fetchRMEpisodes() async {
        do {
            var episodesResponse = try await dataProvider.getEpisodes()
            episodes.append(contentsOf: episodesResponse.results.map( { parseEpisode($0) }))
            for page in 2...episodesResponse.info.pages {
                episodesResponse = try await dataProvider.getEpisodes(page: page)
                episodes.append(contentsOf: episodesResponse.results.map( { parseEpisode($0) }))
            }
        } catch let error {
            viewState = .error
        }
    }
    
    private func parseEpisode(_ episodeDTO: RMEpisodeDTO) -> RMEpisode {
        return .init(
            id: episodeDTO.id,
            name: episodeDTO.name,
            airDate: episodeDTO.air_date,
            episodeCode: episodeDTO.episode)
    }
    
    func goToCharacterDetail(_ character: RMCharacter) {
        path.append(Route.characterDetail(character))
    }
}
