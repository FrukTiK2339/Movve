//
//  MovieOverview.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 14.12.2022.
//

import UIKit

public struct TVShow: CinemaItemProtocol {
    var type: CinemaItemType = .tvshow
    var id: Int
    var title: String
    var releaseDate: String
    var posterImage: UIImage?
}

public struct TVShowData: CinemaItemDataProtocol {
    var item: CinemaItemProtocol
    var details: CinemaItemDetailsProtocol
    var cast: [Cast]
}

struct TVShowDetails: CinemaItemDetailsProtocol {
    var genres: [Genre]
    var rating: Double
    var seasons: Int
    var overview: String
    var homepage: String
    var image: UIImage?
    
    func getGenres() -> String {
        var result = String()
        for genre in genres {
            result += "\(genre.name), "
        }
        return String(result.dropLast(2))
    }
}

