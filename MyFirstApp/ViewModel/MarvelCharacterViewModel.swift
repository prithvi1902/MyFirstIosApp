//
//  MarvelCharacterViewModel.swift
//  MyFirstApp
//
//  Created by Prithvi on 12/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import then

class MarvelCharacterViewModel {
    
    var data = [MarvelCharacter]()
    
    func fetchAllCharacters() -> Promise<[MarvelCharacter]> {
        return Api.service(.allCharacters)
    }
    
    var filteredData = [MarvelCharacter]()
    
    func query(_ text: String)  {
        filteredData = data.filter { $0.name.localizedCaseInsensitiveContains(text) }
    }
}
