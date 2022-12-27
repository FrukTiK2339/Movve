//
//  NetRequestMovies.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 14.12.2022.
//

import Foundation
import UIKit

class NetRequestMovies: NetApiRequest {
    
//    private let tasks = DispatchGroup()
    
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
                
                ImageLoader.shared.download(with: imageURL) { [weak self] image in
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
    
    //Details Call
    func processMovieDetailsCall(completion: @escaping (MovieDetails?) -> Void) {
        processCall { data in
            guard let nDict = data as? [String: Any] else {
                completion(nil)
                return
            }
            completion(self.parseDetails(nDict))
        }
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
