//
//  Error.swift
//  OnBoarding
//
//  Created by mmaalej on 28/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

enum ServerStatus: Int {
    case success = 200
    case unreachableServer = 404
    case unauthorizedAccess = 401
    case badRequest = 400
    case unknown = -1
    
    static func parse(status: Int) -> ServerResponse {
        switch status {
        case 200:
            return ServerResponse(code: .success, description: "Done !")
        case 404:
            return ServerResponse(code: .unreachableServer, description: "Could not connect to the server")
        case 401:
            return ServerResponse(code: .unauthorizedAccess, description: "Unauthorized access")
        case 404:
            return ServerResponse(code: .badRequest, description: "Data could not be parsed")
        default:
            return ServerResponse(code: .unknown, description: "Unkown server response")
        }
    }
}

struct ServerResponse {
    
    //MARK:- Properties
    let code: ServerStatus
    let description: String
}
