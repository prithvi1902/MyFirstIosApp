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
    var title: String { get set }
    var images: [Image] { get set }
    var thumbnail: Image { get set }
}

struct Image: ModelType {
    var imagePath = ""
    var imageExtension = ""
    
    mutating func deserialize(_ json: JSON) {
        imagePath <-- json["path"]
        imageExtension <-- json["extension"]
    }
}

extension MarvelCollectable {
    
    mutating func parse(_ json: JSON) {
        images <-- json["images"]
        id <-- json["id"]
        title <-- json["title"]
        thumbnail <-- json["thumbnail"]
    }
}

struct Comics: MarvelCollectable, ModelType {
    var id = -1
    var desc = ""
    var title = ""
    var images = [Image(imagePath: "", imageExtension: "")]
    var thumbnail = Image(imagePath: "", imageExtension: "")
    
    mutating func deserialize(_ json: JSON) {
        parse(json)
        desc <-- json["description"]
    }
}

struct Series: MarvelCollectable, ModelType {
    var id = -1
    var title = ""
    var images = [Image(imagePath: "", imageExtension: "")]
    var thumbnail = Image(imagePath: "", imageExtension: "")
    
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
        print("DATA: \(data)")
    }
}
