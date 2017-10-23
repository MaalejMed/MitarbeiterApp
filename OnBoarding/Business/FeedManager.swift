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
            guard response.result.isSuccess == true else {
                let failure = ServerStatus.parse(status: .serviceUnavailable)
                completion(failure, nil)
                return
            }
            
            guard let payload = response.result.value as? [[String: Any]] else {
                guard let serverStatus = response.result.value as? Int else {
                    let failure = ServerStatus.parse(status: .unknown)
                    completion(failure, nil)
                    return
                }
                let failure = ServerStatus.parse(status: ServerStatus(rawValue: serverStatus)!)
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
