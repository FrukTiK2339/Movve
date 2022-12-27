//
//  Movie.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 14.12.2022.
//

import UIKit

public struct Movie {
    ///Main Screen
    var id: Int
    var title: String
    var releaseDate: String
    var posterImage: UIImage?

    init(id: Int, title: String, releaseDate: String, posterImage: UIImage?) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.posterImage = posterImage
    }
    
    func getReleaseDateYear() -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.showOnlyYear(from: releaseDate)
    }
}

public struct MovieOverview {
    ///Movie Overview (Details) Screen
    var info: Movie
    var details: MovieDetails
    var cast: [Cast]
    
    init(movieInfo: Movie, details: MovieDetails, cast: [Cast]) {
        self.info = movieInfo
        self.details = details
        self.cast = cast
    }
}

struct MovieDetails {
    var genres: [Genre]
    var runtime: Int
    var rating: Double
    var overview: String
    var homepage: String
    var image: UIImage?
    
    init(genres: [Genre], runtime: Int, rating: Double, overview: String, homepage: String, image: UIImage?) {
        self.genres = genres
        self.runtime = runtime
        self.rating = rating
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
    
    func getRuntime() -> String {
        return "\(runtime / 60) h \((runtime % 60)) min"
    }
}
