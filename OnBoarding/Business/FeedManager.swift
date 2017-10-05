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
    func fetchFeed(completion: @escaping ((Failure?, [Feed]?)->())) {
        var feed: [Feed] = []
        FeedService.fetch(completion: { response in
            guard response != nil else {
                let failure = Failure(code: .networkConnection, description: "Could not connect to the server")
                completion(failure, nil)
                return
            }
            
            guard let payload = response as? [[String: Any]] else {
                let failure = Failure(code: .parsingIssue, description: "Result could not be parsed")
                completion(failure, nil)
                return
            }
            
            for jsonItem in payload {
                feed.append(Feed(json: jsonItem)!)
            }

            return completion(nil, feed)
        })
    }
}
