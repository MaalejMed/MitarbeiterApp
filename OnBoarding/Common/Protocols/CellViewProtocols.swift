//
//  CellViewProtocols.swift
//  OnBoarding
//
//  Created by mmaalej on 12/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

//MARK:- Properties
struct CellMetrics {
    
    //MARK:- Properties
    let topAnchor: CGFloat
    let leftAnchor: CGFloat
    let bottomAnchor: CGFloat
    let rightAnchor: CGFloat
}

//MARK: CollectionTableViewCell protocols
protocol CollectionViewCellProtocols: class {
    static var cellIdentifier: String {get}
    static var staticMetrics: CellMetrics {get}
    var metrics: CellMetrics {get}
    var cellView: CellViewProtocol {get}
}

extension CollectionViewCellProtocols where Self: UICollectionViewCell {
    static var cellIdentifier: String {
        return NSStringFromClass(self)
    }
    var metrics: CellMetrics {
        return Self.staticMetrics
    }
}

//MARK:- UITableViewCell protocols
protocol TableViewCellProtocols {
    static var cellIdentifier: String {get}
    static var staticMetrics: CellMetrics {get}
    var metrics: CellMetrics {get}
    var cellView: CellViewProtocol{get}
}

extension TableViewCellProtocols where Self: UITableViewCell {
    static var cellIdentifier: String {
        return NSStringFromClass(self)
    }
    
    var metrics: CellMetrics {
        return Self.staticMetrics
    }
}

//MARK:- Common protocols
protocol CellViewProtocol {
    var  view: UIView {get}
    static var dummy: CellViewProtocol {get}
}

extension CellViewProtocol where Self: UIView {
    var view: UIView {
        return self
    }
}

