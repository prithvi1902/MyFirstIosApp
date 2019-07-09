////
////  HomeController.swift
////  MyFirstApp
////
////  Created by Prithvi on 04/07/19.
////  Copyright © 2019 Prithvi. All rights reserved.
////
import UIKit
import Stevia

enum HomeSection: String, CaseIterable {
    case a = "Hollywood", b = "Bollywood"
    
    var items: [Flower] {
        switch self {
        case .a:
            return [
                Flower(name: "Montsera", isFavourite: false, imageName: "monstera"),
                Flower(name: "Succulants", isFavourite: true, imageName: "succulent"),
                Flower(name: "Ferns", isFavourite: false, imageName: "fern"),
                Flower(name: "Rose", isFavourite: false, imageName: "rose")
            ]
        case .b:
            return [
            Flower(name: "A", isFavourite: false, imageName: "rose")
            ]
        }
    }
}

struct HomeDataSource {
    let dataSource: (sections: [HomeSection], items: [[Flower]]) = {
        let sections = HomeSection.allCases
        let items = sections.map { $0.items }
        return (sections, items)
    }()
}

class HomeController: ViewController {
    
    lazy var tableView = TableView<HomeSection, Flower>().then {
        $0.register(HomeTableCell.self)
        $0.configureCell = { table, index, item in
            table.dequeueCell(HomeTableCell.self, at: index, with: item)
        }
        $0.didSelect = { [weak self] _, _, item in
            self?.navigate(to: .movieDetails, transition: .push)
        }
        let data = HomeDataSource().dataSource
        $0.update(List.dataSource(sections: data.sections, items: data.items))
    }

    override func render() {
        let imageView = UIImageView().then {
            $0.image("leaves")
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 40.0
            $0.clipsToBounds = true
        }
        let title = UILabel().then{
            $0.style("Flower School", font: UIFont.boldSystemFont(ofSize: 36.0), color: .white, bgColor: .clear, alignment: NSTextAlignment.left)
            $0.height(100)
        }
        let searchTextField = UITextField().then {
            $0.style(UIFont.systemFont(ofSize: 16), color: .white, bgColor: .lightGreen, alignment: NSTextAlignment.left, placeHolder: "Search")
            $0.setLeftPadding(16)
        }
        imageView.sv(title, searchTextField)
        title.top(100).left(20)
        searchTextField.Top == title.Bottom + 10
        searchTextField.height(50).left(0).right(20).roundedEdges(50)
        align(lefts: title, searchTextField)
        view.sv(imageView, tableView)
        imageView.top(100).left(10).right(10).height(400)
//        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.Top == imageView.Bottom - 100
        tableView.right(10).bottom(0).left(30)
        view.backgroundColor = .white
    }
}

class HomeTableCell: TableViewCell, Configurable {
    let backgroundImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    let title = UILabel()
    let favouriteIcon = UIButton().then{
        $0.contentMode = .scaleAspectFit
        $0.height(30).width(30)
        $0.setImage(UIImage(named: "unfavorite"), for: UIControl.State.normal)
    }
    
    override func render() {
        let mView = UIView().then {
            $0.backgroundColor = .cardBg
            $0.height(200)
            $0.layer.cornerRadius = 25
            $0.clipsToBounds = true
            $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        }
        mView.sv(favouriteIcon, title, backgroundImage)
        favouriteIcon.top(20).left(20)
        title.left(20).bottom(20)
        backgroundImage.top(0).right(0).bottom(0).height(200).width(50%)
        sv(mView)
        mView.fillContainer()
        mView.top(20)
    }
    
    func configure(_ item: Flower) {
        backgroundImage.image(item.imageName)
        title.text = item.name
//        favouriteIcon.image = UIImage(named: "Favorite")?.withRenderingMode(.alwaysTemplate)
        if(item.isFavourite){
            favouriteIcon.setImage(UIImage(named: "favorite"), for: UIControl.State.normal)
            favouriteIcon.tintColor = .red
        }else{
            favouriteIcon.setImage(UIImage(named: "unfavorite"), for: UIControl.State.focused)
        }
    }
}

class MovieDetails: ViewController{
    override func render() {
        let imageView = UIImageView().then{
            $0.image("rose")
        }
        view.sv(imageView)
        imageView.top(80).centerHorizontally()
        imageView.contentMode = .scaleAspectFit
    }
}


