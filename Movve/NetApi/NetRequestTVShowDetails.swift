//
//  NetRequestTVShowOverview.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 30.12.2022.
//

import Foundation

class NetRequestTVShowDetails {
    
    func getDetails(with url: URL, _ urlSession: URLSession, result: @escaping (TVShowDetails?) -> Void) {
        netRequester.processRequest(with: url, urlSession) { details in
            guard let details = details else {
                DLog("Error processing TVShow Details call.")
                result(nil)
                return
            }
            result(self.parseJSON(details))
        }
    }
    
    //MARK: - Private 
    
    private let dispatchGroup = DispatchGroup()
    
    private func parseJSON(_ detailDict: [String: Any]) -> TVShowDetails? {
        
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
        dispatchGroup.enter()
        imageLoader.download(with: imageStr) { [weak self] image in
            receivedDetails = TVShowDetails(
                genres: receivedGenres,
                rating: rating,
                seasons: seasons.count,
                overview: overview,
                homepage: homepage,
                image: image
            )
            self?.dispatchGroup.leave()
            
        }
        dispatchGroup.wait()
        DLog(receivedDetails)
        return receivedDetails
    }
}
