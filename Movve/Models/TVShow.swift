//
//  MovieOverview.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 14.12.2022.
//

import UIKit

public struct TVShow {
    ///Main Screen
    var id: Int
    var name: String
    var releaseDate: String
    var posterImage: UIImage?
    
    func getReleaseDateYear() -> String {
        return DateFormatter.showOnlyYear(from: releaseDate)
    }
}

public struct TVShowOverview {
    ///TVShow Overview (Details) Screen
    var info: TVShow
    var details: TVShowDetails
    var cast: [Cast]
}

struct TVShowDetails {
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

