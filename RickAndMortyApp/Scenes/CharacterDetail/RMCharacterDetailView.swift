//
//  RMCharacterDetailView.swift
//  RickAndMorty
//
//  Created by Montorio Lopez, Georgina on 19/1/26.
//

import SwiftUI

struct RMCharacterDetailView: View {
    
    @ObservedObject var viewModel: RMCharacterDetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: URL(string: viewModel.rmCharacter.image)) { image in
                image.resizable()
                    .frame(height: 300)
            } placeholder: {
                Image(uiImage: UIImage(named: "RM_thumbnail", in: .main, with: .none)!)
                    .resizable()
                    .frame(height: 300)
            }
            Divider()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Text(viewModel.rmCharacter.name)
                        .font(Font.largeTitle).bold()
                        .foregroundStyle(.gray)
                    
                    Text("Status:")
                        .font(Font.title)
                        .foregroundStyle(.gray)
                        .padding(.top, 40)
                    HStack {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundStyle(RMCharacterCardView.getStatusColor(viewModel.rmCharacter.status))
                        Text(viewModel.rmCharacter.status.rawValue)
                            .font(Font.title2)
                    }
                    .padding(.top, 10)
                    
                    Text("Species:")
                        .font(Font.title)
                        .foregroundStyle(.gray)
                        .padding(.top, 20)
                    Text(viewModel.rmCharacter.species)
                        .font(Font.title2)
                    .padding(.top, 10)
                    
                    Text("Origin:")
                        .font(Font.title)
                        .foregroundStyle(.gray)
                        .padding(.top, 40)
                    Text(viewModel.rmCharacter.origin)
                        .font(Font.title2)
                        .padding(.top, 10)
                    
                    Text("Last known location:")
                        .font(Font.title)
                        .foregroundStyle(.gray)
                        .padding(.top, 20)
                    Text(viewModel.rmCharacter.location)
                        .font(Font.title2)
                        .padding(.top, 10)
                    
                    Text("First seen in episode:")
                        .font(Font.title)
                        .foregroundStyle(.gray)
                        .padding(.top, 40)
                    Text(viewModel.getFirstEpisodeName())
                        .font(Font.title2)
                        .padding(.top, 10)
                    
                    if !viewModel.getOtherEpisodeNames().isEmpty {
                        Text("Also seen in episodes:")
                            .font(Font.title2)
                            .foregroundStyle(.gray)
                            .padding(.top, 25)
                        ForEach(viewModel.getOtherEpisodeNames(), id: \.self) { episode in
                            Text(episode)
                                .font(Font.subheadline)
                                .padding(.top, 15)
                        }
                    }
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 20)
            }
        }
        .background(Color(uiColor: UIColor(named: "background", in: Bundle.main, compatibleWith: .none) ?? .gray))
    }
}

#Preview {
    RMCharacterDetailView(viewModel:
        RMCharacterDetailViewModel(rmCharacter:
            RMCharacter(
                id: 1,
                name: "Kristen Stewart",
                status: .alive,
                species: "Human",
                type: "",
                gender: .male,
                origin: "Earth (C-137)",
                location: "Citadel of Ricks",
                image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                episodes: [1:"Pilot (S01E01)", 2:"Pilot (S01E01)"])
        )
    )
}
