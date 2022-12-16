//
//  NetRequestMovies.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 14.12.2022.
//

import Foundation
import UIKit

class NetRequestMovies: NetApiRequest {
    
    func processMovieCall(completion: @escaping ([Movie]?) -> Void) {
        super.processCall { data in
            guard let nDict = data as? [String: Any] else {
                completion(nil)
                return
            }
            completion(self.parseMovie(nDict))
        }
    }
    
    func processMovieDetailsCall(completion: @escaping (MovieDetails?) -> Void) {
        super.processCall { data in
            guard let nDict = data as? [String: Any] else {
                completion(nil)
                return
            }
            completion(self.parseDetails(nDict))
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
               let posterImage = mDict["poster_path"] as? String {
                let newMovie = Movie(
                    id: id,
                    title: title,
                    releaseDate: releaseDate,
                    posterImage: posterImage
                )
                receivedMovies.append(newMovie)
            }
        }
        DLog(receivedMovies.description)
        return receivedMovies
    }
    
    private func parseDetails(_ detailDict: [String: Any]) -> MovieDetails? {
        guard let runtime = detailDict["runtime"] as? Int,
              let genresDict = detailDict["genres"] as? [[String: Any]],
              let homepage = detailDict["homepage"] as? String,
              let overview = detailDict["overview"] as? String,
              let rating = detailDict["vote_average"] as? Double
        else {
            return nil
        }
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
        let receivedDetails = MovieDetails(
            genres: receivedGenres,
            runtime: runtime,
            rating: rating,
            overview: overview,
            homepage: homepage
        )
        DLog(receivedDetails)
        return receivedDetails
    }
}
