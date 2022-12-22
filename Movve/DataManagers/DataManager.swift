//
//  DataModel.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit

class DataManager {
    
    public static let shared = DataManager()
    
    private init() {}
    
    let loadingTasks = DispatchGroup()
    
    private var movieArray = [Movie]()
    private var tvshowArray = [TVShow]()
    private var movieOverview: MovieOverview?
    private var tvshowOverview: TVShowOverview?
    
    let dataLoader = DataLoader()
    let imageLoader = ImageLoader()
    
    public func giveMovieData() -> [Movie] {
        return movieArray
    }
    
    public func giveTVShowData() -> [TVShow] {
        return tvshowArray
    }
    
    public func giveMovieOverview() -> MovieOverview? {
        guard let movieOverview = movieOverview else {
            DLog("No details received!...")
            return nil
        }
        return movieOverview
    }
    
    public func giveTVShowOverview() -> TVShowOverview? {
        guard let tvshowOverview = tvshowOverview else {
            DLog("No details received!...")
            return nil
        }
        return tvshowOverview
    }
    
    public func loadImage(urlString: String, view: UIImageView) {
        loadImage(urlString: urlString, view: view)
    }
    
    public func getReqiedData() {
        getMovies()
        getTVShows()
        loadingTasks.wait()
        loadingTasks.notify(queue: .main) {
            NotificationCenter.default.post(name: Notification.Name.successDataLoading, object: nil)
        }
    }
    
    public func getMovieOverview(for movie: Movie) {
        var details: MovieDetails?
        var cast: [Cast]?
        
        loadingTasks.enter()
        dataLoader.getMovieDetails(targetID: movie.id) { [weak self] receivedDetails in
            details = receivedDetails
            self?.loadingTasks.leave()
        }
        
        loadingTasks.enter()
        dataLoader.getActorCast(.movie, movie.id) { [weak self] receivedCast in
            cast = receivedCast
            self?.loadingTasks.leave()
        }
        loadingTasks.wait()
        
        guard let details = details, let cast = cast else {
            DLog("Received no details/cast")
            return
        }
        
        movieOverview = MovieOverview(
            movieInfo: movie,
            details: details,
            cast: cast)
        
        loadingTasks.notify(queue: .main) {
            NotificationCenter.default.post(name: Notification.Name.successMovieDetailsLoading, object: nil)
            
        }
    }
    
    public func getTVShowOverview(for tvshow: TVShow) {
        var details: TVShowDetails?
        var cast: [Cast]?
        
        loadingTasks.enter()
        dataLoader.getTVShowDetails(targetID: tvshow.id) { [weak self] receivedDetails in
            details = receivedDetails
            self?.loadingTasks.leave()
        }
        
        loadingTasks.enter()
        dataLoader.getActorCast(.tvshow, tvshow.id) { [weak self] receivedCast in
            cast = receivedCast
            self?.loadingTasks.leave()
        }
        loadingTasks.wait()
        
        guard let details = details, let cast = cast else {
            DLog("Received no details/cast")
            return
        }
        
        tvshowOverview = TVShowOverview(
            tvshowInfo: tvshow,
            details: details,
            cast: cast)
        loadingTasks.notify(queue: .main) {
            NotificationCenter.default.post(name: Notification.Name.successTVShowDetailsLoading, object: nil)
            
        }
    }
    
    private func getMovies() {
        loadingTasks.enter()
        dataLoader.getMovies(.popular) { [weak self] popularMovies in
            guard let popularMovies = popularMovies else {
                DLog("Error loading popular movies")
                NotificationCenter.default.post(name: Notification.Name.errorLoadingData, object: nil)
                return
            }
            self?.movieArray = popularMovies
            self?.loadingTasks.leave()
            
        }
    }
    
    private func getTVShows() {
        loadingTasks.enter()
        dataLoader.getTVShows(.topRated) { [weak self] topRatedTVShows in
            guard let topRatedTVShows = topRatedTVShows else {
                DLog("Error loading top rated TV shows")
                NotificationCenter.default.post(name: Notification.Name.errorLoadingData, object: nil)
                return
            }
            self?.tvshowArray = topRatedTVShows
            self?.loadingTasks.leave()
        }
    }
   
}
