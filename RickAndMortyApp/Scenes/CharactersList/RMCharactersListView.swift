//
//  RMCharactersListView.swift
//  RickAndMorty
//
//  Created by Montorio Lopez, Georgina on 5/1/26.
//

import SwiftUI

struct RMCharactersListView: View {
    
    @StateObject var viewModel: RMCharactersListViewModel
    
    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
                    .foregroundStyle(.gray)
                    .tint(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationBarBackButtonHidden()
                    .onAppear() {
                        Task {
                            await viewModel.fetchCharactersData()
                        }
                    }
            case .data(let characters):
                NavigationStack(path: $viewModel.path) {
                    VStack(spacing: 0) {
                        Image(uiImage: UIImage(named: "RickAndMortyLogo", in: .main, with: .none)!)
                            .resizable()
                            .frame(height: 250)
                        Divider()
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(characters, id: \.self) { character in
                                    RMCharacterCardView(
                                        rmThumbnail: character.image,
                                        name: character.name,
                                        status: character.status,
                                        species: character.species,
                                        location: character.location,
                                        episode: character.episodes.sorted(by: { $0.key < $1.key }).first?.value ?? "-")
                                    .onTapGesture(perform: {
                                        viewModel.goToCharacterDetail(character)
                                    })
                                }
                                if let moreAvailableChars = viewModel.moreAvailableChars, moreAvailableChars {
                                    ProgressView()
                                        .foregroundStyle(.gray)
                                        .tint(.gray)
                                        .padding(30)
                                        .onAppear() {
                                            Task {
                                                await viewModel.fetchRMCharacters()
                                            }
                                        }
                                }
                            }
                            .padding(15)
                            .navigationDestination(for: Route.self) { route in
                                switch route {
                                case .characterDetail(let character):
                                    RMCharacterDetailView(viewModel: RMCharacterDetailViewModel(rmCharacter: character))
                                }
                            }
                        }
                    }
                    .ignoresSafeArea()
                    .background(Color(uiColor: UIColor(named: "background", in: Bundle.main, compatibleWith: .none) ?? .gray))
                }
            case .empty:
                Text("Sorry, there's no characters' data to retrieve")
            case .error:
                Text("Sorry, an error occurred while fetching data. Try again later.")
            }
        }
    }
}

#Preview {
    RMCharactersListView(viewModel: RMCharactersListViewModel(dataProvider: RMDataProvider(client: GFTAPIClient(baseURL: URL(string: RickAndMortyAPIConfig.baseURL)!))))
}
