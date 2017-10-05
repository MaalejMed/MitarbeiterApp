//
//  FeedService.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//
import Foundation
import Alamofire

class FeedService {
    static let basicStringURL = "http://localhost:8080/Feed?"
    
    static func fetch(completion: @escaping ((Any?)->())) {
        Alamofire.request(basicStringURL).responseJSON(completionHandler: { response in
            //TODO: To be removed, just to simulate connection time
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                completion(response.result.value)
            })
        })
    }
}
