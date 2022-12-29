//
//  NetApiFacade.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 29.12.2022.
//

import Foundation

class NetApiFacade: NetApiFacadeProtocol {
    static let shared = NetApiFacade()
    
    var urlSession: URLSession?
    
    func loadData(for movve: Movve, category: MovveCategory, result: @escaping ([Any]?) -> Void) {
        ///generate URL
        generateURL(with: movve, category)
        
        guard let masterURL = url, let masterURLSession = urlSession else {
            DLog("Error: masterURL/masterURLSession == nil")
            result(nil)
            return
        }
        DLog("\(movve)")
        let request = NetRequestMovve(with: movve)
        request.process(with: masterURL, masterURLSession, result: { data in
            guard data != nil else {
                DLog("")
                result(nil)
                return
            }
            result(data)
        })
    }
    
    func loadDetailsData(for movie: Movie, result: @escaping (MovieOverview?) -> Void) {
        generateURL(with: movie)
    }
    
    func loadDetailsData(for tvshow: TVShow, result: @escaping (TVShowOverview?) -> Void) {
        generateURL(with: tvshow)
    }
    
    func setupURLSession() {
        let config = URLSessionConfiguration.default
        let operQueue = OperationQueue()
        operQueue.maxConcurrentOperationCount = 3
        self.urlSession = URLSession(configuration: config, delegate: nil, delegateQueue: operQueue)
    }
    
    //MARK: - Private
    private var url: URL?
   
    
    private func generateURL(with movve: Movve, _ category: MovveCategory) {
        let urlStr: String = .dataURLBasic + movve.urlPart + category.urlPart + .apiKey
        guard let url = URL(string: urlStr) else {
            DLog("Error generating URL.")
            return
        }
        self.url = url
    }
    
    private func generateURL(with movie: Movie, movve: Movve? = .movie) {
        let urlStr: String = .dataURLBasic + (movve?.urlPart ?? "") + "/\(movie.id)" + .apiKey
        guard let url = URL(string: urlStr) else {
            DLog("Error generating URL for movie.")
            return
        }
        self.url = url
    }
    
    private func generateURL(with tvshow: TVShow, movve: Movve? = .tvshow) {
        let urlStr: String = .dataURLBasic + (movve?.urlPart ?? "") + "/\(tvshow.id)" + .apiKey
        guard let url = URL(string: urlStr) else {
            DLog("Error generating URL for tvshow.")
            return
        }
        self.url = url
    }
    
}
