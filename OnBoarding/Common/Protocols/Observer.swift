//
//  Observer.swift
//  OnBoarding
//
//  Created by mmaalej on 02/11/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

protocol Observer {
    var identifier: Int {get}
    func update()
}
