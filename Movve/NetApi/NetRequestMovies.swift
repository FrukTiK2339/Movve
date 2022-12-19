//
//  NetRequestMovies.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 14.12.2022.
//

import Foundation
import UIKit

class NetRequestMovies: NetApiRequest {
    
//    let tasks = DispatchGroup()
    
    init(searchType: SearchType) {
        super.init(targetType: .movie, searchType: searchType)
    }
    
    func processMovieCall(completion: @escaping ([Movie]?) -> Void) {
        super.processCall { data in
            guard let nDict = data as? [String: Any] else {
                completion(nil)
                return
            }
            completion(self.parseMovie(nDict))
        }
    }
    
    private func parseMovie(_ data: [String: Any]) -> [Movie]? {
        guard let movieDicts = data["results"] as? [[String: Any]] else {
            DLog("Bad data!")
            return nil
        }
        DLog(movieDicts)
        var receivedMovies = [Movie]()
        
        for mDict in movieDicts {
            
            if let id = mDict["id"] as? Int,
               let title = mDict["title"] as? String,
               let releaseDate = mDict["release_date"] as? String,
               let imageURL = mDict["poster_path"] as? String {
                tasks.enter()
                imageLoader.download(with: imageURL) { [weak self] image in
                    let newMovie = Movie(
                        id: id,
                        title: title,
                        releaseDate: releaseDate,
                        posterImage: image
                    )
                    receivedMovies.append(newMovie)
                    self?.tasks.leave()
                }
            }
        }
        tasks.wait()
        DLog(receivedMovies.description)
        return receivedMovies
    }
}
