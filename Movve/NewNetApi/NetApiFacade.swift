//
//  NetApiFacade.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 28.12.2022.
//

import Foundation

protocol NetApiConfigProtocol: AnyObject {
    var urlSession: URLSession? { get set }
    
    func setupURLSession()
}



class NetApiFacade: NetApiConfigProtocol {
    static let shared = NetApiFacade()
    
    var urlSession: URLSession?
    
    var url: URL?
    
    func setupURLSession() {
        self.urlSession = URLSession.shared
    }
    
    let apiProcessor = NetProcessRequest()
    
    func process(apiRequest: ApiRequest, requestCompletion: @escaping (Any?) -> Void) {
        let request = URLRequest(url: url!)
        
        apiProcessor.process(apiRequest: apiRequest, urlSession: urlSession, request: request) { <#Any?#> in
            <#code#>
        }
        
    
    }
    
}
