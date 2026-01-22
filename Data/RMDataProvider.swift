//
//  RMDataProvider.swift
//  RickAndMorty
//
//  Created by Montorio Lopez, Georgina on 5/1/26.
//

import Foundation

class RMDataProvider {
    
    //MARK: - Dependencies
    let client: GFTAPIClient
   
    //MARK: - Inits
    init(client: GFTAPIClient) {
        self.client = client
    }
    
    func getCharacters(page: Int? = nil) async throws -> RMCharactersResponse {
        let request: RMCharactersRequest
        if let page {
            request = RMCharactersRequest(page: String(page))
        } else {
            request = RMCharactersRequest()
        }
        return try await client.send(request)
    }
    
    func getLocations(page: Int? = nil) async throws -> RMLocationsResponse {
        let request: RMLocationsRequest
        if let page {
            request = RMLocationsRequest(page: String(page))
        } else {
            request = RMLocationsRequest()
        }
        return try await client.send(request)
    }
    
    func getEpisodes(page: Int? = nil) async throws -> RMEpisodesResponse {
        let request: RMEpisodesRequest
        if let page {
            request = RMEpisodesRequest(page: String(page))
        } else {
            request = RMEpisodesRequest()
        }
        return try await client.send(request)
    }
}
