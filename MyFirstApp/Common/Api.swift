//
//  MarvelCharacter.swift
//  MyFirstApp
//
//  Created by Prithvi on 11/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import ws
import Arrow
import then
import Keys
import CryptoSwift

protocol ModelType: ArrowParsable {
    init()
}

enum NetworkError: Error {
    case parse
}

enum MethodType {
    case get, post
}

enum MarvelApi {
    case allCharacters
    case comicsUrl(Int)
    case seriesUrl(Int)
    case storiesUrl(Int)
    
    var endpoint: String {
        switch self {
        case .allCharacters:
            return "/v1/public/characters"
        case let .comicsUrl(id):
            return "/v1/public/characters/\(id)/comics"
        case let .seriesUrl(id):
            return "/v1/public/characters/\(id)/series"
        case let .storiesUrl(id):
            return "/v1/public/characters/\(id)/stories"
        }
    }
}

struct Api {
    
    static let baseUrl = "https://gateway.marvel.com"
    
    static func service<T: ModelType>(_ marvelApi: MarvelApi, method: MethodType = .get, params: Params = Params()) -> Promise<[T]> {
        let webService = WS(Api.baseUrl)
        webService.logLevels = .debug
        
        switch method {
        case .get:
            return Promise { resolve, reject in
                webService.get(marvelApi.endpoint, params: parameters(params)).then { (json: JSON) in
                    guard let jsonData = json["data"]?["results"]?.collection else {
                        reject(NetworkError.parse)
                        return
                    }
                    resolve(jsonData.compactMap { data in
                        var model = T.init()
                        model.deserialize(data)
                        return model
                    })
                    }.onError { (error) in
                        reject(error)
                }
            }
        case .post:
            return Promise { resolve, reject in
                webService.post(marvelApi.endpoint, params: parameters(params)).then { (json: JSON) in
                    guard let jsonData = json["data"]?["results"]?.collection else {
                        reject(NetworkError.parse)
                        return
                    }
                    resolve(jsonData.compactMap { data in
                        var model = T.init()
                        model.deserialize(data)
                        return model
                    })
                    }.onError { (error) in
                        reject(error)
                }
            }
        }
    }
    
    private static func parameters(_ params: Params) -> Params {
        let keys = MyFirstAppKeys()
        let privateKey = keys.marvelPrivateKey
        let apiKey = keys.marvelApiKey
        let timeStamp = Date().timeIntervalSince1970.description
        var parameters = Params()
        parameters["apikey"] = apiKey
        parameters["ts"] = timeStamp
        parameters["hash"] = "\(timeStamp)\(privateKey)\(apiKey)".md5()
        parameters += params
        return parameters
    }
}
