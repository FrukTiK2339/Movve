//
//  URLGenerator.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 30.12.2022.
//

import Foundation

class URLGenerator: URLGeneratorProtocol {
    
    func generateCategoryURL(with movve: Movve, _ category: MovveCategory) -> URL? {
        let urlStr: String = .dataURLBasic + movve.urlPart + category.urlPart + .apiKey
        guard let url = URL(string: urlStr) else {
            DLog("Error generating URL.")
            return nil
        }
        return url
    }
    
    func generateDetailsURL(with movie: Movie, movve: Movve? = .movie) -> URL? {
        let urlStr: String = .dataURLBasic + (movve?.urlPart ?? "") + "/\(movie.id)" + .apiKey
        guard let url = URL(string: urlStr) else {
            DLog("Error generating URL for movie.")
            return nil
        }
        return url
    }
    
    func generateDetailsURL(with tvshow: TVShow, movve: Movve? = .tvshow) -> URL? {
        let urlStr: String = .dataURLBasic + (movve?.urlPart ?? "") + "/\(tvshow.id)" + .apiKey
        guard let url = URL(string: urlStr) else {
            DLog("Error generating URL for tvshow.")
            return nil
        }
        return url
    }
    
    func generateCastURL(with movie: Movie, movve: Movve? = .movie) -> URL? {
        let urlStr: String = .dataURLBasic + (movve?.urlPart ?? "") + "/\(movie.id)" + .castURLPart + .apiKey
        guard let url = URL(string: urlStr) else {
            DLog("Error generating URL for movie.")
            return nil
        }
        return url
    }
    
    func generateCastURL(with tvshow: TVShow, movve: Movve? = .tvshow) -> URL? {
        let urlStr: String = .dataURLBasic + (movve?.urlPart ?? "") + "/\(tvshow.id)" + .castURLPart + .apiKey
        guard let url = URL(string: urlStr) else {
            DLog("Error generating URL for tvshow.")
            return nil
        }
        return url
    }
}

