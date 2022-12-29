//
//  NetImageLoaderProvider.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 29.12.2022.
//

import UIKit

protocol NetImageLoaderProviderProtocol: AnyObject {
    var imageLoader: NetImageLoaderProtocol { get }
}

protocol NetImageLoaderProtocol: AnyObject {
    func download(with urlString: String, completion: @escaping (UIImage?) -> Void)
}


