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
    
    let dataLoader = DataLoader()
    let imageLoader = ImageLoader()
    
    public func giveMovieData() -> [Movie] {
        return movieArray
    }
    
    public func giveTVShowData() -> [TVShow] {
        return tvshowArray
    }
    
    public func loadImage(urlString: String, view: UIImageView) {
        loadImage(urlString: urlString, view: view)
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
        dataLoader.getMovies(.popular) { [weak self] popularMovies in
            guard let popularMovies = popularMovies else {
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
                return
            }
            self?.tvshowArray = topRatedTVShows
            self?.loadingTasks.leave()
        }
    }
    
    
   
}
