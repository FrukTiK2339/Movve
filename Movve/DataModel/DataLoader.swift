//
//  DataLoader.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

class DataLoader {
    
    func getMovies(_ movieType: MovieType,_ searchType: SearchType, comletion: @escaping ([Movie]?) -> Void) {
        let movieCall = NetRequestMovies(movieType: movieType, searchType: searchType)
        movieCall.processMovieCall { movies in
            guard let receivedMovies = movies else {
                DLog("Received no data!")
                comletion(nil)
                return
            }
            comletion(receivedMovies)
        }
    }
    
    func getMovieDatails(_ movieType: MovieType,_ movieID: Int, comletion: @escaping (MovieDetails?) -> Void) {
        let detailsCall = NetRequestMovies(movieType: movieType, searchType: .id(movieID))
        detailsCall.processMovieDetailsCall { data in
            guard let receivedData = data else {
                DLog("Received no data!")
                comletion(nil)
                return
            }
            comletion(receivedData)
        }
    }
    
    func getMovieCast(_ movieType: MovieType,_ movieID: Int, comletion: @escaping ([Cast]?) -> Void) {
        let movieCastCall = NetRequestMovieCast(movieType: movieType, searchType: .id(movieID))
        movieCastCall.processMovieCastCall{ data in
            guard let receivedData = data else {
                DLog("Received no data!")
                comletion(nil)
                return
            }
            comletion(receivedData)
        }
    }
    
    
    
}
