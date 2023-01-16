//
//  URLGenerator.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 30.12.2022.
//

import Foundation

protocol URLGeneratorProtocol: AnyObject {
   func generateURL(with type: CinemaItemType, _ searchType: CinemaItemSearchType) -> URL?
   func generateURL(with cinema: CinemaItemProtocol, type: CinemaItemType?) -> URL?
   func generateCastURL(with cinema: CinemaItemProtocol, type: CinemaItemType?) -> URL?
}

class URLGenerator: URLGeneratorProtocol {
    
    func generateURL(with type: CinemaItemType, _ searchType: CinemaItemSearchType) -> URL? {
        let urlStr: String = .dataURLBasic + type.urlPart + searchType.urlPart + .apiKey
        
        guard let url = URL(string: urlStr) else {
            assertionFailure("Error creating URL!")
            return nil
        }
       
        return url
    }
    
    func generateURL(with cinema: CinemaItemProtocol, type: CinemaItemType?) -> URL? {
        let urlStr: String = .dataURLBasic + (type?.urlPart ?? "") + "/\(cinema.id)" + .apiKey
        guard let url = URL(string: urlStr) else {
            assertionFailure("Error generating URL for movie.")
            return nil
        }
        return url
    }
    
    func generateCastURL(with cinema: CinemaItemProtocol, type: CinemaItemType?) -> URL? {
        let urlStr: String = .dataURLBasic + (type?.urlPart ?? "") + "/\(cinema.id)" + .castURLPart + .apiKey
        guard let url = URL(string: urlStr) else {
            assertionFailure("Error generating URL for \(cinema).")
            return nil
        }
        return url
    }
}

