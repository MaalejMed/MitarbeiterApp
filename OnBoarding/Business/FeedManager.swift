//
//  FeedManager.swift
//  OnBoarding
//
//  Created by mmaalej on 04/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class FeedManager {
    
    //MARK:-
    func selectFeeds(completion: @escaping ((ServerResponse?, [Feed]?)->())) {
        var feed: [Feed] = []
        FeedService.fetch(completion: { response in
            guard response != nil else {
                let failure = ServerStatus.parse(status: .serviceUnavailable)
                completion(failure, nil)
                return
            }
            
            guard let payload = response as? [[String: Any]] else {
                let failure = ServerStatus.parse(status: .badRequest)
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
                let failure = ServerStatus.parse(status: .badRequest)
                completion(failure, nil)
                return
            }

            return completion(nil, feed)
        })
    }
}
