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
    public static let successMovieDetailsLoading = Notification.Name("successMovieDetailsLoading")
    public static let successTVShowDetailsLoading = Notification.Name("successTVShowDetailsLoading")
    
}

extension ImageLoader {
    static let baseURL: String = "https://image.tmdb.org/t/p/w500"
}

extension UIFont {
    static let iconFontItalic = UIFont(name: "Trebuchet-BoldItalic", size: 32)
    static let iconFont = UIFont(name: "TrebuchetMS-Bold", size: 32)
    static let headerFont = UIFont(name: "TrebuchetMS-Bold", size: 20)
    static let cellTitleFont = UIFont(name: "TrebuchetMS-Bold", size: 14)
    static let cellDateFont = UIFont(name: "TrebuchetMS-Bold", size: 12)
    
    static let actorsNameFont = UIFont(name: "TrebuchetMS", size: 12)
    static let charactersNameFont = UIFont(name: "TrebuchetMS", size: 10)
}

extension CGFloat {
    ///Padding
    static let iconPadding: CGFloat = 16
    static let smallPadding: CGFloat = 8
    
    ///Layers
    static let cornerRadius: CGFloat = 8
    
    ///Height Consts
    static let cellTitleHeight: CGFloat = 40
    static let cellDateHeight: CGFloat = 20
    static let watchButtonHeight: CGFloat = 60
    static let ratingViewHeight: CGFloat = 40
    
    ///Width
    static let watchButtonWidth: CGFloat = 180
}

extension UIImage {
    static let noImage: UIImage? = UIImage(systemName: "xmark")
}

extension UIColor {
    static let redIconColor = #colorLiteral(red: 0.8588235294, green: 0.2509803922, blue: 0.3137254902, alpha: 1)
    static let mainAppColor = #colorLiteral(red: 0.1764705882, green: 0.1568627451, blue: 0.2078431373, alpha: 1)
    static let prettyWhite = #colorLiteral(red: 0.9681384154, green: 0.9681384154, blue: 0.9681384154, alpha: 1)
    static let prettyGray = #colorLiteral(red: 0.5794862689, green: 0.5794862689, blue: 0.5794862689, alpha: 1)
}

extension String {
    static let appIconTitleAddon: String = "Watch on"
    static let appIconTittleFull: String = "Movve"
    static let appIconTittleFirst: String = "Mov"
    static let appIconTittleSecond: String = "ve"
    
    static let castSectionTitle = "Cast"
    static let overviewSectionTitle = "Overview"
}
