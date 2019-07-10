////
////  HomeController.swift
////  MyFirstApp
////
////  Created by Prithvi on 04/07/19.
////  Copyright © 2019 Prithvi. All rights reserved.
////
import UIKit
import Stevia

class HomeViewModel {
    let data = [
        Flower(name: "Montsera", imageName: "monstera"),
        Flower(name: "Succulants", imageName: "succulent"),
        Flower(name: "Ferns", imageName: "fern")
    ]
    
    var filteredData = [Flower]()
    
    func query(_ text: String)  {
        filteredData = data.filter { $0.name.localizedCaseInsensitiveContains(text) }
    }
}

class HomeController: ViewController {
    
    let viewModel = HomeViewModel()
    
    let imageView = UIImageView().then {
        $0.image("leaves")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 40.0
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
    }
    
    let titleLabel = UILabel().then{
        $0.style("Flower\nSchool", font: UIFont.boldSystemFont(ofSize: 36.0), color: .white, isMultiline: true)
    }
    
    lazy var searchTextField = UITextField().then {
        $0.delegate = self
        $0.style(UIFont.systemFont(ofSize: 16), color: .white, bgColor: .lightGreen, alignment: NSTextAlignment.left, placeHolder: "Search")
        $0.setLeftPadding(16)
        $0.placeholderColor(#colorLiteral(red: 0.6251443624, green: 0.7063648105, blue: 0.6984998584, alpha: 1))
        $0.on(.editingChanged) { textField in
            self.viewModel.query(textField.text!)
            self.tableView.update(List.dataSource(sections: .empty, items: self.viewModel.filteredData.count == 0 ? [self.viewModel.data] : [self.viewModel.filteredData]))
            //            if(self.viewModel.filteredData.count == 0){
            //                self.noDataImageView.isHidden = false
            //                self.tableView.isHidden = true
            //            } else {
            //                self.noDataImageView.isHidden = true
            ////                self.tableView.isHidden = false
            //                self.tableView.update(List.dataSource(sections: .empty, items: [self.viewModel.filteredData]))
            //            }
        }
    }
    
    lazy var tableView = TableView<Any, Flower>().then {
        $0.separatorStyle = .none
        $0.register(HomeTableCell.self)
        $0.configureCell = { table, index, item in
            table.dequeueCell(HomeTableCell.self, at: index, with: item)
        }
        $0.didSelect = { [weak self] _, _, item in
            self?.searchTextField.text = ""
            self?.navigate(to: .flowerDetails(item), transition: .push)
        }
    }
    
    let noDataImageView = UIImageView().then {
        $0.image("noDataFound")
        $0.isHidden = true
    }
    
    override func render() {
        view.sv(imageView.sv(titleLabel, searchTextField), tableView, noDataImageView)
        view.backgroundColor = .white
        titleLabel.top(100).left(20)
        searchTextField.Top == titleLabel.Bottom + 10
        searchTextField.height(50).left(0).right(20).roundedEdges(50)
        align(lefts: titleLabel, searchTextField)
        imageView.top(100).left(10).right(10).height(400)
        tableView.Top == imageView.Bottom - 100
        tableView.right(10).bottom(0).left(30)
        noDataImageView.Top == imageView.Bottom
        noDataImageView.top(0).right(0).bottom(0).left(0).centerHorizontally().height(100).width(100)
    }
    
    override func configureUI() {
        tableView.update(List.dataSource(sections: .empty, items: [viewModel.data]))
    }
}

class HomeTableCell: TableViewCell, Configurable {
    
    var flower: Flower!
    
    let backgroundImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    let title = UILabel()
    
    lazy var favouriteIcon = UIButton().then{
        $0.contentMode = .scaleAspectFit
        $0.height(30).width(30)
        $0.onTap { [weak self] in
            self?.flower?.isFavourite.toggle()
            guard let flower = self?.flower else { return }
            $0.image(flower.favImage, tint: flower.favTint)
        }
    }
    
    let cardHolder = UIView().then {
        $0.backgroundColor = .cardBg
        $0.height(200)
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
    }
    
    override func render() {
        sv(cardHolder.sv(favouriteIcon, title, backgroundImage))
        cardHolder.left(0).right(0).top(0).bottom(20)
        favouriteIcon.top(20).left(20)
        title.left(20).bottom(20)
        backgroundImage.top(0).right(0).bottom(0).height(200).width(50%)
    }
    
    func configure(_ item: Flower) {
        flower = item
        backgroundImage.image(item.imageName)
        title.text = item.name
        favouriteIcon.image(item.favImage, tint: item.favTint)
    }
}

extension HomeController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



