//
//  MovieOverview.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 14.12.2022.
//

import UIKit

struct TVShow {
    ///Main Screen
    var id: Int
    var name: String
    var releaseDate: String
    var posterImage: UIImage?
    
    init(id: Int, name: String, releaseDate: String, posterImage: UIImage?) {
        self.id = id
        self.name = name
        self.releaseDate = releaseDate
        self.posterImage = posterImage
    }
    
    func getReleaseDateYear() -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.showOnlyYear(from: releaseDate)
    }
}

struct TVShowOverview {
    ///Movie Overview (Details) Screen
    var info: TVShow
    var details: TVShowDetails
    var cast: [Cast]
    
    init(tvshowInfo: TVShow, details: TVShowDetails, cast: [Cast]) {
        self.info = tvshowInfo
        self.details = details
        self.cast = cast
    }
}

struct TVShowDetails {
    var genres: [Genre]
    var rating: Double
    var seasons: Int
    var overview: String
    var homepage: String
    var image: UIImage?
    
    init(genres: [Genre], rating: Double, seasons: Int, overview: String, homepage: String, image: UIImage?) {
        self.genres = genres
        self.rating = rating
        self.seasons = seasons
        self.overview = overview
        self.homepage = homepage
        self.image = image
    }
    
    func getGenres() -> String {
        var result = String()
        for genre in genres {
            result += "\(genre.name), "
        }
        return String(result.dropLast(2))
    }
}

