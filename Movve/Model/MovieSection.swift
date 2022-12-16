//
//  MovieSection.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import Foundation

struct MovieSection {
    let type: MovieSectionType
    let cells: [MovieCell]
}

enum MovieSectionType: CaseIterable {
    case movies
    case tvshows
    
    var title: String {
        switch self {
        case .movies:
            return "Popular Movie"
        case .tvshows:
            return "TV Show"
        }
    }
}

enum MovieCell {
    case movie(viewModel: Movie)
    case tvshow(viewModel: Movie)
}
