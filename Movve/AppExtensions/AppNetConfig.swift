//
//  AppNetConfig.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 27.12.2022.
//

import Foundation

extension String {
    static let imageURLBasic = "https://image.tmdb.org/t/p/w500"
    static let dataURLBasic = "https://api.themoviedb.org/3"
    static let apiKey = "?api_key=fdfae958cd30be7aefb41723716ceb03"
}

extension DetailsViewController: MovveDataManagerProviderProtocol {
    var dataManager: MovveDataManagerProtocol {
        return MovveManager.shared
    }
}

extension HomeViewController: MovveDataManagerProviderProtocol {
    var dataManager: MovveDataManagerProtocol {
        return MovveManager.shared
    }
}

extension LaunchViewController: MovveDataManagerProviderProtocol {
    var dataManager: MovveDataManagerProtocol {
        return MovveManager.shared
    }
}

extension MovveManager: NetApiFacadeProviderProtocol {
    var netApiFacade: NetApiFacadeProtocol {
        return NetApiFacade.shared
    }
}

extension NetRequestMovve: NetImageLoaderProviderProtocol {
    var imageLoader: NetImageLoaderProtocol {
        return NetImageLoader.shared
    }
}
