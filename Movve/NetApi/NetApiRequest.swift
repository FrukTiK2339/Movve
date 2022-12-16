//
//  NetApiRequest.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 14.12.2022.
//

import Foundation
import UIKit

class NetApiRequest: NetApiRequestProtocol {
    
    var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    
    var movieType: MovieType
    var searchType: SearchType
    
    var masterURL: URL? {
        createURL()
    }
    
    init(movieType: MovieType, searchType: SearchType) {
        self.movieType = movieType
        self.searchType = searchType
    }
    
    
    func createURL() -> URL? {
        let urlString = NetApiRequest.baseURL + movieType.urlPart + searchType.urlPart + NetApiRequest.apiKey
        guard let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    func processCall(completion: @escaping (Any?) -> Void) {
        guard let url = masterURL else {
            return
        }
        
        DLog("Current URL = \(url)")
        
        let apiSession = URLSession(configuration: configuration)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = NetApiRequest.timeoutMaxTime
        
        let dataTask = apiSession.dataTask(with: request, completionHandler: { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                print("error: not a valid http response")
                return
            }
            switch httpResponse.statusCode {
            case 200:
                do {
                    guard let recivedData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                        completion(nil)
                        return
                    }
                    completion(recivedData)
                }
            case 400: break
            default: break
            }
        })
        dataTask.resume()
    }
    
}
