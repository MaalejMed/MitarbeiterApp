//
//  AuthenticationService.swift
//  OnBoarding
//
//  Created by mmaalej on 12/12/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation
import Alamofire

class AuthenticationService {
    
    //MARK:- Properties
    static let basicStringURL = "http://localhost:7111"
    
    //MARK:- Login
    static func login(username: String, password: String, completion: @escaping ((DataResponse<String>)->())) {
        let stringURL = basicStringURL+"/login?associateID="+username+"&password="+password
        Alamofire.request(stringURL).responseString(completionHandler: { response in
            completion(response)
        })
    }
}
