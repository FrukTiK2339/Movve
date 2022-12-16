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
    var posterImage: String

    init(id: Int, title: String, releaseDate: String, posterImage: String) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.posterImage = posterImage
    }
}
