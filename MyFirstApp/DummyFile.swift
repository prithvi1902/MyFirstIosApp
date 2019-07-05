////
////  DummyFile.swift
////  MyFirstApp
////
////  Created by Prithvi on 05/07/19.
////  Copyright © 2019 Prithvi. All rights reserved.
////
//import UIKit
//
//protocol HomeItems {
//    var value: String { get }
//}
//
//extension HomeItems where Self: RawRepresentable, Self.RawValue == String {
//    var value: String {
//        return rawValue.capitalized
//    }
//}
//
//enum HomeSections: String, CaseIterable {
//    case a = "Alphabet A", b = "Alphabet B"
//
//    enum ItemA: String, HomeItem, CaseIterable {
//        case adam, aaron, astor
//    }
//
//    enum ItemB: String, HomeItem, CaseIterable {
//        case bronn, beyonce, brian
//    }
//
//    var items: [HomeItem] {
//        switch self {
//        case .a:
//            return ItemA.allCases
//        case .b:
//            return ItemB.allCases
//        }
//    }
//}
//
//struct HomeDataSources {
//    let dataSource: (sections: [HomeSection], items: [[HomeItem]]) = {
//        let sections = HomeSection.allCases
//        let items = sections.map { $0.items }
//        return (sections, items)
//    }()
//}
//
//class HomeControllers: ViewController {
//
//    lazy var tableView = TableView<HomeSection,HomeItem>().then {
//        $0.register(HomeTableCell.self)
//        $0.headerHeight = { _ in 40 }
//        $0.header = { table, section, item in
//            UIButton().then {
//                $0.backgroundColor = .lightMaroon
//                let label = UILabel().then {
//                    $0.style(item.rawValue)
//                }
//                $0.sv(label)
//                label.left(16).top(0).right(16).bottom(0)
//                $0.onTap { _ in
//                    table.toggle(section)
//                }
//            }
//        }
//        $0.configureCell = { table, index, item in
//            table.dequeueCell(HomeTableCell.self, at: index, with: item)
//        }
//        $0.didSelect = { [weak self] _, _, item in
//            self?.navigate(to: .login, transition: .push)
//        }
//        let data = HomeDataSource().dataSource
//        $0.update(List.dataSource(sections: data.sections, items: data.items))
//    }
//
//    let titleLabel = UILabel().then{
//        $0.text("This is the home screen")
//        $0.textColor = .black
//        $0.font = UIFont.boldSystemFont(ofSize: 24)
//    }
//
//    override func render() {
//        let imageView = UIImageView().then {
//            $0.image("rose")
//            $0.contentMode = .scaleAspectFill
//        }
//        view.backgroundColor = .white
//        view.sv(tableView, imageView)
//        tableView.top(44).left(0).right(0).bottom(0)
//        imageView.circle(200).centerInContainer()
//    }
//}
//
//class HomeTableCells: TableViewCell, Configurable {
//
//    func configure(_ item: HomeItem) {
//        textLabel?.text = item.value
//    }
//}
//
//
//
//
////            let willTransform = (self?.circle.transform.isIdentity).value
////            self?.circle.alpha = willTransform ? 0.5 : 1
////            UIView.animate(withDuration: 0.5, animations: {
////                button.transform = willTransform ? CGAffineTransform(rotationAngle: .pi) : .identity
////                self?.circle.transform =  willTransform ? CGAffineTransform(scaleX: 40, y: 40) : .identity
////                self?.circle.alpha = willTransform ? 1 : 0.5
////            })
////        view.sv(circle, button)
////circle.circle(300).centerInContainer()
////button.circle(44).centerInContainer()
//
////    let circle = UIView().then { $0.backgroundColor = .red; $0.alpha = 0.5
