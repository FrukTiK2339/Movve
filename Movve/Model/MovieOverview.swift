//
//  MovieOverview.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 14.12.2022.
//

import UIKit

struct MovieDetails {
    var genres: [Genre]
    var runtime: Int
    var rating: Double
    var overview: String
    var homepage: String
    
    init(genres: [Genre], runtime: Int, rating: Double, overview: String, homepage: String) {
        self.genres = genres
        self.runtime = runtime
        self.rating = rating
        self.overview = overview
        self.homepage = homepage
    }
}

struct Genre {
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

struct Cast {
    var name: String
    var character: String
    var avatar: String
    
    init(name: String, character: String, avatar: String) {
        self.name = name
        self.character = character
        self.avatar = avatar
    }
}

struct MovieOverview {
    //Movie Overview (Details) Screen
    var movieInfo: Movie
    var details: MovieDetails
    var cast: [Cast]
    
    init(movieInfo: Movie, details: MovieDetails, cast: [Cast]) {
        self.movieInfo = movieInfo
        self.details = details
        self.cast = cast
    }
}
