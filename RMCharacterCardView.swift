//
//  RMCharacterCardView.swift
//  RickAndMorty
//
//  Created by Montorio Lopez, Georgina on 13/1/26.
//

import SwiftUI
import Foundation

struct RMCharacterCardView: View {
    
    let rmThumbnail: String
    let name: String
    let status: Status
    let species: String
    let location: String
    let episode: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            AsyncImage(url: URL(string: rmThumbnail)) { image in
                image
                    .resizable()
                    .frame(width: 170, height: 170)
            } placeholder: {
                Image(uiImage: UIImage(named: "RM_thumbnail", in: .main, with: .none)!)
                    .resizable()
                    .frame(width: 170, height: 170)
            }
            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .font(Font.title2).bold()
                HStack {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(RMCharacterCardView.getStatusColor(status))
                    Text(status.rawValue + " - " + species)
                        .font(Font.title3)
                }
                .padding(.top, 5)
                Text("Last known location:")
                    .font(Font.headline)
                    .foregroundStyle(.gray)
                    .padding(.top, 8)
                Text(location)
                    .font(Font.subheadline)
                    .padding(.top, 3)
                Text("First seen in:")
                    .font(Font.headline)
                    .foregroundStyle(.gray)
                    .padding(.top, 8)
                Text(episode)
                    .font(Font.subheadline)
                    .padding(.top, 3)
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .frame(height: 170)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    static func getStatusColor(_ status: Status) -> Color {
        switch status {
            case .alive:
            return .green
        case .dead:
            return .red
        case .unknown:
            return .gray
        }
    }
}

#Preview {
    ZStack {
        Color.gray
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        RMCharacterCardView(
            rmThumbnail: "RM_thumbnail",
            name: "Kristen Stewart",
            status: .alive,
            species: "Human",
            location: "Earth (C-500A)",
            episode: "Rixty Minutes")
        .padding(10)
    }
    .ignoresSafeArea()
}
