//
//  MovveDataProvider.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 29.12.2022.
//

import Foundation

protocol MovveDataManagerProviderProtocol: AnyObject {
    var dataManager: MovveDataManagerProtocol { get }
}

protocol MovveDataManagerProtocol: AnyObject {
    var movies: [Movie] { get }
    var tvshows: [TVShow] { get }
    var movieData: MovieOverview? { get }
    var tvshowData: TVShowOverview? { get }
    
    func loadReqiedData()
    func loadDetailsData(for movve: MovveCell)
}
