//
//  Details.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit

struct Details {
    var genres: [Genre]
    var runtime: Int
    var rating: Double
    var overview: String
    var homepage: String
    var detailsImage: UIImage?
    
    init(genres: [Genre], runtime: Int, rating: Double, overview: String, homepage: String, detailsImage: UIImage?) {
        self.genres = genres
        self.runtime = runtime
        self.rating = rating
        self.overview = overview
        self.homepage = homepage
        self.detailsImage = detailsImage
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
