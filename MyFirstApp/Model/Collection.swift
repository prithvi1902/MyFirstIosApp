//
//  Collection.swift
//  MyFirstApp
//
//  Created by Prithvi on 12/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import Arrow
import then

enum MarvelCollection: Int, CaseIterable {
    case comics, series
}

struct MarvelCollectionType {
    let title: MarvelCollection
    var items: [MarvelCollectable]
}

protocol MarvelCollectable {
    var id: Int { get set }
    var imagePath: String { get set }
    var imageExtension: String { get set }
}

extension MarvelCollectable {
    var thumbnail: String {
        return imagePath + "." + imageExtension
    }
    
    mutating func parse(_ json: JSON) {
        imagePath <-- json["images.path"]
        imageExtension <-- json["images.extension"]
        id <-- json["id"]
    }
}

struct Comics: MarvelCollectable, ModelType {
    var id = -1
    var imagePath = ""
    var imageExtension = ""
    var desc = ""
    
    mutating func deserialize(_ json: JSON) {
        parse(json)
        desc <-- json["description"]
    }
}

struct Series: MarvelCollectable, ModelType {
    var id = -1
    var imagePath = ""
    var imageExtension = ""
    
    mutating func deserialize(_ json: JSON) {
        parse(json)
    }
}

class MarvelCollectionViewModel {
    var data = MarvelCollection.allCases.map { MarvelCollectionType(title: $0, items: .empty) } {
        didSet {
            update?()
        }
    }
    let characterId: Int
    
    var update: (() -> Void)?
    
    init(_ characterId: Int) {
        self.characterId = characterId
    }
    
    func fetch() {
        guard characterId != -1 else { return }
        let comic: Promise<[Comics]> = Api.service(.comicsUrl(characterId))
//        let series: Promise<[Series]> = Api.service(.comicsUrl(characterId))
        comic.then { [weak self] in self?.data[MarvelCollection.comics.rawValue].items = $0 }
        
    }
}
