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
    static let basicStringURL = "http://localhost:7111"
    
    //MARK:-
    static func fetchData(associateID: String, completion: @escaping ((DataResponse<Any>)->())) {
        let stringURL = basicStringURL+"/data?associateID="+associateID
        Alamofire.request(stringURL).responseJSON(completionHandler: { response in
                completion(response)
        })
    }
    
    //MARK:-
    static func updatePhoto(dic: [String: Any], completion: @escaping ((DataResponse<String>)->())) {
        let stringURL = basicStringURL+"/photo"
        Alamofire.request(stringURL, method: .post, parameters: dic, encoding: JSONEncoding.default).responseString(completionHandler: { response in
            completion(response)
        })
    }
}
