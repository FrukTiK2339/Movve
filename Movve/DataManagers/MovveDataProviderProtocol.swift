//
//  MovveDataProviderProtocol.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 26.12.2022.
//

public protocol MovveDataProviderProtocol {
    var dataManager: MovveDataProtocol { get }
}

public protocol MovveDataProtocol {
    var movieArray: [Movie] { get }
    var tvshowArray: [TVShow] { get }
    var movieOverview: MovieOverview? { get }
    var tvshowOverview: TVShowOverview? { get }
    
    func getReqiedData()
    func getMovieOverview(for movie: Movie)
    func getTVShowOverview(for tvshow: TVShow)
}
