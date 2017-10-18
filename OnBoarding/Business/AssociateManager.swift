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
    func login(username: String, password: String, completion: @escaping ((Failure?, Associate?)->())) {
        AssociateService.login(username: username, password: password, completion: { response in
            guard let result = response else {
                let failure = Failure(code: .unreachableServer, description: "Could not connect to the server")
                completion(failure, nil)
                return
            }
  
            guard let payload = result as? [String: Any] else {
                guard let serverFailure = result as? Int else {
                    let failure = Failure(code: .unknown, description: "Unknown server failure")
                    completion(failure, nil)
                    return
                }
                let failure = FailureCode.parse(serverFailure: serverFailure)
                completion(failure, nil)
                return
            }
            
            guard let associate = Associate(json: payload) else {
                let failure = Failure(code: .badRequest, description: "Data could not be parsed")
                completion(failure, nil)
                return
            }
            return completion(nil, associate)
        })
    }
    
    //MARK:- Update photo
    func updatePhoto(dic: [String: Any], completion: @escaping ((Failure?)->()) ) {
        AssociateService.changeProfilePhoto(dic: dic, completion: { response in
            guard response != nil else {
                let failure = Failure(code: .unreachableServer, description: "Could not connect to the server")
                completion(failure)
                return
            }
            
            guard let res = response as? String, res == HTTPResponse.ok.rawValue else {
                let failure = Failure(code: .badRequest, description: "Could not change profile image")
                completion(failure)
                return
            }
            completion(nil)
        })
    }
}
