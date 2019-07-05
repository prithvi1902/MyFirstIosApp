//
//  Movie.swift
//  MyFirstApp
//
//  Created by Prithvi on 05/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import UIKit

class Movie{
    var title: String
    var subTitle: String
    var rating: String
    var image: String
    var description: String
    
    init?(title: String, subTitle: String, rating: String, image: String, description: String){
        if title.isEmpty || rating.isEmpty {
            return nil
        }
        self.title = title
        self.subTitle = subTitle
        self.rating = rating
        self.image = image
        self.description = description
    }
}
