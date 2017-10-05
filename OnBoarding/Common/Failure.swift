//
//  Error.swift
//  OnBoarding
//
//  Created by mmaalej on 28/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

enum FailureCode: Int {
    case networkConnection = 1
    case wrongCredentials = 2
    case parsingIssue = 3
}

struct Failure {
    let code: FailureCode
    let description: String
}
