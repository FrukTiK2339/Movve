//
//  ImageLoader.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import UIKit

class ImageLoader {
    
    static let shared = ImageLoader()
    
    init() {}
    
    var imageDictionary = [String: UIImage?]()
 
    func download(with urlString: String, completion: @escaping (UIImage?) -> Void) {
        let downloadURLString = ImageLoader.baseURL + urlString
        guard let url = URL(string: downloadURLString) else {
            DLog("Invalid url")
            completion(nil)
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DLog("Successfull loaded image")
                completion(image)
            } else {
                DLog("Couldn't load image for \(downloadURLString)")
                completion(nil)
            }
        }
        dataTask.resume()
    }
}
