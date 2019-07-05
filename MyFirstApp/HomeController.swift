////
////  HomeController.swift
////  MyFirstApp
////
////  Created by Prithvi on 04/07/19.
////  Copyright © 2019 Prithvi. All rights reserved.
////
import UIKit
import Stevia

//protocol HomeItem {
//    var value: Movie { get }
//}
//
//extension HomeItem where Self: RawRepresentable, Self.RawValue == Movie {
//    var value: Movie {
//        return rawValue
//    }
//}

enum HomeSection: String, CaseIterable {
    case a = "Hollywood", b = "Bollywood"

//    enum ItemA: String, HomeItem, CaseIterable {
//        case adam, aaron, astor
//    }
//
//    enum ItemB: String, HomeItem, CaseIterable {
//        case bronn, beyonce, brian
//    }
    
    var items: [Movie] {
        switch self {
        case .a:
            return [
                Movie(title: "Anabelle", subTitle: "Comes home", rating: "4.0", image: "rose", description: "Horror and a thriller movie, released in 2019"),
                Movie(title: "Anabelle", subTitle: "Comes home", rating: "4.0", image: "rose", description: "Horror and a thriller movie, released in 2019"),
                Movie(title: "Anabelle", subTitle: "Comes home", rating: "4.0", image: "rose", description: "Horror and a thriller movie, released in 2019")
            ]
        case .b:
            return [
                Movie(title: "Anabelle", subTitle: "Comes home", rating: "4.0", image: "rose", description: "Horror and a thriller movie, released in 2019"),
                Movie(title: "Anabelle", subTitle: "Comes home", rating: "4.0", image: "rose", description: "Horror and a thriller movie, released in 2019"),
                Movie(title: "Anabelle", subTitle: "Comes home", rating: "4.0", image: "rose", description: "Horror and a thriller movie, released in 2019")
            ]
        }
    }
}

struct HomeDataSource {
    let dataSource: (sections: [HomeSection], items: [[Movie]]) = {
        let sections = HomeSection.allCases
        let items = sections.map { $0.items }
        return (sections, items)
    }()
}

class HomeController: ViewController {

    lazy var tableView = TableView<HomeSection, Movie>().then {
        $0.register(HomeTableCell.self)
        $0.headerHeight = { _ in 40 }
        $0.header = { table, section, item in
            UIButton().then {
                $0.backgroundColor = .lightMaroon
                let label = UILabel().then {
                    $0.style(item.rawValue)
                }
                $0.sv(label)
                label.left(16).top(0).right(16).bottom(0)
                $0.onTap { _ in
                    table.toggle(section)
                }
            }
        }
        $0.configureCell = { table, index, item in
            table.dequeueCell(HomeTableCell.self, at: index, with: item)
        }
        $0.didSelect = { [weak self] _, _, item in
            self?.navigate(to: .movieDetails, transition: .push)
        }
        let data = HomeDataSource().dataSource
        $0.update(List.dataSource(sections: data.sections, items: data.items))
    }

    let titleLabel = UILabel().then{
        $0.text("This is the home screen")
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 24)
    }

    override func render() {
        let imageView = UIImageView().then {
            $0.image("rose")
            $0.contentMode = .scaleAspectFill
        }
        view.backgroundColor = .white
        view.sv(tableView)
        tableView.top(44).left(0).right(0).bottom(0)
        imageView.circle(200).centerInContainer()
    }
}

class HomeTableCell: TableViewCell, Configurable {

    let avatar = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    let title = UILabel()
    let subTitle = UILabel()
    let rating = UILabel()
    
    override func render() {
        sv(avatar, title, subTitle, rating)
        avatar.circle(50).top(10).left(10).bottom(10)
        self.layout(
            10,
            title-10-|,
            10,
            subTitle-20-|,
            10
        )
        title.Left == avatar.Right + 20
        align(lefts: title, subTitle)
        rating.Left == subTitle.Right
        rating.width(100).right(10).bottom(10)
    }
    
    func configure(_ item: Movie) {
        avatar.image(item.image)
        title.text = item.title
        subTitle.text = item.subTitle
        rating.text = item.rating
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


