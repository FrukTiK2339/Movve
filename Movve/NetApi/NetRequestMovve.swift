//
//  NetRequestMovve.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 29.12.2022.
//

import Foundation

class NetRequestMovve {
    
    var movve: Movve
    
    init(with movve: Movve) {
        self.movve = movve
    }
    
    func getMovve(with url: URL,_ urlSession: URLSession, result: @escaping ([Any]?) -> Void) {
        netRequester.processRequest(with: url, urlSession) { data in
            guard let recivedData = data else {
                DLog("Error processing Movve call.")
                result(nil)
                return
            }
            switch self.movve {
            case .movie:
                result(self.parseMovieJSON(for: recivedData))
            case .tvshow:
                result(self.parseTVShowJSON(for: recivedData))
           
            }
        }
    }
    
    //MARK: - Private
    private let dispatchGroup = DispatchGroup()
    
    private func parseMovieJSON(for data: [String: Any]) -> [Any]? {
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
                dispatchGroup.enter()
                
                imageLoader.download(with: imageURL) { [weak self] image in
                    let newMovie = Movie(
                        id: id,
                        title: title,
                        releaseDate: releaseDate,
                        posterImage: image
                    )
                    receivedMovies.append(newMovie)
                    self?.dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.wait()
        DLog(receivedMovies.description)
        return receivedMovies
    }
    
    private func parseTVShowJSON(for data: [String: Any]) -> [Any]? {
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
                dispatchGroup.enter()
                imageLoader.download(with: imageURL) { [weak self] image in
                    
                    let newMovie = TVShow(
                        id: id,
                        name: name,
                        releaseDate: releaseDate,
                        posterImage: image
                    )
                    receivedTVShows.append(newMovie)
                    self?.dispatchGroup.leave()
                    
                }
            }
        }
        dispatchGroup.wait()
        DLog(receivedTVShows.description)
        return receivedTVShows
    }
}
