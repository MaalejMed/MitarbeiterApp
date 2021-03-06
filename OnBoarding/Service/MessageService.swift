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
    
    static let basicStringURL = "http://localhost:7111"

    //MARK:- Message
    static func fetchMessages(associateID: String, completion: @escaping ((DataResponse<Any>)->())) {
        let stringURL = basicStringURL + "/Message?associateID="+associateID
        Alamofire.request(stringURL).responseJSON(completionHandler: { response in
            completion(response)
        })
    }
    
    static func sendMessage(dic: [String: Any], completion: @escaping ((DataResponse<String>)->())) {
        let stringURL = basicStringURL + "/SubmitMessage"
        Alamofire.request(stringURL, method: .post, parameters: dic, encoding: JSONEncoding.default).responseString(completionHandler: { response in
            completion(response)
        })
    }
    
    //MARK:- SubMessage
    static func fetchSubMessage(messageID: String, completion: @escaping ((DataResponse<Any>)->())) {
        let stringURL = basicStringURL + "/SubMessage?messageID="+messageID
        Alamofire.request(stringURL).responseJSON(completionHandler: { response in
            completion(response)
        })
    }
    
    static func submitSubMessage(dic: [String: Any], completion: @escaping ((DataResponse<String>)->())) {
        let stringURL = basicStringURL + "/SubmitSubMessage"
        Alamofire.request(stringURL, method: .post, parameters: dic, encoding: JSONEncoding.default).responseString(completionHandler: { response in
            completion(response)
        })
    }
}
