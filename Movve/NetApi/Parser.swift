//
//  Parser.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 29.12.2022.
//

import Foundation
/*
class Parser {
    
    ///Image Load
    
    
    ///ActorsCast
    private func parse(_ data: [String: Any]) -> [Cast]? {
        guard let castDicts = data["cast"] as? [[String: Any]] else {
            DLog("Bad data!")
            return nil
        }
        DLog(castDicts)
        var receivedCast = [Cast]()
        
        for mDict in castDicts {
            if let name = mDict["name"] as? String,
               let character = mDict["character"] as? String,
               let imageStr = mDict["profile_path"] as? String {
                tasks.enter()
                ImageLoader.shared.download(with: imageStr) { [weak self] image in
                    let newCast = Cast(
                        name: name,
                        character: character,
                        avatar: image
                    )
                    receivedCast.append(newCast)
                    self?.tasks.leave()
                }
            }
        }
        tasks.wait()
        DLog(receivedCast.description)
        return receivedCast
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
    
    
    
    //Parse Details Call
    private func parseDetails(_ detailDict: [String: Any]) -> MovieDetails? {
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
*/
