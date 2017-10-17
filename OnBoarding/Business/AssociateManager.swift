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
            guard response != nil else {
                let failure = Failure(code: .networkConnection, description: "Could not connect to the server")
                completion(failure, nil)
                return
            }
            guard let payload = response as? [String: Any] else {
                let failure = Failure(code: .wrongCredentials, description: "Wrong credentials")
                completion(failure, nil)
                return
            }
            guard let associate = Associate(json: payload) else {
                let failure = Failure(code: .parsingIssue, description: "Data could not be parsed")
                completion(failure, nil)
                return
            }
            return completion(nil, associate)
        })
    }
    
    //MARK:- Update photo
    func updatePhoto(dic: [String: Any], completion: @escaping ((Failure?)->()) ) {
        AssociateService.update(dic: dic, completion: { response in
            guard response != nil else {
                let failure = Failure(code: .networkConnection, description: "Could not connect to the server")
                completion(failure)
                return
            }
            
            guard let res = response as? String, res == HTTPResponse.ok.rawValue else {
                let failure = Failure(code: .parsingIssue, description: "Could not change profile image")
                completion(failure)
                return
            }
            completion(nil)
        })
    }
}
