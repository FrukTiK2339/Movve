//
//  AnimationCollectionViewCellProtocol.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 23.01.2023.
//

import UIKit

protocol AnimationCollectionViewCellProtocol: UICollectionViewCell {
    var cinemaItemTitleLabel: UILabel { get }
    var cinemaItemDateReleaseLabel: UILabel { get }
    var cinemaItemImageView: UIImageView { get }
}
