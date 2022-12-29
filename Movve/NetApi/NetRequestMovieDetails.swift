//
//  NetRequestMovieDetails.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 28.12.2022.
//

import Foundation

class NetRequestMovieDetails: NetApiRequestProtocol {
    
    var targetType: TargetType?
    var searchType: SearchType?
    
    init(targetType: TargetType? = nil, searchType: SearchType? = nil) {
        self.targetType = .movie
        self.searchType = searchType
    }
    
    private let tasks = DispatchGroup()
    
    func parse(_ detailDict: [String: Any]) -> [Any]? {
        guard let genresDict = detailDict["genres"] as? [[String: Any]],
              let homepage = detailDict["homepage"] as? String,
              let overview = detailDict["overview"] as? String,
              let rating = detailDict["vote_average"] as? Double,
              let runtime = detailDict["runtime"] as? Int,
              let imageStr = detailDict["backdrop_path"] as? String
        else {
            return nil
        }
        var receivedDetails: MovieDetails?
        
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
            receivedDetails = MovieDetails(
                genres: receivedGenres,
                runtime: runtime,
                rating: rating,
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
