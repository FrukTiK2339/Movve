//
//  URLGeneratorProvider.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 30.12.2022.
//

import Foundation

protocol URLGeneratorProviderProtocol: AnyObject {
    var urlGenerator: URLGeneratorProtocol { get }
}

protocol URLGeneratorProtocol: AnyObject {
   func generateCategoryURL(with movve: Movve, _ category: MovveCategory) -> URL?
   func generateDetailsURL(with movie: Movie, movve: Movve?) -> URL?
   func generateDetailsURL(with tvshow: TVShow, movve: Movve?) -> URL?
   func generateCastURL(with movie: Movie, movve: Movve?) -> URL?
   func generateCastURL(with tvshow: TVShow, movve: Movve?) -> URL?
}
