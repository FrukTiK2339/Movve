//
//  NetRequesterProvider.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 30.12.2022.
//

import Foundation

protocol NetRequesterProviderProtocol: AnyObject {
    var netRequester: NetRequesterProtocol { get }
}

protocol NetRequesterProtocol: AnyObject {
    func processRequest(with url: URL, _ urlSession: URLSession, result: @escaping ([String: Any]?) -> Void)
}
