//
//  MarvelDetailController.swift
//  MyFirstApp
//
//  Created by Prithvi on 12/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import UIKit
import Stevia

class MarvelDetailController: ViewController{
    
    let marvelCharacter: MarvelCharacter
    
    lazy var viewModel = MarvelCollectionViewModel(marvelCharacter.characterId)
    
    init(_ marvelCharacter: MarvelCharacter) {
        self.marvelCharacter = marvelCharacter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "back"), for: UIControl.State.normal)
        $0.onTap{ [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    lazy var tableView = TableView<String,MarvelCollectionType>().then {
        $0.update(List.dataSource(sections: .empty, items: [viewModel.data]))
    }
    
    override func render() {
       
    }
    
    override func setupUI() {
        viewModel.fetch()
        viewModel.update = { [weak self] in
            guard let `self` = self else { return }
            self.tableView.update(List.dataSource(sections: .empty, items: [self.viewModel.data]))
        }
    }
}


//class MarvelDetailCollectionCell: CollectionViewCell, Configurable {
//
//    let container = UIView().then {
//        $0.layer.cornerRadius = 8
//    }
//
//    let tipImageView = UIImageView().then {
//        $0.size(40)
//    }
//
//    let tipNameLabel = UILabel().then {
//        $0.style("", color: .offGreen)
//    }
//
//    let tipDataLabel = UILabel().then {
//        $0.style("", font: UIFont.boldSystemFont(ofSize: 18), color: .white)
//    }
//
//    override func render() {
//        sv(container.sv(tipImageView, tipNameLabel, tipDataLabel))
//        container.fillContainer(5)
//        container.layout(
//            10,
//            |-10-tipImageView,
//            >=10,
//            |-20-tipNameLabel,
//            5,
//            |-20-tipDataLabel,
//            8
//        )
//    }
//
//    func configure(_ item: Tips) {
//        tipImageView.image(item.imageName)
//        tipNameLabel.text = item.tipName
//        tipDataLabel.text = item.tipData
//        if(item.tipId % 2 == 0){
//            container.backgroundColor = #colorLiteral(red: 0.2928979099, green: 0.4435624182, blue: 0.4485201836, alpha: 1)
//        }else {
//            container.backgroundColor = #colorLiteral(red: 0.1554678977, green: 0.2945384383, blue: 0.2952496409, alpha: 1)
//        }
//    }
//}
//
