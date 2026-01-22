//
//  RMViewStateModel.swift
//  RickAndMorty
//
//  Created by Montorio Lopez, Georgina on 13/1/26.
//

enum RMViewStateModel: Equatable {
    
    case loading
    case data([RMCharacter])
    case empty
    case error/*(Error)*/
    
    static func == (lhs: RMViewStateModel, rhs: RMViewStateModel) -> Bool {
        switch (lhs, rhs) {
        case (.data, .data), (.loading, .loading), (.empty, .empty), (.error, .error):
            return true
        /*case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription*/
        default:
            return false
        }
    }
}
