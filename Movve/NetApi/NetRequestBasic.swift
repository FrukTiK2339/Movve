//
//  NetRequestBasic.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 30.12.2022.
//

import Foundation

class NetRequestBasic: NetImageLoaderProviderProtocol & NetRequesterProviderProtocol {
    var imageLoader: NetImageLoaderProtocol {
        return NetImageLoader.shared
    }
    
    var netRequester: NetRequesterProtocol {
        return NetRequester()
    }
}
