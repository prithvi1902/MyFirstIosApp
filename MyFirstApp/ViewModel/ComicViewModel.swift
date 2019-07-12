//
//  ComicViewModel.swift
//  MyFirstApp
//
//  Created by Prithvi on 12/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import then

enum ComicError: Error {
    case invalidId
}

class ComicViewModel {
    
    var characterId = -1
    
    init(characterId: Int) {
        self.characterId = characterId
    }
    
//    func fetchAllComics() -> Promise<[Collection]> {
//        guard characterId != -1 else { return Promise.reject(ComicError.invalidId) }
//        return Api.service(.comicsUrl(characterId))
//    }
}
