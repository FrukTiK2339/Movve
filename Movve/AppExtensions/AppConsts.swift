//
//  AppConsts.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 14.12.2022.
//

import UIKit


extension Notification.Name {
    public static let successDataLoading       = Notification.Name("successDataLoading")
    public static let errorLoadingData         = Notification.Name("errorLoadingData")
    public static let alertDismissed           = Notification.Name("alertDismissed")
    
}

extension UIFont {
    static let iconFontItalic = UIFont(name: "Trebuchet-BoldItalic", size: 32)
    static let launcgIconFont = UIFont(name: "TrebuchetMS-Bold", size: 52)
    static let iconFont       = UIFont(name: "TrebuchetMS-Bold", size: 32)
    static let headerFont     = UIFont(name: "TrebuchetMS-Bold", size: 20)
    static let cellTitleFont  = UIFont(name: "TrebuchetMS-Bold", size: 14)
    static let cellDateFont   = UIFont(name: "TrebuchetMS-Bold", size: 12)
    
    static let actorsNameFont     = UIFont(name: "TrebuchetMS", size: 12)
    static let charactersNameFont = UIFont(name: "TrebuchetMS", size: 10)
    static let sectionsItalicFont = UIFont.italicSystemFont(ofSize: 20)
}

extension CGFloat {
    ///Padding
    static let normalPadding      : CGFloat = 16
    static let smallPadding     : CGFloat = 8
    
    ///Layers
    static let cornerRadius     : CGFloat = 8
    static let imageCornerRadius: CGFloat = 40
    
    ///Height Consts
    static let cellTitleHeight   : CGFloat = 40
    static let cellDateHeight    : CGFloat = 20
    static let bigButtonHeight : CGFloat = 60
    static let ratingViewHeight  : CGFloat = 40
    static let castViewHeight    : CGFloat = 120
    static let castImageViewHeigt: CGFloat = 80
    
    ///Width
    static let bigButtonWidth  : CGFloat = 180
}

extension UIImage {
    static let noImage      = UIImage(systemName: "xmark")
    static let dismissImage = UIImage(systemName: "chevron.down")
    static let starImage    = UIImage(systemName: "star.fill")
}

extension UIColor {
    static let redIconColor = #colorLiteral(red: 0.8588235294, green: 0.2509803922, blue: 0.3137254902, alpha: 1)
    static let mainAppColor = #colorLiteral(red: 0.1764705882, green: 0.1568627451, blue: 0.2078431373, alpha: 1)
    static let prettyWhite  = #colorLiteral(red: 0.9681384154, green: 0.9681384154, blue: 0.9681384154, alpha: 1)
    static let prettyGray   = #colorLiteral(red: 0.5794862689, green: 0.5794862689, blue: 0.5794862689, alpha: 1)
    static let emptySpace = UIColor(white: 1, alpha: 0.2)
}

extension String {
    static let appIconTitleAddon   = "Watch on"
    static let appIconTittleFull   = "Movve"
    static let appIconTittleFirst  = "Mov"
    static let appIconTittleSecond = "ve"
    
    static let castSectionTitle     = "Cast"
    static let overviewSectionTitle = "Overview"
    static let watchButtonTitle     = "Watch now"
}

extension CGSize {
    static let castRowSize = CGSize(width: 90, height: 120)
}
