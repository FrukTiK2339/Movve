//
//  DataModel.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import Foundation

class DataManager {
    
    public static let shared = DataManager()
    
    private init() {}
    
    let loadingTasks = DispatchGroup()
    
    private var movieArray = [Movie]()
    private var tvshowArray = [Movie]()
    
    let dataLoader = DataLoader()
    
    public func giveMovieData(movieType: MovieType) -> [Movie] {
        switch movieType {
        case .movie:
            return movieArray
        case .tvshow:
            return tvshowArray
        case .serial:
            return []
        }
    }
    
    public func getReqiedData() {
        getMovies()
        getTVShows()
        loadingTasks.notify(queue: .main) {
            NotificationCenter.default.post(name: Notification.Name.successDataLoading, object: nil)
        }
    }
    
    private func getMovies() {
        loadingTasks.enter()
        dataLoader.getMovies(.movie, .popular) { [weak self] popularMovies in
            guard let popularMovies = popularMovies else {
                return
            }
            self?.movieArray = popularMovies
            self?.loadingTasks.leave()
            
        }
    }
    
    private func getTVShows() {
        loadingTasks.enter()
        dataLoader.getMovies(.tvshow, .topRated) { [weak self] topRatedTVShows in
            guard let topRatedTVShows = topRatedTVShows else {
                return
            }
            self?.tvshowArray = topRatedTVShows
            self?.loadingTasks.leave()
        }
    }
    
    
   
}
