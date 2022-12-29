//
//  MovveEnum.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 29.12.2022.
//

import Foundation

public enum Movve {
    case movie
    case tvshow
    
    var urlPart: String {
        switch self {
        case .movie:
            return "/movie"
        case .tvshow:
            return "/tv"
        }
    }
}

public enum MovveCategory {
    case popular
    case topRated
    case id(Int)
    
    var urlPart: String {
        switch self {
        case .popular:
            return "/popular"
        case .topRated:
            return "/top_rated"
        case .id(let id):
            return "/\(id)"
        }
    }
}
