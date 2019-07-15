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
    
    lazy var viewModel = ComicViewModel(marvelCharacter.characterId)
    
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
        $0.size(30)
    }
    
    lazy var favouriteIcon = UIButton().then{
        $0.contentMode = .scaleAspectFit
        $0.height(30).width(30)
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
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 40.0
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    let marvelDescContainer = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        $0.layer.cornerRadius = 40.0
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    lazy var marvelDescLabel = UILabel().then {
        $0.style(marvelCharacter.desc, font: .systemFont(ofSize: 18), isMultiline: true)
        $0.textAlignment = .justified
    }
    
    let comicTitleLabel = UILabel().then {
        $0.style("Comics", font: .boldSystemFont(ofSize: 24))
    }
    
    lazy var comicCollectionView = CollectionView<Any, Comics>(.horizontal, lineSpacing: 20,  widthFactor: 0.4, height: 220).then {
        $0.register(ComicCollectionViewCell.self)
        $0.configureCell = {
            $0.dequeueCell(ComicCollectionViewCell.self, at: $1, with: $2)
        }
        $0.contentInset.left = 15
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.didSelect = { [weak self] _, _, item in
            self?.navigate(to: .marvelCollection(item), transition: .push)
        }
    }
    
    override func render() {
        view.sv(backButton, marvelImageView.sv(favouriteIcon, marvelTitleLabel), marvelDescContainer.sv(marvelDescLabel, comicTitleLabel, comicCollectionView))
        view.layout(
            50,
            |-20-backButton,
            10,
            |-10-marvelImageView-10-|,
            10,
            |-10-marvelDescContainer-10-|,
            >=10
        )
        marvelImageView.heightEqualsWidth()
        marvelImageView.layout(
            20,
            |-20-favouriteIcon,
            >=10,
            |-20-marvelTitleLabel,
            60
        )
        marvelDescContainer.layout(
            20,
            |-20-marvelDescLabel-20-|,
            20,
            |-20-comicTitleLabel-20-|,
            10,
            |comicCollectionView| ~ 200,
            >=10
        )
        marvelDescContainer.Top == marvelImageView.Bottom - 40
    }
    
    override func setupUI() {
        viewModel.fetchAllComics().then { data in
            self.updateComicTable(data)
        }
    }
    
    func updateComicTable(_ comics: [Comics]) {
        self.comicCollectionView.updateItems(List.dataSource(sections: .empty, items: [comics]))
    }
}

class ComicCollectionViewCell: CollectionViewCell, Configurable {
    
    let comicImageView = UIImageView().then {
        $0.layer.cornerRadius = 30.0
        $0.clipsToBounds = true
    }
    
    let comicTitle = UILabel().then {
        $0.style("", font: .boldSystemFont(ofSize: 16), color: .white, isMultiline: true)
    }
    
    override func render() {
        sv(comicImageView, comicTitle)
        comicImageView.fillContainer()
        comicTitle.Bottom == comicImageView.Bottom - 20
        comicTitle.left(10)
    }
    
    func configure(_ item: Comics) {
        comicImageView.load(item.imageUrl)
        comicTitle.text = item.title
    }
}

//    lazy var marvelDetailTableView = TableView<String, MarvelCollectionType>().then {
//        $0.register(MarvelDetailTableViewCell.self)
//        $0.update(List.dataSource(sections: .empty, items: [viewModel.data]))
//        $0.headerHeight = { _ in 40 }
//        $0.separatorStyle = .none
//        $0.header = { _, _, item in
//            UILabel().then {
//                $0.text = item
//            }
//        }
//    }
//
//    override func render() {
//        view.sv(backButton, marvelDetailTableView)
//        //        backButton.left(20).top(20)
//        //        marvelDetailTableView.Top == backButton.Bottom + 10
//        view.layout(
//            50,
//            |-20-backButton,
//            10,
//            |-20-marvelDetailTableView-20-|,
//            20
//        )
//        align(lefts: backButton, marvelDetailTableView)
//        marvelDetailTableView.centerInContainer()
//    }
//
//    override func setupUI() {
//        viewModel.fetch()
//        viewModel.update = { [weak self] in
//            guard let `self` = self else { return }
//            self.marvelDetailTableView.update(List.dataSource(sections: .empty, items: [self.viewModel.data]))
//            print("From SetupUI: \(self.viewModel.data)")
//        }
//    }
//}
//
//class MarvelDetailTableViewCell: TableViewCell, Configurable {
//
//    let marvelTypeCollectionView = CollectionView<Any, MarvelCollectable>(.horizontal).then {
//        $0.register(MarvelTypeCollectionCell.self)
//        $0.configureCell = {
//            $0.dequeueCell(MarvelTypeCollectionCell.self, at: $1, with: $2)
//        }
//    }
//
//    let collectionImageView = UIImageView().then {
//        $0.width(50%).height(150)
//    }
//
//    let collectionNameLabel = UILabel().then {
//        $0.style("", font: .boldSystemFont(ofSize: 24), color: .white, isMultiline: true)
//    }
//
//    override func render() {
//        sv(collectionImageView.sv(collectionNameLabel))
//        collectionImageView.top(0).left(0).right(0).bottom(0)
//        collectionNameLabel.Top == collectionImageView.Bottom - 40
//        collectionNameLabel.left(20)
//    }
//
//    func configure(_ item: MarvelCollectionType) {
//        //        collectionImageView.load(item.items[0].thumbnail.imagePath + "." + item.items[0].thumbnail.imageExtension)
//        collectionImageView.backgroundColor = .red
//        collectionNameLabel.text(item.items[0].title)
//    }
//}
//
//class MarvelTypeCollectionCell: CollectionViewCell, Configurable {
//
//    let imageView = UIImageView().then {
//        $0.contentMode = .scaleAspectFill
//        $0.size(200)
//    }
//
//    let titleLabel = UILabel()
//
//    override func render() {
//        sv(imageView, titleLabel)
//    }
//
//    func configure(_ item: MarvelCollectable) {
//        imageView.load(item.thumbnail.imagePath + "." + item.thumbnail.imageExtension)
//        titleLabel.text = item.title
//    }
//}
//
