//
//  NetApiRequest.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 14.12.2022.
//

import Foundation
import UIKit

class NetApiRequest: NetApiRequestProtocol, CustomURLSessionProviderProtocol {
   
    var urlSessionProvider: CustomURLSessionProtocol {
        return ImageLoader.shared
    }
    
    var targetType: TargetType
    var searchType: SearchType
    
    var sessuin: URLSession?
    
    var masterURL: URL? {
        createURL()
    }

    let tasks = DispatchGroup()
    
    //MARK: - Init
    init(targetType: TargetType, searchType: SearchType) {
        self.targetType = targetType
        self.searchType = searchType
    }
    
    
    func createURL() -> URL? {
        let urlString = NetApiRequest.baseURL + targetType.urlPart + searchType.urlPart + NetApiRequest.apiKey
        guard let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    //Main call
    func processCall(completion: @escaping (Any?) -> Void) {
        guard let url = masterURL, let urlSession = urlSessionProvider.urlSession else {
            completion(nil)
            return
        }
        
        DLog("Current URL = \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = NetApiRequest.timeoutMaxTime
        
        
        urlSession.dataTask(with: request, completionHandler: { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                DLog("Error: Not a valid http response. Check your VPN")
                completion(nil)
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
            case 400:
                DLog("Status code - 400.")
                fallthrough
            default:
                completion(nil)
            }
        }).resume()
    }
}
