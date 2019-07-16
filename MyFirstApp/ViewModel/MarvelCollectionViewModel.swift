//
//  MarvelCollectionViewModel.swift
//  MyFirstApp
//
//  Created by Prithvi on 15/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import then

class MarvelCollectionViewModel {
    
    var data = [MarvelCollectionType(title: MarvelCollection.comics, items: .empty)] {
        didSet {
            onUpdate?()
        }
    }
    
    let characterId: Int
    
    var onUpdate: (() -> Void)?
    
    init(_ characterId: Int) {
        self.characterId = characterId
    }
    
    func fetch() {
        guard characterId != -1 else { return }
//        let dispatchGroup = DispatchGroup()
        let comics: Promise<[Comics]> = Api.service(.comicsUrl(characterId))
        comics.then { [weak self] in self?.data[MarvelCollection.comics.rawValue].items = $0 }
//        let series: Promise<[Series]> = Api.service(.seriesUrl(characterId))
//        let stories: Promise<[Stories]> = Api.service(.storiesUrl(characterId))
//
//        dispatchGroup.enter()
//        comics.then { [weak self] in
//            self?.data[MarvelCollection.comics.rawValue].items = $0
//            }.noMatterWhat { dispatchGroup.leave() }.onError { print($0) }
//
//        dispatchGroup.enter()
//        series.then { [weak self] in
//            self?.data[MarvelCollection.series.rawValue].items = $0
//            }.noMatterWhat { dispatchGroup.leave() }.onError { print($0) }
//
//        dispatchGroup.enter()
//        stories.then { [weak self] in
//            self?.data[MarvelCollection.stories.rawValue].items = $0
//            }.noMatterWhat { dispatchGroup.leave() }.onError { print($0) }
//
//        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
//            self?.onUpdate?()
//        }
    }
}
