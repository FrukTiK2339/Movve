//
//  NetApiFacade.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 29.12.2022.
//

import Foundation

enum NetError: Error {
    case smthGoWrong
}

protocol NetApiFacadeProtocol: AnyObject {
    func loadItems(for itemType: CinemaItemType, searchType: CinemaItemSearchType, result: @escaping (Result<[CinemaItemProtocol], Error>) -> Void)
    func loadItemData(for item: CinemaItemProtocol, result: @escaping (Result<CinemaItemDataProtocol, Error>) -> Void)
}

extension NetApiFacade: URLSessionProvider & URLGeneratorProviderProtocol {
    var urlGenerator: URLGeneratorProtocol {
        return URLGenerator()
    }
    
    var urlSessionProvider: URLSessionManagerProtocol {
        return URLSessionManager.shared
    }
}

class NetApiFacade: NetApiFacadeProtocol {
    
    static let shared: NetApiFacadeProtocol = NetApiFacade()
    
    func loadItems(for itemType: CinemaItemType, searchType: CinemaItemSearchType, result: @escaping (Result<[CinemaItemProtocol], Error>) -> Void) {
        
        guard let items = getItems(with: itemType, searchType: searchType), !items.isEmpty else {
            result(.failure(NetError.smthGoWrong))
            return
        }
        result(.success(items))
    }
    
    func loadItemData(for item: CinemaItemProtocol, result: @escaping (Result<CinemaItemDataProtocol, Error>) -> Void) {
        guard let details = getDetails(for: item),
              let cast = getCast(for: item) else {
            assertionFailure("Error: details/cast data == nil")
            result(.failure(NetError.smthGoWrong))
            return
        }
        switch item.type {
        case .movie:
            let movieData = MovieData(item: item, details: details, cast: cast)
            result(.success(movieData))
        case .tvshow:
            let tvshowData = TVShowData(item: item, details: details, cast: cast)
            result(.success(tvshowData))
        }
    }
    
    //MARK: - Private
    private var url: URL?
    
    fileprivate init() {}
    
    private let dispatchGroup = DispatchGroup()
    
    private func getItems(with itemType: CinemaItemType, searchType: CinemaItemSearchType) -> [CinemaItemProtocol]? {
        guard let url = urlGenerator.generateURL(with: itemType, searchType),
              let urlSession = urlSessionProvider.urlSession else {
            assertionFailure("Error getting master url session!")
            return []
        }
        var cinemaItems: [CinemaItemProtocol]?
        let requestItems = NetParseCinemaItems(with: itemType)
        dispatchGroup.enter()
        requestItems.getItems(with: url, urlSession) { items in
            cinemaItems = items
            self.dispatchGroup.leave()
        }
        dispatchGroup.wait()
        return cinemaItems
    }
    
    private func getDetails(for item: CinemaItemProtocol) -> CinemaItemDetailsProtocol? {
        url = urlGenerator.generateURL(with: item, type: item.type)
        
        guard let masterURL = url, let masterURLSession = urlSessionProvider.urlSession else {
            assertionFailure("Error: masterURL/masterURLSession == nil /n URL = \(String(describing: url))")
            return nil
        }
        
        var itemDetails: CinemaItemDetailsProtocol?
        let requestDetails = NetParseDetails(itemType: item.type)
            dispatchGroup.enter()
            requestDetails.getDetails(with: masterURL, masterURLSession, result: { details in
                guard details != nil else {
                    assertionFailure("Error getting details for \(item)")
                    return
                }
                itemDetails = details
                self.dispatchGroup.leave()
            })
        dispatchGroup.wait()
        return itemDetails
    }
    
    
    private func getCast(for item: CinemaItemProtocol) -> [Cast]?{
        
        url = urlGenerator.generateCastURL(with: item, type: item.type)
        
        guard let masterURL = url, let masterURLSession = urlSessionProvider.urlSession else {
            DLog("Error: masterURL/masterURLSession == nil")
            return nil
        }
        
        var cast: [Cast]?
        let requestCast = NetParseActorCast()
        dispatchGroup.enter()
        requestCast.getCast(with: masterURL, masterURLSession) { castData in
            guard castData != nil else {
                DLog("Occured nil Actor Cast Data.")
                return
            }
            cast = castData
            self.dispatchGroup.leave()
        }
        dispatchGroup.wait()
        return cast
    }
}
