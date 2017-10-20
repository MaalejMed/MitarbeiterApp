//
//  Error.swift
//  OnBoarding
//
//  Created by mmaalej on 28/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

struct ServerResponse {
    
    //MARK:- Properties
    let code: ServerStatus
    let description: String
}

enum ServerStatus: Int {
    case success = 200
    case notFound = 404
    case unauthorizedAccess = 401
    case badRequest = 400
    case serviceUnavailable = 503
    case unknown = -1
    
    static func parse(status: ServerStatus) -> ServerResponse {
        switch status {
        case .success:
            return ServerResponse(code: .success, description: "Done !")
        case .serviceUnavailable:
            return ServerResponse(code: .serviceUnavailable, description: "Could not connect to the server")
        case .unauthorizedAccess:
            return ServerResponse(code: .unauthorizedAccess, description: "Unauthorized access")
        case .notFound:
            return ServerResponse(code: .notFound, description: "No Data found")
        case .badRequest:
            return ServerResponse(code: .badRequest, description: "Data could not be parsed")
        default:
            return ServerResponse(code: .unknown, description: "Unkown server response")
        }
    }
}
