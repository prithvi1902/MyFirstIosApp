//
//  MarvelCollectionController.swift
//  MyFirstApp
//
//  Created by developer on 14/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import UIKit
import Stevia

class MarvelCollectionController: ViewController {
    
    var collectionData: MarvelCollectable
    
    init(_ collectionData: MarvelCollectable) {
        self.collectionData = collectionData
        print("Comic: \(collectionData)")
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
    
    lazy var marvelCollectionView = CollectionView<Any, Image>(.horizontal, widthFactor: 1.0, height: 300).then {
        $0.register(MarvelCollectionCell.self)
        $0.configureCell = {
            $0.dequeueCell(MarvelCollectionCell.self, at: $1, with: $2)
        }
        $0.didScrollToIndex = { [weak self] in self?.pageIndicators.currentPage = $0.row }
        $0.updateItems(List.dataSource(sections: .empty, items: [collectionData.images]))
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    let comicDescContainer = UIView().then {
        $0.layer.cornerRadius = 20.0
        $0.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }
    
    lazy var comicTitleLabel = UILabel().then {
        $0.style(collectionData.title, font: .boldSystemFont(ofSize: 24), isMultiline: true)
    }
    
    lazy var comicDescriptionLabel = UILabel().then {
        $0.style(collectionData.comic?.desc, isMultiline: true)
        $0.textAlignment = .justified
    }
    
    lazy var pageIndicators = UIPageControl().then {
        $0.numberOfPages = self.collectionData.images.count
        $0.pageIndicatorTintColor = .lightGray
        $0.currentPageIndicatorTintColor = .white
        $0.hidesForSinglePage = true
    }
    
    override func render() {
        view.sv(backButton, marvelCollectionView, pageIndicators, comicDescContainer.sv(comicTitleLabel, comicDescriptionLabel))
        view.layout(
            50,
            |-20-backButton.size(30),
            20,
            |-10-marvelCollectionView-10-|,
            10,
            |-10-comicDescContainer-10-|,
            10
        )
        comicDescContainer.layout(
            20,
            |-20-comicTitleLabel-20-|,
            20,
            |-20-comicDescriptionLabel-20-|,
            >=10
        )
        marvelCollectionView.height(300)
        pageIndicators.Bottom == marvelCollectionView.Bottom - 10
        pageIndicators.centerHorizontally()
    }
}

class MarvelCollectionCell: CollectionViewCell, Configurable {
    
    let collectionImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20.0
        $0.clipsToBounds = true
    }
    
    override func render() {
        sv(collectionImageView)
        collectionImageView.fillContainer().top(0).right(0).bottom(0).left(0)
    }
    
    func configure(_ item: Image) {
        collectionImageView.load(item.imageUrl)
    }
}

