//
//  AppConsts.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 14.12.2022.
//

import Foundation

extension NetApiRequest {
    static let apiKey: String = "?api_key=fdfae958cd30be7aefb41723716ceb03"
    static let baseURL: String = "https://api.themoviedb.org/3"
    static let timeoutMaxTime: Double = 30.0
}

extension NetRequestMovieCast {
    static let creditsURL: String = "/credits"
}

extension Notification.Name {
    public static let successDataLoading = Notification.Name("successDataLoading")
}
