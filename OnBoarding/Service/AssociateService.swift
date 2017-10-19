//
//  AssociateService.swift
//  OnBoarding
//
//  Created by mmaalej on 28/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation
import Alamofire

class AssociateService {
    
    //MARK:- Properties
    static let basicStringURL = "http://localhost:8080"
    
    //MARK:-
    static func login(username: String, password: String, completion: @escaping ((Any?)->())) {
        let stringURL = basicStringURL+"/Login?username="+username+"&password="+password
        Alamofire.request(stringURL).responseJSON(completionHandler: { response in
                completion(response.result.value)
        })
    }
    
    //MARK:-
    static func changeProfilePhoto(dic: [String: Any], completion: @escaping ((String?)->())) {
        let stringURL = basicStringURL+"/ProfilePhoto"
        Alamofire.request(stringURL, method: .post, parameters: dic, encoding: JSONEncoding.default).responseString(completionHandler: { response in
            completion(response.result.value)
        })
    }
}
