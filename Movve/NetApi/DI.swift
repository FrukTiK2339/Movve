//
//  DI.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 30.12.2022.
//

import UIKit

protocol URLGeneratorProviderProtocol: AnyObject {
    var urlGenerator: URLGeneratorProtocol { get }
}

protocol NetRequesterProviderProtocol: AnyObject {
    var netRequester: NetRequesterProtocol { get }
}

protocol NetImageLoaderProviderProtocol: AnyObject {
    var imageLoader: NetImageLoaderProtocol { get }
}

protocol NetApiFacadeProviderProtocol: AnyObject {
    var netApiFacade: NetApiFacadeProtocol { get }
}

protocol URLSessionProvider: AnyObject {
    var urlSessionProvider: URLSessionManagerProtocol { get }
}


