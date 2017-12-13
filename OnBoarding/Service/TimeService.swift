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
    
    static let basicStringURL = "http://localhost:8080"
    
    //MARK:-
    static func submitTimesheet(dic: [String: Any], completion: @escaping ((DataResponse<String>)->())) {
        let stringURL = basicStringURL + "/SubmitTimesheet"
        Alamofire.request(stringURL, method: .post, parameters: dic, encoding: JSONEncoding.default).responseString(completionHandler: { response in
            completion(response)
        })
    }
    
    //MARK:-
    static func lastSubmittedDay(associateID: String, completion: @escaping ((DataResponse<String>)->())) {
        let stringURL = basicStringURL+"/LastSubmittedDay?associateID="+associateID
        Alamofire.request(stringURL).responseString(completionHandler: { response in
                completion(response)
        })
    }
}
