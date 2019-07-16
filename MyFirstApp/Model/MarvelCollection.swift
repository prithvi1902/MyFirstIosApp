//
//  Collection.swift
//  MyFirstApp
//
//  Created by Prithvi on 12/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import Arrow
import then
import Foundation

enum MarvelCollection: Int, CaseIterable {
    case comics, series, stories
    var title: String {
        switch self {
        case .comics:
            return "Comics"
        case .series:
            return "Series"
        case .stories:
            return "Stories"
        }
    }
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

extension MarvelCollectable {
    
    var comic: Comics? {
        return self as? Comics
    }
    
    var series: Series? {
        return self as? Series
    }
    
    var stories: Stories? {
        return self as? Stories
    }
}

struct Image: ModelType {
    
    var imagePath = ""
    var imageExtension = ""
    var imageUrl: String {
        return imagePath + "." + imageExtension
    }
    
    mutating func deserialize(_ json: JSON) {
        imagePath <-- json["path"]
        imageExtension <-- json["extension"]
    }
}

extension MarvelCollectable {
    
    var imageUrl: String {
        guard let images = images.first else { return "" }
        return images.imagePath + "." + images.imageExtension
    }
    
    var thumbnailUrl: String {
        return thumbnail.imagePath + "." + thumbnail.imageExtension
    }
    
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

struct Stories: MarvelCollectable, ModelType {
    
    var images: [Image] = .empty
    var id = -1
    var title = ""
    var desc = ""
    var thumbnail = Image(imagePath: "", imageExtension: "")
    
    mutating func deserialize(_ json: JSON) {
        parse(json)
        desc <-- json["description"]
    }
}
