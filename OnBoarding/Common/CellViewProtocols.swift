//
//  CellViewProtocols.swift
//  OnBoarding
//
//  Created by mmaalej on 12/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

struct CellMetrics {
    let topAnchor: CGFloat
    let leftAnchor: CGFloat
    let bottomAnchor: CGFloat
    let rightAnchor: CGFloat
}

protocol CollectionViewCellProtocols: class {
    static var cellIdentifier: String {get}
    static var staticMetrics: CellMetrics {get}
    var metrics: CellMetrics {get}
    var cellView: cellViewProtocol {get}
}

extension CollectionViewCellProtocols where Self: UICollectionViewCell {
    static var cellIdentifier: String {
        return NSStringFromClass(self)
    }
    var metrics: CellMetrics {
        return Self.staticMetrics
    }
}

protocol cellViewProtocol {
    var  view: UIView {get}
    static var dummy: cellViewProtocol {get}
}

extension cellViewProtocol where Self: UIView {
    var view: UIView {
        return self
    }
}
