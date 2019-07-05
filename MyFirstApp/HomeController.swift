//
//  HomeController.swift
//  MyFirstApp
//
//  Created by Prithvi on 04/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import UIKit

class HomeController: ViewController {
    
    let titleLabel = UILabel().then{
        $0.text("This is the home screen")
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    override func render() {
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        view.sv(titleLabel)
        titleLabel.centerHorizontally().centerVertically()
    }
}

//            let willTransform = (self?.circle.transform.isIdentity).value
//            self?.circle.alpha = willTransform ? 0.5 : 1
//            UIView.animate(withDuration: 0.5, animations: {
//                button.transform = willTransform ? CGAffineTransform(rotationAngle: .pi) : .identity
//                self?.circle.transform =  willTransform ? CGAffineTransform(scaleX: 40, y: 40) : .identity
//                self?.circle.alpha = willTransform ? 1 : 0.5
//            })
//        view.sv(circle, button)
//circle.circle(300).centerInContainer()
//button.circle(44).centerInContainer()

//    let circle = UIView().then { $0.backgroundColor = .red; $0.alpha = 0.5
