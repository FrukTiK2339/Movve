//
//  CinemaItem.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 13.01.2023.
//

import UIKit

//Basic model of item info
protocol CinemaItemProtocol {
    var type: CinemaItemType { get set }
    var id: Int { get }
    var title: String { get }
    var releaseDate: String { get }
    var posterImage: UIImage? { get }
    
    func getReleaseDateYear() -> String 
}

extension CinemaItemProtocol {
    func getReleaseDateYear() -> String {
        return DateFormatter.showOnlyYear(from: releaseDate)
    }
}

//Basic model of item extra info
protocol CinemaItemDetailsProtocol {
    var genres: [Genre] { get }
    var rating: Double { get }
    var overview: String { get }
    var homepage: String { get }
    var image: UIImage? { get }
    
    func getGenres() -> String
}

extension CinemaItemDetailsProtocol {
    func getGenres() -> String {
        var result = String()
        for genre in genres {
            result += "\(genre.name), "
        }
        return String(result.dropLast(2))
    }
}

//Basic model of item's full data
protocol CinemaItemDataProtocol {
    var item: CinemaItemProtocol { get }
    var details: CinemaItemDetailsProtocol { get }
    var cast: [Cast] { get }
}

struct Genre {
    var id: Int
    var name: String
}

struct Cast {
    var name: String
    var character: String
    var avatar: UIImage?
}


public enum CinemaItemType {
    case movie
    case tvshow
    
    var title: String {
        switch self {
        case .movie:
            return "Popular Movie"
        case .tvshow:
            return "TV Show"
        }
    }
    
    var urlPart: String {
        switch self {
        case .movie:
            return "/movie"
        case .tvshow:
            return "/tv"
        }
    }
}

public struct CinemaItemSection {
    var type: CinemaItemType
    var cells: [CinemaItemProtocol]
}

public enum CinemaItemSearchType: CaseIterable {
    public static var allCases: [CinemaItemSearchType] = [.popular, .topRated]
    
    
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



