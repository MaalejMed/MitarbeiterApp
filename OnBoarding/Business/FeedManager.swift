//
//  FeedManager.swift
//  OnBoarding
//
//  Created by mmaalej on 04/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation


class FeedManager {
    
    //MARK:- Feed
    func fetchFeed(completion: @escaping ((ServerResponse?, [Feed]?)->())) {
        var feed: [Feed] = []
        FeedService.fetch(completion: { response in
            guard response != nil else {
                let failure = ServerResponse(code: .unreachableServer, description: "Could not connect to the server")
                completion(failure, nil)
                return
            }
            
            guard let payload = response as? [[String: Any]] else {
                let failure = ServerResponse(code: .badRequest, description: "Data could not be parsed")
                completion(failure, nil)
                return
            }
            
            for jsonItem in payload {
                guard let aFeed = Feed(json: jsonItem) else {
                    continue
                }
                feed.append(aFeed)
            }
            
            guard feed.count > 0 else {
                let failure = ServerResponse(code: .badRequest, description: "Data could not be parsed")
                completion(failure, nil)
                return
            }

            return completion(nil, feed)
        })
    }
}
