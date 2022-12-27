//
//  ImageLoader.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit

protocol CustomURLSessionProviderProtocol {
    var urlSessionProvider: CustomURLSessionProtocol { get }
}

protocol CustomURLSessionProtocol {
    var urlSession: URLSession? { get }
}

class ImageLoader: CustomURLSessionProtocol {
    
    static let shared = ImageLoader()
    
    var urlSession: URLSession?
 
    func download(with urlString: String, completion: @escaping (UIImage?) -> Void) {
        let downloadURLString = ImageLoader.baseURL + urlString
        guard let url = URL(string: downloadURLString), let urlSession = urlSession else {
            DLog("Invalid url")
            completion(nil)
            return
        }
        urlSession.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DLog("Successfull loaded image")
                completion(image)
            } else {
                DLog("Couldn't load image for \(downloadURLString)")
                completion(nil)
            }
        }.resume()
    }
}
