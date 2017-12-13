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
    let status: ServerStatus
    var description: String = ""
    
    init(serverStatus: String) {
        status = ServerStatus.getStatusFrom(code: Int(serverStatus)!)
        description = descriptionFor(Status: status)
    }
    
    init(serverStatus: ServerStatus) {
        status = serverStatus
        description = descriptionFor(Status: status)
    }
    
    private func descriptionFor(Status: ServerStatus) -> String {
        switch status {
        case .success:
            return "Done !"
        case .badRequest:
            return "Data could not be parsed"
        case .unauthorizedAccess:
            return "Unauthorized access"
        case .notFound:
            return "No Data found"
        case .serviceUnavailable:
            return "Could not connect to the server"
        case .unknown:
            return "Unkown server response"
        }
    }
}

enum ServerStatus: Int {
    case success = 200
    case notFound = 404
    case unauthorizedAccess = 401
    case badRequest = 400
    case serviceUnavailable = 503
    case unknown = -1
    
    static func getStatusFrom(code: Int) ->ServerStatus {
        switch code {
        case 200:
            return .success
        case 400:
            return .badRequest
        case 401:
            return .unauthorizedAccess
        case 404:
            return .notFound
        case 503:
            return .serviceUnavailable
        default:
            return .unknown
        }
    }
}
