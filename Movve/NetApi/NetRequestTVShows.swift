//
//  NetRequestTVShows.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import Foundation

class NetRequestTVShows: NetApiRequest {
    
    
    let tasks = DispatchGroup()
    
    init(searchType: SearchType) {
        super.init(targetType: .tvshow, searchType: searchType)
    }
    
    func processTVShowCall(completion: @escaping ([TVShow]?) -> Void) {
        super.processCall { data in
            guard let nDict = data as? [String: Any] else {
                completion(nil)
                return
            }
            completion(self.parseTVShow(nDict))
        }
    }
    
    private func parseTVShow(_ data: [String: Any]) -> [TVShow]? {
        guard let tvshowDicts = data["results"] as? [[String: Any]] else {
            DLog("Bad data!")
            return nil
        }
        DLog(tvshowDicts)
        var receivedTVShows = [TVShow]()
        
        for tDict in tvshowDicts {
            
            if let id = tDict["id"] as? Int,
               let name = tDict["name"] as? String,
               let releaseDate = tDict["first_air_date"] as? String,
               let imageURL = tDict["poster_path"] as? String,
               let rating = tDict["vote_average"] as? Double {
                tasks.enter()
                ImageLoader.shared.download(with: imageURL) { [weak self] image in
                    
                    let newMovie = TVShow(
                        id: id,
                        name: name,
                        releaseDate: releaseDate,
                        posterImage: image,
                        rating: rating
                    )
                    receivedTVShows.append(newMovie)
                    self?.tasks.leave()
                    
                }
               
                
            }
        }
        tasks.wait()
        DLog(receivedTVShows.description)
        return receivedTVShows
    }
}
