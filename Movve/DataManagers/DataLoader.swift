//
//  DataLoader.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

class DataLoader {
    
    func getMovies(_ searchType: SearchType, comletion: @escaping ([Movie]?) -> Void) {
        let call = NetRequestMovies(searchType: searchType)
        call.processMovieCall { movies in
            guard let receivedMovies = movies else {
                DLog("Received no data!")
                comletion(nil)
                return
            }
            comletion(receivedMovies)
        }
    }
    
    func getTVShows(_ searchType: SearchType, comletion: @escaping ([TVShow]?) -> Void) {
        let call = NetRequestTVShows(searchType: searchType)
        call.processTVShowCall { movies in
            guard let receivedMovies = movies else {
                DLog("Received no data!")
                comletion(nil)
                return
            }
            comletion(receivedMovies)
        }
    }
    
    func getMovieDetails(targetID: Int, comletion: @escaping (MovieDetails?) -> Void) {
        let detailsCall = NetRequestMovies(searchType: .id(targetID))
        detailsCall.processMovieDetailsCall { data in
            guard let receivedData = data else {
                DLog("Received no data!")
                comletion(nil)
                return
            }
            comletion(receivedData)
        }
    }
    
    func getTVShowDetails(targetID: Int, comletion: @escaping (TVShowDetails?) -> Void) {
        let detailsCall = NetRequestTVShows(searchType: .id(targetID))
        detailsCall.processTVShowDetailsCall { data in
            guard let receivedData = data else {
                DLog("Received no data!")
                comletion(nil)
                return
            }
            comletion(receivedData)
        }
    }
    
    func getActorCast(_ targetType: TargetType,_ targetID: Int, comletion: @escaping ([Cast]?) -> Void) {
        let actorCastCall = NetRequestActorCast(targetType: targetType, searchType: .id(targetID))
        actorCastCall.processCall{ data in
            guard let receivedData = data else {
                DLog("Received no data!")
                comletion(nil)
                return
            }
            comletion(receivedData)
        }
    }
    
    
    
}
