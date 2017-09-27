//
//  Message.swift
//  OnBoarding
//
//  Created by mmaalej on 26/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

struct Message {
    var identifier: String?
    var associateID: String?
    var title: String?
    var body: String?
    var response: [MessageResponse]?
    var date: Date
}
