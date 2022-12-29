//
//  NetProcessRequest.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 28.12.2022.
//

import Foundation

public enum ApiRequest {
    case movie(seachType: SearchType),
         tvshow(seachType: SearchType),
    movieDetails(id: Int),
         tvshowDetails,
         actorCast
    
    var requestType: NetApiRequestProtocol {
        switch self {
        
        case .movie(let searchType):
            return NetRequestMovies(searchType: searchType)
        case .tvshow(let searchType):
            return NetRequestTVShows(searchType: searchType)
        case .movieDetails(let id):
            return NetRequestMovieDetails(searchType: .id(id))
        case .tvshowDetails:
            break
        case .actorCast:
            break
//                return NetRequestActorCast
        }
    }
}

class NetProcessRequest {
    
    func process(apiRequest: ApiRequest, urlSession: URLSession, request: URLRequest, completion: (Any?) -> Void) {
        urlSession.dataTask(with: request, completionHandler: {  data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                DLog("Error: Not a valid http response. Check your VPN")
                completion(nil)
                return
            }
            switch httpResponse.statusCode {
            case 200:
                do {
                    guard let recivedData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                        completion(nil)
                        return
                    }
                    switch apiRequest {
                        
                    case .movie():
                        completion(apiRequest.requestType.parse(recivedData))
                    case .tvshow(seachType: let seachType):
                        break
                    case .movieDetails(id: let id):
                        break
                    case .tvshowDetails:
                        break
                    case .actorCast:
                        break
                    }
                }
            case 400:
                DLog("Status code - 400.")
                fallthrough
            default:
                completion(nil)
            }
        }).resume()
    }
    
    
}
