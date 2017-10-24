//
//  MessageService.swift
//  OnBoarding
//
//  Created by mmaalej on 24/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation
import Alamofire

class MessageService {
    
    static let basicStringURL = "http://localhost:8080"

    //MARK:-
    static func submitMessage(dic: [String: Any], completion: @escaping ((DataResponse<Any>)->())) {
        let stringURL = basicStringURL + "/SubmitMessage"
        Alamofire.request(stringURL, method: .post, parameters: dic, encoding: JSONEncoding.default).responseJSON(completionHandler: { response in
            completion(response)
        })
    }
}
