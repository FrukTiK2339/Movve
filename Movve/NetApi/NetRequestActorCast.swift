//
//  NetRequestMovieCast.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 14.12.2022.
//

import Foundation

class NetRequestActorCast: NetApiRequest {
    
    
    override func createURL() -> URL? {
        let urlString = NetApiRequest.baseURL + targetType.urlPart + searchType.urlPart + NetRequestActorCast.creditsURL + NetApiRequest.apiKey
        guard let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    func processCall(completion: @escaping ([Cast]?) -> Void) {
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
               let imageStr = mDict["profile_path"] as? String {
                tasks.enter()
                imageLoader.download(with: imageStr) { [weak self] image in
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
}
