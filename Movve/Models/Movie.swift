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
    
    func getReleaseDateYear() -> String {
        return DateFormatter.showOnlyYear(from: releaseDate)
    }
}

public struct MovieOverview {
    ///Movie Overview (Details) Screen
    var info: Movie
    var details: MovieDetails
    var cast: [Cast]
}

struct MovieDetails {
    var genres: [Genre]
    var runtime: Int
    var rating: Double
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
    
    func getRuntime() -> String {
        return "\(runtime / 60) h \((runtime % 60)) min"
    }
}
