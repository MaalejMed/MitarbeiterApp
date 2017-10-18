//
//  AssociateManager.swift
//  OnBoarding
//
//  Created by mmaalej on 28/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class AssociateManager {
    
    //MARK:- Login
    func login(username: String, password: String, completion: @escaping ((ServerResponse?, Associate?)->())) {
        AssociateService.login(username: username, password: password, completion: { response in
            guard let result = response else {
                let failure = ServerResponse(code: .unreachableServer, description: "Could not connect to the server")
                completion(failure, nil)
                return
            }
  
            guard let payload = result as? [String: Any] else {
                guard let serverStatus = result as? Int else {
                    let failure = ServerResponse(code: .unknown, description: "Unknown server failure")
                    completion(failure, nil)
                    return
                }
                let failure = ServerStatus.parse(status: serverStatus)
                completion(failure, nil)
                return
            }
            
            guard let associate = Associate(json: payload) else {
                let failure = ServerResponse(code: .badRequest, description: "Data could not be parsed")
                completion(failure, nil)
                return
            }
            return completion(nil, associate)
        })
    }
    
    //MARK:- Update photo
    func updatePhoto(dic: [String: Any], completion: @escaping ((ServerResponse?)->()) ) {
        AssociateService.changeProfilePhoto(dic: dic, completion: { response in
            guard response != nil else {
                let failure = ServerResponse(code: .unreachableServer, description: "Could not connect to the server")
                completion(failure)
                return
            }
            
            guard let serverStatus = response as? Int else {
                let failure = ServerResponse(code: .unknown, description: "Unknown server failure")
                completion(failure)
                return
            }
            let serverResponse = ServerStatus.parse(status: serverStatus)
            completion(serverResponse)
            return
        })
    }
}
