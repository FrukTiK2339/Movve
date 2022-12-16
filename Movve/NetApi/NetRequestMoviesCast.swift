//
//  NetRequestMovieCast.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 14.12.2022.
//

import Foundation

class NetRequestMovieCast: NetApiRequest {
    
    override func createURL() -> URL? {
        let urlString = NetApiRequest.baseURL + movieType.urlPart + searchType.urlPart + NetRequestMovieCast.creditsURL + NetApiRequest.apiKey
        guard let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    func processMovieCastCall(completion: @escaping ([Cast]?) -> Void) {
        super.processCall { data in
            guard let nDict = data as? [String: Any] else {
                completion(nil)
                return
            }
            completion(self.parse(nDict))
        }
    }
    
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
               let avatar = mDict["profile_path"] as? String {
                let newCast = Cast(
                    name: name,
                    character: character,
                    avatar: avatar
                )
                receivedCast.append(newCast)
            }
        }
        DLog(receivedCast.description)
        return receivedCast
    }
}
