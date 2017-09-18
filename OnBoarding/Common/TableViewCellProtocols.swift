//
//  TableViewCellProtocols.swift
//  OnBoarding
//
//  Created by mmaalej on 15/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

protocol TableViewCellProtocols {
    static var cellIdentifier: String {get}
    static var staticMetrics: CellMetrics {get}
    var metrics: CellMetrics {get}
    var cellView: TVCellViewProtocol{get}
}

extension TableViewCellProtocols where Self: UITableViewCell {
    static var cellIdentifier: String {
        return NSStringFromClass(self)
    }
    
    var metrics: CellMetrics {
        return Self.staticMetrics
    }
}

protocol TVCellViewProtocol {
    var view: UIView {get}
    static var dummy: TVCellViewProtocol {get}
}

extension TVCellViewProtocol where Self: UIView {
    var view: UIView {
        return self
    }
}
