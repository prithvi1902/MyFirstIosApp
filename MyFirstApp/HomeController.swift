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
                Flower(name: "Succulants", isFavourite: true, imageName: "succulant"),
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
            $0.contentMode = .scaleAspectFit
        }
        let title = UILabel().then{
            $0.style("Flower School", font: UIFont.boldSystemFont(ofSize: 36.0), color: .white, bgColor: .clear, alignment: NSTextAlignment.left)
            $0.height(100)
        }
        let searchTextField = UITextField().then {
            $0.style(UIFont.systemFont(ofSize: 16), color: .white, bgColor: .lightGreen, alignment: NSTextAlignment.left, placeHolder: "Search")
            $0.setLeftPadding(16)
        }
        imageView.sv(title, searchTextField, tableView)
        title.top(200).left(20)
        searchTextField.Top == title.Bottom + 10
        searchTextField.height(100).left(0).right(20).roundedEdges(30)
        tableView.Top == searchTextField.Bottom + 20
        tableView.right(0).bottom(0)
        align(lefts: title, searchTextField, tableView)
        view.sv(imageView)
        imageView.top(0).left(10).right(10).height(500)
        view.backgroundColor = .white
//        imageView.layout(
//            100,
//            title,
//            50,
//            searchTextField,
//            50,
//            tableView
//        )
//        align(lefts: title, searchTextField, tableView)
    }
}

class HomeTableCell: TableViewCell, Configurable {
    let backgroundImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    let title = UILabel()
    let favouriteIcon = UIImageView().then{
        $0.contentMode = .scaleAspectFit
        $0.height(20).width(20)
    }
    
    override func render() {
        let mView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200)).then {
            $0.backgroundColor = .cardBg
        }
        mView.sv(favouriteIcon, title, backgroundImage)
        favouriteIcon.top(20).left(20)
        title.left(20).bottom(20)
        backgroundImage.right(0).bottom(0)
        //        self.layout(
        //            10,
        //            favouriteImage-10-|,
        //            30,
        //            title-20-|,
        //            10
        //        )
        //        align(lefts: favouriteImage, title)
 
//        mView.sv(backgroundImage)
//        backgroundImage.height(200).width(300).top(0).left(10).bottom(20).right(0)
        sv(mView)
    }
    
    func configure(_ item: Flower) {
        backgroundImage.image(item.imageName)
        title.text = item.name
        if(item.isFavourite){
            favouriteIcon.image("favourite")
            favouriteIcon.tintColor = .red
        }else{
            favouriteIcon.image("unfavourite")
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


