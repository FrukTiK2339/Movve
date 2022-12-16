//
//  MovieSection.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import Foundation

struct TargetSection {
    let type: SectionType
    let cells: [TargetCell]
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

enum TargetCell {
    case movie(viewModel: Movie)
    case tvshow(viewModel: TVShow)
}
