//
//  TimeService.swift
//  OnBoarding
//
//  Created by mmaalej on 05/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation
import Alamofire

class TimeService {
    static let basicStringURL = "http://localhost:8080/Time"
    
    static func submit(dic: [String: Any], completion: @escaping ((Any?)->())) {
        Alamofire.request(basicStringURL, method: .post, parameters: dic, encoding: JSONEncoding.default).responseString(completionHandler: { response in
            completion(response.result.value)
        })
    }
    
    static func lastSubmittedDay(associateID: String, completion: @escaping ((Any?)->())) {
        let stringURL = basicStringURL+"?associateID="+associateID
        Alamofire.request(stringURL).responseString(completionHandler: { response in
                completion(response.result.value)
        })
    }
}
