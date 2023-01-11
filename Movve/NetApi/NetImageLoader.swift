//
//  NetImageLoader.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 29.12.2022.
//

import UIKit

protocol NetImageLoaderProtocol: AnyObject {
    func download(with urlString: String, completion: @escaping (UIImage?) -> Void)
}

extension NetImageLoader: URLSessionProvider {
    var urlSessionProvider: URLSessionManagerProtocol {
        return URLSessionManager.shared
    }
}

class NetImageLoader: NetImageLoaderProtocol {
    static let shared = NetImageLoader()
    
    func download(with urlString: String, completion: @escaping (UIImage?) -> Void) {
        let urlStr: String = .imageURLBasic + urlString
        guard let url = URL(string: urlStr), let urlSession = urlSessionProvider.urlSession else {
            DLog("Invalid url")
            completion(nil)
            return
        }
        urlSession.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DLog("Successfull loaded image")
                completion(image)
            } else {
                DLog("Couldn't load image for \(urlStr)")
                completion(nil)
            }
        }.resume()
    }
}
