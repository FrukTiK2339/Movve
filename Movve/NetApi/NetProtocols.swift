//
//  NetProtocols.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 14.12.2022.
//

import Foundation

public protocol CustomURLSessionProviderProtocol {
    var urlSessionProvider: CustomURLSessionProtocol { get }
}

public protocol CustomURLSessionProtocol {
    var urlSession: URLSession? { get }
}

public protocol NetApiRequestProtocol {
    var targetType: TargetType { get }
    var searchType: SearchType { get }
    
    func createURL() -> URL?
    func processCall(completion: @escaping (Any?) -> Void)
}

public enum TargetType {
    case movie, tvshow
    
    var urlPart: String {
        switch self {
        case .movie:
            return "/movie"
        case .tvshow:
            return "/tv"
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

