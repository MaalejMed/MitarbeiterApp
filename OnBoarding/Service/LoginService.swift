//
//  LoginService.swift
//  OnBoarding
//
//  Created by mmaalej on 28/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation
import Alamofire

class LoginService {
    static let basicStringURL = "http://localhost:8080/?"
    
    static func login(username: String, password: String, completion: @escaping ((Failure?)->())) {
        let stringURL = basicStringURL+"username="+username+"&password="+password
        Alamofire.request(stringURL).responseJSON(completionHandler: { response in
            let failure = parse(responseValue: response.result.value)
            completion(failure)
        })
    }
    
    static func parse(responseValue: Any?) -> Failure? {
        guard let value = responseValue as? Bool else {
            let failure = Failure(code: .networkConnection, description: "Could not connect to the server")
            return (failure)
        }
        
        guard value == true else {
            let failure = Failure(code: .wrongCredentials, description: "Wrong credentials")
            return (failure)
        }
        
        return nil
    }
}
