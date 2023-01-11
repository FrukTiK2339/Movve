//
//  MovveManager.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 29.12.2022.
//

import Foundation

extension MovveManager: NetApiFacadeProviderProtocol {
    var netApiFacade: NetApiFacadeProtocol {
        return NetApiFacade.shared
    }
}

class MovveManager: MovveDataManagerProtocol {
    static let shared = MovveManager()
    
    var movies: [Movie] = []
    var tvshows: [TVShow] = []
    var movieData: MovieOverview?
    var tvshowData: TVShowOverview?
    
    func loadReqiedData() {
        loadData(for: .movie, category: .popular)
        loadData(for: .tvshow, category: .topRated)
        dispatchGroup.wait()
        dispatchGroup.notify(queue: .main) {
            NotificationCenter.default.post(name: NSNotification.Name.successDataLoading, object: nil)
        }
    }
    
    func loadDetailsData(for movve: MovveCell) {
        switch movve {
        case .movie(let movie):
            loadMovieData(for: movie)
        case .tvshow(let tvshow):
            loadTVShowData(for: tvshow)
        }
    }
    
    
    //MARK: - Private
    private let dispatchGroup = DispatchGroup()
    
    private func loadData(for movve: Movve, category: MovveCategory) {
        dispatchGroup.enter()
        netApiFacade.loadData(for: movve, category: category) { [weak self] movveData in
            guard movveData != nil else {
                DLog("Bad data occured! Couldn't load data.")
                NotificationCenter.default.post(name: NSNotification.Name.errorLoadingData, object: nil)
                return
            }
            switch movve {
            case .movie:
                guard let movies = movveData as? [Movie] else {
                    DLog("")
                    return
                }
                self?.movies = movies
            case .tvshow:
                guard let tvshows = movveData as? [TVShow] else {
                    DLog("")
                    return
                }
                self?.tvshows = tvshows
            }
            self?.dispatchGroup.leave()
        }
    }
    
    private func loadMovieData(for movie: Movie) {
        dispatchGroup.enter()
        netApiFacade.loadDetailsData(for: movie) { [self] movieData in
            guard movieData != nil else {
                DLog("Bad data occured! Couldn't load movie details.")
                NotificationCenter.default.post(name: NSNotification.Name.errorLoadingData, object: nil)
                return
            }
            self.movieData = movieData
            self.dispatchGroup.leave()
        }
        dispatchGroup.wait()
        dispatchGroup.notify(queue: .main) {
            NotificationCenter.default.post(name: NSNotification.Name.successMovieDataLoading, object: nil)
        }
    }
    
    private func loadTVShowData(for tvshow: TVShow) {
        dispatchGroup.enter()
        netApiFacade.loadDetailsData(for: tvshow) { [weak self] tvshowData in
            guard tvshowData != nil else {
                DLog("Bad data occured! Couldn't load tvshow details.")
                return
            }
            self?.tvshowData = tvshowData
            self?.dispatchGroup.leave()
        }
        dispatchGroup.wait()
        dispatchGroup.notify(queue: .main) {
            NotificationCenter.default.post(name: NSNotification.Name.successTVShowDataLoading, object: nil)
        }
    }
}
