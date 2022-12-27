//
//  AppNetConfig.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 27.12.2022.
//

import Foundation

extension DetailsViewController: MovveDataProviderProtocol {
    var dataManager: MovveDataProtocol {
        return DataManager.shared
    }
}


extension HomeViewController: MovveDataProviderProtocol {
    var dataManager: MovveDataProtocol {
        return DataManager.shared
    }
}


extension LaunchViewController: MovveDataProviderProtocol {
    var dataManager: MovveDataProtocol {
        return DataManager.shared
    }
}
