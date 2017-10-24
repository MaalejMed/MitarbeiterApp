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
    
    //MARK:-
    static func fetch(associateID: String, completion: @escaping ((DataResponse<Any>)->())) {
        let stringURL = basicStringURL + "/Message?associateID="+associateID
        Alamofire.request(stringURL).responseJSON(completionHandler: { response in
            //TODO: To be removed, just to simulate connection time
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                completion(response)
            })
        })
    }
}
