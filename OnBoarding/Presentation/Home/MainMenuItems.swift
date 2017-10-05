//
//  MainMenuItems.swift
//  OnBoarding
//
//  Created by mmaalej on 05/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

enum Item: String {
    case time = "Time"
    case gsd = "GSD"
    case travelExp = "Expenses"
    case profile = "Profile"
    case benefits = "benefits"
    case eLearning = "E-Learning"
    
    static let allMenuItems = [time, gsd, travelExp,profile, benefits, eLearning]
    
    func icon() -> UIImage {
        switch self {
        case .time:
            return UIImage.init(named: "Time")!
        case .travelExp:
            return UIImage.init(named: "Expenses")!
        case .benefits:
            return UIImage.init(named: "Benefits")!
        case .eLearning:
            return UIImage.init(named: "Elearning")!
        case .gsd:
            return UIImage.init(named: "Help")!
        case .profile:
            return UIImage.init(named: "Profile")!
        }
    }
}
