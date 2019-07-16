//
//  MarvelDetailController.swift
//  MyFirstApp
//
//  Created by Prithvi on 12/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import UIKit
import Stevia

class MarvelDetailController: ViewController {
    
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
    
    lazy var favouriteIcon = UIButton().then {
        $0.contentMode = .scaleAspectFill
        $0.image(marvelCharacter.favImage, tint: marvelCharacter.favTint)
        $0.onTap { [weak self] in
            self?.marvelCharacter.isFavourite.toggle()
            guard let marvelCharacter = self?.marvelCharacter else { return }
            $0.image(marvelCharacter.favImage, tint: marvelCharacter.favTint)
        }
    }
    
    lazy var marvelTitleLabel = UILabel().then {
        $0.style(marvelCharacter.name, font: .boldSystemFont(ofSize: 24))
    }
    
    lazy var marvelImageView = UIImageView().then {
        $0.load(marvelCharacter.thumbnail)
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 40.0
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    let marvelDescContainer = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        $0.layer.cornerRadius = 40.0
        $0.layer.maskedCorners = [.layerMinXMinYCorner]
    }
    
    lazy var marvelDescLabel = UILabel().then {
        $0.style(marvelCharacter.desc, font: .systemFont(ofSize: 18), isMultiline: true)
        $0.textAlignment = .justified
    }
    
    lazy var marvelDetailTableView = TableView<MarvelCollection, MarvelCollectionType>().then {
        $0.bounces = false
        $0.register(MarvelDetailTableViewCell.self)
        $0.configureCell = {
            $0.dequeueCell(MarvelDetailTableViewCell.self, at: $1, with: $2).then {
                $0.onSelect = { [weak self] in
                    self?.navigate(to: .marvelCollection($0), transition: .push)
                }
            }
        }
        $0.headerHeight = { _ in 40 }
        $0.separatorStyle = .none
        $0.header = { _, _, item in UILabel().then { $0.style(item.title) }}
        $0.update(List.dataSource(sections: [MarvelCollection.comics], items: [viewModel.data]))
    }
    
    override func render() {
        view.sv(backButton, marvelImageView.sv(favouriteIcon, marvelTitleLabel), marvelDescContainer.sv(marvelDescLabel, marvelDetailTableView))
        view.layout(
            50,
            |-20-backButton.size(30),
            10,
            |-10-marvelImageView.height(200)-10-|,
            0,
            |-10-marvelDescContainer-10-|,
            0
        )
        marvelImageView.layout(
            20,
            |-20-favouriteIcon.size(30),
            >=10,
            |-20-marvelTitleLabel,
            20
        )
        marvelDescContainer.layout(
            20,
            |-30-marvelDescLabel-20-|,
            10,
            |marvelDetailTableView|,
            0
        )
    }
    
    override func setupUI() {
        viewModel.fetch()
        viewModel.onUpdate = { [weak self] in
            guard let `self` = self else { return }
            self.marvelDetailTableView.update(List.dataSource(sections: [MarvelCollection.comics], items: [self.viewModel.data]))
        }
    }
}

class MarvelDetailTableViewCell: TableViewCell, Configurable {
    
    var onSelect: ((MarvelCollectable) -> Void)?
    
    lazy var marvelTypeCollectionView = CollectionView<Any, MarvelCollectable>(.horizontal, lineSpacing: 10.0, widthFactor: 0.45, heightFactor: 1.0).then {
        $0.register(MarvelTypeCollectionCell.self)
        $0.configureCell = {
            $0.dequeueCell(MarvelTypeCollectionCell.self, at: $1, with: $2)
        }
        $0.didSelect = { [weak self] _, _, item in
            self?.onSelect?(item)
        }
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
    }
    
    override func render() {
        sv(marvelTypeCollectionView)
        marvelTypeCollectionView.fillContainer(10).height(200)
    }
    
    func configure(_ item: MarvelCollectionType) {
        self.marvelTypeCollectionView.updateItems(List.dataSource(sections: .empty, items: [item.items]))
    }
}

class MarvelTypeCollectionCell: CollectionViewCell, Configurable {
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 10.0
        $0.clipsToBounds = true
    }
    
    let titleLabel = UILabel().then {
        $0.style("", font: .boldSystemFont(ofSize: 16), color: .white, isMultiline: true)
    }
    
    override func render() {
        sv(imageView, titleLabel)
        imageView.fillContainer()
        titleLabel.left(10).bottom(10)
    }
    
    func configure(_ item: MarvelCollectable) {
        imageView.load(item.imageUrl)
        titleLabel.text = item.title
    }
}
