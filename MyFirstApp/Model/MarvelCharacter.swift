//
//  MarvelCharacter.swift
//  MyFirstApp
//
//  Created by Prithvi on 12/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import Arrow

class MarvelCharacter: ModelType {
    
    required init() {}
    
    var characterId = -1
    var name = ""
    var desc = ""
    var imagePath = ""
    var imageExtension = ""
    var isFavourite: Bool = false
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
    
    var favImage: String {
        return isFavourite ? "favorite" : "unfavorite"
    }
    
    var favTint: UIColor? {
        return isFavourite ? UIColor.red : nil
    }
}
