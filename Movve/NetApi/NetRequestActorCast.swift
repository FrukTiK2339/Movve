//
//  NetRequestActorCast.swift
//  Movve
//
//  Created by Дмитрий Рыбаков on 30.12.2022.
//

import Foundation

class NetParseActorCast: NetDataParser {
    
    func getCast(with url: URL, _ urlSession: URLSession, result: @escaping ([Cast]?) -> Void) {
        netRequester.processRequest(with: url, urlSession) { data in
            guard let recivedData = data else {
                DLog("Error processing ActorCast call.")
                result(nil)
                return
            }
            result(self.parseJSON(recivedData))
        }
    }
    
    //MARK: - Private
    
    private let dispatchGroup = DispatchGroup()
    
    private func parseJSON(_ data: [String: Any]) -> [Cast]? {
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
                dispatchGroup.enter()
                imageLoader.download(with: imageStr) { [self] image in
                    let newCast = Cast(
                        name: name,
                        character: character,
                        avatar: image
                    )
                    receivedCast.append(newCast)
                    self.dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.wait()
        DLog(receivedCast.description)
        return receivedCast
    }
}
