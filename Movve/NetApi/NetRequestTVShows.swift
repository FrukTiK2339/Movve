//
//  NetRequestTVShows.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 16.12.2022.
//

import Foundation

class NetRequestTVShows: NetApiRequest {
    
//    private let tasks = DispatchGroup()
    
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
               let imageURL = tDict["poster_path"] as? String {
                tasks.enter()
                ImageLoader.shared.download(with: imageURL) { [weak self] image in
                    
                    let newMovie = TVShow(
                        id: id,
                        name: name,
                        releaseDate: releaseDate,
                        posterImage: image
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
    
    //Details Call
    func processTVShowDetailsCall(completion: @escaping (TVShowDetails?) -> Void) {
        processCall { data in
            guard let nDict = data as? [String: Any] else {
                completion(nil)
                return
            }
            completion(self.parseDetails(nDict))
        }
    }
    
    //Parse Details Call
    private func parseDetails(_ detailDict: [String: Any]) -> TVShowDetails? {
        guard let genresDict = detailDict["genres"] as? [[String: Any]],
              let homepage = detailDict["homepage"] as? String,
              let overview = detailDict["overview"] as? String,
              let rating = detailDict["vote_average"] as? Double,
              let seasons = detailDict["seasons"] as? [[String: Any]],
              let imageStr = detailDict["backdrop_path"] as? String
        else {
            return nil
        }
        var receivedDetails: TVShowDetails?
        
        var receivedGenres = [Genre]()
        for genreDict in genresDict {
            if let id = genreDict["id"] as? Int,
               let name = genreDict["name"] as? String {
                let newGenre = Genre(
                    id: id,
                    name: name
                )
                receivedGenres.append(newGenre)
            }
        }
        tasks.enter()
        ImageLoader.shared.download(with: imageStr) { [weak self] image in
            receivedDetails = TVShowDetails(
                genres: receivedGenres,
                rating: rating,
                seasons: seasons.count,
                overview: overview,
                homepage: homepage,
                image: image
            )
            self?.tasks.leave()
            
        }
        tasks.wait()
        DLog(receivedDetails)
        return receivedDetails
    }
}
