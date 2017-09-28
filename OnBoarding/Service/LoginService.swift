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
    
    static func login(username: String, password: String, completion: @escaping ((Bool)->())) {
        let stringURL = basicStringURL+"username="+username+"&password="+password
        Alamofire.request(stringURL).responseJSON(completionHandler: { response in
            let responseValue = parseResult(responseValue: response.result.value)
            completion(responseValue)
        })
    }
    
    static func parseResult(responseValue: Any?) -> Bool {
        guard let value = responseValue as? Bool else {
            return false
        }
        
        return value
    }
}
