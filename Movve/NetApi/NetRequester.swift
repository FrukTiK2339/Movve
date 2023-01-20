//
//  NetProcessRequest.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 30.12.2022.
//

import Foundation

protocol NetRequesterProtocol: AnyObject {
    func processRequest(with url: URL, _ urlSession: URLSession, result: @escaping ([String: Any]?) -> Void)
}

class NetRequester: NetRequesterProtocol {
    
    func processRequest(with url: URL, _ urlSession: URLSession, result: @escaping ([String: Any]?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        urlSession.dataTask(with: request, completionHandler: { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                DLog("Error: Not a valid http response. Check your VPN")
                NotificationCenter.default.post(name: Notification.Name.errorLoadingData, object: nil)
                result(nil)
                return
            }
            switch httpResponse.statusCode {
            case 200:
                do {
                    guard let recivedData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                        result(nil)
                        return
                    }
                    result(recivedData)
                }
            case 400:
                DLog("Status code - 400.")
                fallthrough
            default:
                result(nil)
            }
        }).resume()
    }
}
