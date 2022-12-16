//
//  NetApiRequestProtocol.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 14.12.2022.
//

import Foundation

public protocol NetApiRequestProtocol {
    var configuration: URLSessionConfiguration { get }
    var movieType: MovieType { get }
    var searchType: SearchType { get }
    
    func createURL() -> URL?
    func processCall(completion: @escaping (Any?) -> Void)
}

public enum MovieType {
    case movie, tvshow, serial
    
    var urlPart: String {
        switch self {
        case .movie:
            return "/movie"
        case .tvshow:
            return "/tv"
        case .serial:
            return "/serial"
        }
    }
}

public enum SearchType {
    case popular, topRated, latest, id(Int)
    
    var urlPart: String {
        switch self {
        case .popular:
            return "/popular"
        case .topRated:
            return "/top_rated"
        case .latest:
            return "/latest"
        case .id(let id):
            return "/\(id)"
        }
    }
}

