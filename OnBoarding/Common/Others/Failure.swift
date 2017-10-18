//
//  Error.swift
//  OnBoarding
//
//  Created by mmaalej on 28/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

enum FailureCode: Int {
    case success = 200
    case unreachableServer = 404
    case unauthorizedUser = 401
    case badRequest = 400
    case unknown = -1
    
    static func parse(serverFailure: Int) -> Failure {
        switch serverFailure {
        case 404:
            return Failure(code: .unreachableServer, description: "Could not connect to the server")
        case 401:
            return Failure(code: .unauthorizedUser, description: "User does not exist")
        case 400:
            return Failure(code: .badRequest, description: "Data could not be parsed")
        default:
            return Failure(code: .unknown, description: "Unkown server response")
        }
    }
}

struct Failure {
    
    //MARK:- Properties
    let code: FailureCode
    let description: String
}
