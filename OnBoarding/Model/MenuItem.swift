//
//  MenuItem.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

struct MenuItem {
    
    //MARK:- Properties
    var identifier: String
    var item: Item
    var description: String
    var icon: UIImage
    
    //MARK:- Init
    init(item: Item) {
        switch item {
        case .time:
            identifier = "01"
        case .travelExp:
            identifier = "02"
        case .benefits:
            identifier = "03"
        case .eLearning:
            identifier = "04"
        case .gsd:
            identifier = "05"
        case .profile:
            identifier = "06"
        }
        let itemIcon = item.icon()
        icon = itemIcon
        description = item.rawValue
        self.item = item
    }
}
