//
//  NetApiFacade.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 29.12.2022.
//

import Foundation

class NetApiFacade: NetApiFacadeProtocol {
    static let shared = NetApiFacade()
    
    var urlSession: URLSession?
    
    func loadData(for movve: Movve, category: MovveCategory, result: @escaping ([Any]?) -> Void) {
        ///generate URL
        url = urlGenerator.generateCategoryURL(with: movve, category)
        
        guard let masterURL = url, let masterURLSession = urlSession else {
            DLog("Error: masterURL/masterURLSession == nil")
            result(nil)
            return
        }
        
        let request = NetRequestMovve(with: movve)
        request.getMovve(with: masterURL, masterURLSession, result: { data in
            guard data != nil else {
                DLog("")
                result(nil)
                return
            }
            result(data)
        })
    }
    
    func loadDetailsData(for movie: Movie, result: @escaping (MovieOverview?) -> Void) {
        guard let details = getMovieDetails(for: movie),
              let cast = getCast(for: movie) else {
            DLog("Error: details/cast data == nil")
            return
        }
        let movieOverview = MovieOverview(info: movie, details: details, cast: cast)
        result(movieOverview)
    }
    
    func loadDetailsData(for tvshow: TVShow, result: @escaping (TVShowOverview?) -> Void) {
        guard let details = getTVShowDetails(for: tvshow),
              let cast = getCast(for: tvshow) else {
            DLog("Error: details/cast data == nil")
            return
        }
        let tvshowOverview = TVShowOverview(info: tvshow, details: details, cast: cast)
        result(tvshowOverview)
    }
    
    func setupURLSession() {
        let config = URLSessionConfiguration.default
        let operQueue = OperationQueue()
        operQueue.maxConcurrentOperationCount = 3
        self.urlSession = URLSession(configuration: config, delegate: nil, delegateQueue: operQueue)
    }
    
    //MARK: - Private
    private var url: URL?
   
    private let dispatchGroup = DispatchGroup()
    
    private func getMovieDetails(for movie: Movie) -> MovieDetails? {
        url = urlGenerator.generateDetailsURL(with: movie, movve: .movie)
        DLog(self.url)
        guard let masterURL = url, let masterURLSession = urlSession else {
            DLog("Error: masterURL/masterURLSession == nil")
            return nil
        }
        
        var movieDetails: MovieDetails?
        let requestDetails = NetRequestMovieDetails()
        dispatchGroup.enter()
        requestDetails.getDetails(with: masterURL, masterURLSession, result: { details in
            guard details != nil else {
                DLog("")
                return
            }
            movieDetails = details
            self.dispatchGroup.leave()
        })
        dispatchGroup.wait()
        return movieDetails
    }
    
    private func getTVShowDetails(for tvshow: TVShow) -> TVShowDetails? {
        url = urlGenerator.generateDetailsURL(with: tvshow, movve: .tvshow)
        
        guard let masterURL = url, let masterURLSession = urlSession else {
            DLog("Error: masterURL/masterURLSession == nil")
            return nil
        }
        
        var tvshowDetails: TVShowDetails?
        let requestDetails = NetRequestTVShowDetails()
        dispatchGroup.enter()
        requestDetails.getDetails(with: masterURL, masterURLSession, result: { details in
            guard details != nil else {
                DLog("")
                return
            }
            tvshowDetails = details
            self.dispatchGroup.leave()
        })
        dispatchGroup.wait()
        return tvshowDetails
    }
    
    private func getCast(for target: Any) -> [Cast]?{
        if let movie = target as? Movie {
            url = urlGenerator.generateCastURL(with: movie, movve: .movie)
        } else if let tvshow = target as? TVShow {
            url = urlGenerator.generateCastURL(with: tvshow, movve: .tvshow)
        }
        DLog(url)
        
        guard let masterURL = url, let masterURLSession = urlSession else {
            DLog("Error: masterURL/masterURLSession == nil")
            return nil
        }
        
        var cast: [Cast]?
        let requestCast = NetRequestActorCast()
        dispatchGroup.enter()
        requestCast.getCast(with: masterURL, masterURLSession) { castData in
            guard castData != nil else {
                DLog("Occured nil Actor Cast Data.")
                return
            }
            cast = castData
            self.dispatchGroup.leave()
        }
        dispatchGroup.wait()
        return cast
    }
}
