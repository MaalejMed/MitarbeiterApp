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
    
    static let basicStringURL = "http://localhost:7111"
    
    //MARK:-
    static func submit(dic: [String: Any], completion: @escaping ((DataResponse<String>)->())) {
        let stringURL = basicStringURL + "/submit"
        Alamofire.request(stringURL, method: .post, parameters: dic, encoding: JSONEncoding.default).responseString(completionHandler: { response in
            completion(response)
        })
    }
    
    //MARK:-
    static func fetchLastDay(associateID: String, completion: @escaping ((DataResponse<String>)->())) {
        let stringURL = basicStringURL+"/lastDay?associateID="+associateID
        Alamofire.request(stringURL).responseString(completionHandler: { response in
                completion(response)
        })
    }
}
