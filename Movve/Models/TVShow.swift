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
    var rating: Double
    
    init(id: Int, name: String, releaseDate: String, posterImage: UIImage?, rating: Double) {
        self.id = id
        self.name = name
        self.releaseDate = releaseDate
        self.posterImage = posterImage
        self.rating = rating
    }
}

struct TVShowOverview {
    ///Movie Overview (Details) Screen
    var tvshowInfo: TVShow
    var details: Details
    var cast: [Cast]
    
    init(tvshowInfo: TVShow, details: Details, cast: [Cast]) {
        self.tvshowInfo = tvshowInfo
        self.details = details
        self.cast = cast
    }
}
