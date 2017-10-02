//
//  AuthenticationManager.swift
//  OnBoarding
//
//  Created by mmaalej on 28/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class AuthenticationManager {
    
    //MARK:- Login
    func login(username: String, password: String, completion: @escaping ((Failure?, Associate?)->())) {
        AuthenticationService.login(username: username, password: password, completion: { response in
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
            let associate = Associate(json: payload)
            return completion(nil, associate)
        })
    }
}
