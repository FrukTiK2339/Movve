//
//  MovieSection.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import Foundation

struct MovveSection {
    let type: SectionType
    let cells: [MovveCell]
}

enum SectionType: CaseIterable {
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

enum MovveCell {
    case movie(viewModel: Movie)
    case tvshow(viewModel: TVShow)
}
