//
//  AppConsts.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 14.12.2022.
//

import UIKit

extension NetApiRequest {
    static let apiKey: String = "?api_key=fdfae958cd30be7aefb41723716ceb03"
    static let baseURL: String = "https://api.themoviedb.org/3"
    static let timeoutMaxTime: Double = 30.0
}

extension NetRequestActorCast {
    static let creditsURL: String = "/credits"
}

extension Notification.Name {
    public static let successDataLoading = Notification.Name("successDataLoading")
}

extension ImageLoader {
    static let baseURL: String = "https://image.tmdb.org/t/p/w500"
}

extension MovieCollectionViewCell {
    static let movieTitleHeight: CGFloat = 40
    static let dateLabelHeight: CGFloat = 20
}

extension UIFont {
    static let iconFont = UIFont(name: "TrebuchetMS-Bold", size: 32)
    static let headerFont = UIFont(name: "TrebuchetMS-Bold", size: 20)
    static let movieTitleFont = UIFont(name: "TrebuchetMS-Bold", size: 14)
    static let movieReleaseDateFont = UIFont(name: "TrebuchetMS-Bold", size: 12)
}

extension CGFloat {
    static let iconPadding: CGFloat = 16
    static let smallPadding: CGFloat = 8
    
    static let cornerRadius: CGFloat = 8
}

extension UIImage {
    static let noImage: UIImage? = UIImage(systemName: "xmark")
}
