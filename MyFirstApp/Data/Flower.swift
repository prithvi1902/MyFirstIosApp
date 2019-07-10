//
//  Flower.swift
//  MyFirstApp
//
//  Created by Prithvi on 09/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import UIKit

class Flower {
    var name: String
    var isFavourite: Bool = false
    var imageName: String
    var description: String = "In botany, succulent plants, also known as succulents, are plants that have some parts that are more than normally thickened and fleshy, usually to retain water in arid climates or soil conditions. The word \"succulent\" comes from the Latin word sucus, meaning juice, or sap."
    
    var favImage: String {
        return isFavourite ? "favorite" : "unfavorite"
    }
    
    var favTint: UIColor? {
        return isFavourite ? UIColor.red : nil
    }
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}
