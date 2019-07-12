//
//  MarvelController.swift
//  MyFirstApp
//
//  Created by Prithvi on 11/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import UIKit
import Stevia
import Arrow
import then

class MarvelCharacter: ModelType {
    
    required init() {}
    
    var characterId = -1
    var name = ""
    var desc = ""
    var imagePath = ""
    var imageExtension = ""
    var thumbnail: String {
        return imagePath + "." + imageExtension
    }
    
    func deserialize(_ json: JSON) {
        characterId <-- json["id"]
        name <-- json["name"]
        desc <-- json["description"]
        imagePath <-- json["thumbnail.path"]
        imageExtension <-- json["thumbnail.extension"]
    }
    
    static func fetchAllCharacters() -> Promise<[MarvelCharacter]> {
        return Api.service(.allCharacters)
    }
}

class MarvelController: ViewController {
    
    let marvelCollection = CollectionView<Any, MarvelCharacter>(.vertical, widthFactor: 0.5, heightFactor: 0.33).then {
        $0.register(MarvelCharacterCollectionCell.self)
        $0.isPagingEnabled = true
        $0.configureCell = { $0.dequeueCell(MarvelCharacterCollectionCell.self, at: $1, with: $2) }
    }
    
    override func render() {
        view.sv(marvelCollection)
        marvelCollection.fillContainer()
    }
    
    override func setupUI() {
        MarvelCharacter.fetchAllCharacters().then(updateCollection)
    }
    
    func updateCollection(_ items: [MarvelCharacter]) {
        marvelCollection.updateItems(List.dataSource(sections: .empty, items: [items]))
    }
}

class MarvelCharacterCollectionCell: CollectionViewCell, Configurable {
    
    let nameLabel = UILabel()
    
    let characterImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.height(200)
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = true
    }
    
    override func render() {
        sv(characterImage, nameLabel)
        characterImage.fillContainer(10)
        nameLabel.left(20).bottom(20)
    }
    
    func configure(_ item: MarvelCharacter) {
        characterImage.load(item.thumbnail)
        nameLabel.text = item.name
    }
}
