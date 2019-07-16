//
//  MarvelController.swift
//  MyFirstApp
//
//  Created by Prithvi on 11/07/19.
//  Copyright © 2019 Prithvi. All rights reserved.
//

import UIKit
import Stevia

class MarvelController: ViewController {
    
    let marvelViewModel = MarvelCharacterViewModel()
    
    let mainImageView = UIImageView().then {
        $0.image("mainImage")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 40.0
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
    }
    
    lazy var searchTextField = UITextField().then {
        $0.delegate = self
        $0.style(UIFont.systemFont(ofSize: 16), color: .black, bgColor: .white, alignment: NSTextAlignment.left, placeHolder: "Search")
        $0.setLeftPadding(16)
        $0.placeholderColor(#colorLiteral(red: 0.6251443624, green: 0.7063648105, blue: 0.6984998584, alpha: 1))
        $0.on(.editingChanged) { textField in
            self.marvelViewModel.query(textField.text!)
            if(self.marvelViewModel.filteredData.count == 0 && self.searchTextField.text?.count == 0){
                self.tableView.update(List.dataSource(sections: .empty, items: [self.marvelViewModel.data]))
            } else {
                self.tableView.update(List.dataSource(sections: .empty, items: [self.marvelViewModel.filteredData]))
            }
        }
    }
    
    lazy var tableView = TableView<Any, MarvelCharacter>().then {
        $0.register(MarvelCharacterCollectionCell.self)
        $0.configureCell = { table, index, item in
            table.dequeueCell(MarvelCharacterCollectionCell.self, at: index, with: item)
        }
        $0.didSelect = { [weak self] _, _, item in
            self?.searchTextField.text = ""
            self?.navigate(to: .marvelDetails(item), transition: .push)
        }
        $0.separatorStyle = .none
    }
    
    let activityIndicator = UIActivityIndicatorView().then{
        $0.color = .black
        $0.hidesWhenStopped = true
    }
    
    override func render() {
        view.sv(mainImageView.sv(searchTextField), tableView, activityIndicator)
        view.backgroundColor = .white
        searchTextField.Top == mainImageView.Bottom - 120
        searchTextField.height(50).width(300).centerHorizontally().roundedEdges(50)
        align(lefts: searchTextField)
        mainImageView.top(100).left(10).right(10).height(400)
        tableView.Top == mainImageView.Bottom - 50
        tableView.right(20).bottom(0).left(20).centerHorizontally()
        activityIndicator.size(30).centerInContainer()
    }
    
    override func configureUI() {
        tableView.update(List.dataSource(sections: .empty, items: [marvelViewModel.data]))
    }
    
    override func setupUI() {
        self.activityIndicator.startAnimating()
        marvelViewModel.fetchAllCharacters().then { data in
            self.activityIndicator.stopAnimating()
            self.marvelViewModel.data = data
            self.updateCollection(data)
        }
    }
    
    func updateCollection(_ items: [MarvelCharacter]) {
        tableView.update(List.dataSource(sections: .empty, items: [marvelViewModel.data]))
    }
}

class MarvelCharacterCollectionCell: TableViewCell, Configurable {
    
    var marvelCharacter: MarvelCharacter!
    
    let backgroundImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = true
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
    }
    
    let nameLabel = UILabel().then {
        $0.style("", font: .boldSystemFont(ofSize: 24), color: .black)
    }
    
    lazy var favouriteIcon = UIButton().then{
        $0.contentMode = .scaleAspectFit
        $0.onTap { [weak self] in
            self?.marvelCharacter?.isFavourite.toggle()
            guard let marvelCharacter = self?.marvelCharacter else { return }
            $0.image(marvelCharacter.favImage, tint: marvelCharacter.favTint)
        }
    }
    
    override func render() {
        sv(backgroundImage.sv(favouriteIcon, nameLabel))
        backgroundImage.left(0).right(0).top(0).bottom(20).height(200)
        favouriteIcon.top(20).left(20).size(30)
        nameLabel.left(20).bottom(20)
    }
    
    func configure(_ item: MarvelCharacter) {
        marvelCharacter = item
        backgroundImage.load(item.thumbnail)
        nameLabel.text = item.name
        favouriteIcon.image(item.favImage, tint: item.favTint)
    }
}

extension MarvelController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
