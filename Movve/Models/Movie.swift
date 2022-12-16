//
//  Movie.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 14.12.2022.
//

import UIKit

struct Movie {
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
}

struct MovieOverview {
    ///Movie Overview (Details) Screen
    var movieInfo: Movie
    var details: Details
    var cast: [Cast]
    
    init(movieInfo: Movie, details: Details, cast: [Cast]) {
        self.movieInfo = movieInfo
        self.details = details
        self.cast = cast
    }
}
