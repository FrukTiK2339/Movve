//
//  NetApiFacadeProviderProtocol.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 29.12.2022.
//

import Foundation

protocol NetApiFacadeProviderProtocol: AnyObject {
    var netApiFacade: NetApiFacadeProtocol { get }
}

protocol NetApiFacadeProtocol: AnyObject {
    func loadData(for movve: Movve, category: MovveCategory, result: @escaping ([Any]?) -> Void)
    func loadDetailsData(for movie: Movie, result: @escaping (MovieOverview?) -> Void)
    func loadDetailsData(for tvshow: TVShow, result: @escaping (TVShowOverview?) -> Void)
    func setupURLSession()
}
