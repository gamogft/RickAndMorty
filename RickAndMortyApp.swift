//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Montorio Lopez, Georgina on 5/1/26.
//

import SwiftUI

enum Route: Hashable {
    //case charactersList
    case characterDetail(RMCharacter)
}

@main
struct RickAndMortyApp: App {
    
    var body: some Scene {
        WindowGroup {
            RMCharactersListView(
                viewModel: RMCharactersListViewModel(
                    dataProvider: RMDataProvider(
                        client: GFTAPIClient(
                            baseURL: URL(string: RickAndMortyAPIConfig.baseURL)!))))
        }
    }
}
