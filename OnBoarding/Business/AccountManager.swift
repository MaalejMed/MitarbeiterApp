//
//  AccountManager.swift
//  OnBoarding
//
//  Created by mmaalej on 28/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class AccountManager {
    
    func login(username: String, password: String, completion: @escaping ((Failure?)->())) {
        LoginService.login(username: username, password: password, completion: { response in
            guard let value = response as? Bool else {
                let failure = Failure(code: .networkConnection, description: "Could not connect to the server")
                completion(failure)
                return
            }
            
            guard value == true else {
                let failure = Failure(code: .wrongCredentials, description: "Wrong credentials")
                completion(failure)
                return
            }
            
            return completion(nil)
        })
    }
}
