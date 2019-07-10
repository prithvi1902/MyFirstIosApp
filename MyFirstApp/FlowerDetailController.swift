//
//  FlowerDetailController.swift
//  MyFirstApp
//
//  Created by Prithvi on 09/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import UIKit
import Stevia

class FlowerDetailController: ViewController{
    
    let flower: Flower
    
    init(_ flower: Flower) {
        self.flower = flower
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "back"), for: UIControl.State.normal)
        $0.onTap{ [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    let shareButton = UIButton().then {
        $0.setImage(UIImage(named: "share"), for: UIControl.State.normal)
    }
    
    lazy var animateImageView = UIImageView().then {
        $0.image(flower.imageName)
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 40.0
        $0.clipsToBounds = true
        $0.backgroundColor = .cardBg
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.isUserInteractionEnabled = true
    }
    
    lazy var favouriteContainer = UIButton().then {
        $0.size(50)
        $0.backgroundColor = #colorLiteral(red: 0.6160473824, green: 0.7516079545, blue: 0.6193038821, alpha: 1)
        $0.layer.cornerRadius = 10.0
        favouriteIcon.image(flower.favImage, tint: flower.favTint)
        $0.onTap { [weak self] _ in
            self?.flower.isFavourite.toggle()
            guard let flower = self?.flower else { return }
            self?.favouriteIcon.image(flower.favImage, tint: flower.favTint)
        }
    }
    
    let favouriteIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.size(30)
    }
    
    let container = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30.0
        $0.clipsToBounds = true
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    lazy var titleLabel = UILabel().then {
        $0.style(flower.name, font: UIFont.boldSystemFont(ofSize: 24), color: .darkGreen)
    }
    
    lazy var contentLabel = UILabel().then {
        $0.style(flower.description, color: .darkGreen, isMultiline: true)
        $0.setContentHuggingPriority(.init(249), for: .vertical)
    }
    
    let tipsLabel = UILabel().then {
        $0.style("Tips", font: .boldSystemFont(ofSize: 16), color: .darkGreen)
    }
    
    let collectionView = CollectionView<Any, Tips>(.horizontal, lineSpacing: 20,  widthFactor: 0.45, height: 200).then {
        $0.contentInset.left = 15
        $0.register(FlowerDetailCollectionCell.self)
        $0.configureCell = { table, index, item in
            table.dequeueCell(FlowerDetailCollectionCell.self, at: index, with: item)
        }
        $0.showsHorizontalScrollIndicator = false
        $0.updateItems(List.dataSource(sections: .empty, items: [
            [
                Tips(tipId: 0, tipName: "Temperature", tipData: "35-40 F", imageName: "temperature"),
                Tips(tipId: 1, tipName: "Light", tipData: "Diffused", imageName: "light"),
                Tips(tipId: 2, tipName: "Water", tipData: "Soaked", imageName: "water"),
                ]
            ]
        ))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func render() {
        view.sv(
            animateImageView.sv(backButton, shareButton),
                favouriteContainer.sv(favouriteIcon),
                container.sv(titleLabel,
                             contentLabel,
                             tipsLabel,
                             collectionView)
        )
        view.bringSubviewToFront(favouriteContainer)
        backButton.top(20).left(20).size(25)
        shareButton.top(10).right(20).size(30)
        animateImageView.top(44).right(10).left(10).heightEqualsWidth()
        container.Top == animateImageView.Bottom - 30
        container.left(10).right(10).bottom(0)
        favouriteContainer.Top == animateImageView.Bottom - 55
        favouriteContainer.Right == animateImageView.Right - 30
        favouriteIcon.centerInContainer()
        container.layout(
            20,
            |-20-titleLabel-20-|,
            20,
            |-20-contentLabel-20-|,
            10,
            |-20-tipsLabel-20-|,
            10,
            |collectionView| ~ 200,
            >=10
        )
    }
}

class FlowerDetailCollectionCell: CollectionViewCell, Configurable {
    
    let container = UIView().then {
        $0.layer.cornerRadius = 8
    }
    
    let tipImageView = UIImageView().then {
        $0.size(40)
    }
    
    let tipNameLabel = UILabel().then {
        $0.style("", color: .offGreen)
    }
    
    let tipDataLabel = UILabel().then {
        $0.style("", font: UIFont.boldSystemFont(ofSize: 18), color: .white)
    }
    
    override func render() {
        sv(container.sv(tipImageView, tipNameLabel, tipDataLabel))
        container.fillContainer(5)
        container.layout(
            10,
            |-10-tipImageView,
            >=10,
            |-20-tipNameLabel,
            5,
            |-20-tipDataLabel,
            8
        )
    }
    
    func configure(_ item: Tips) {
        tipImageView.image(item.imageName)
        tipNameLabel.text = item.tipName
        tipDataLabel.text = item.tipData
        if(item.tipId % 2 == 0){
            container.backgroundColor = #colorLiteral(red: 0.2928979099, green: 0.4435624182, blue: 0.4485201836, alpha: 1)
        }else {
            container.backgroundColor = #colorLiteral(red: 0.1554678977, green: 0.2945384383, blue: 0.2952496409, alpha: 1)
        }
    }
}
