//
//  URLSessionManager.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 09.01.2023.
//

import Foundation

protocol URLSessionManagerProtocol: AnyObject {
    var urlSession: URLSession? { get set }
    func configureURLSession()
}

class URLSessionManager: URLSessionManagerProtocol {
    
    static let shared: URLSessionManagerProtocol = URLSessionManager()
    
    var urlSession: URLSession?
    
    func configureURLSession() {
        let config = URLSessionConfiguration.default
        let operQueue = OperationQueue()
        operQueue.maxConcurrentOperationCount = 3
        self.urlSession = URLSession(configuration: config, delegate: nil, delegateQueue: operQueue)
    }
}
