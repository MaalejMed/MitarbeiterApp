//
//  FeedManager.swift
//  OnBoarding
//
//  Created by mmaalej on 04/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class FeedManager {
    
    // MARK:- Properties
    static var observers: [Observer] = []
    
    //MARK:- Subject
    static func register(observer: Observer) {
        observers.append(observer)
    }
    
    static func deregister(observer: Observer) {
        for (index, ob) in observers.enumerated() {
            if ob.identifier == observer.identifier {
                observers.remove(at: index)
            }
        }
    }
    
    static func notify() {
        for observer in observers {
            observer.update()
        }
    }
    
    //MARK:- Operations
    static func selectFeeds() {
        var feeds: [Feed] = []
        FeedService.fetch(completion: { response in
            guard response.result.isSuccess == true else {
                FeedManager.notify()
                return
            }
            
            guard let payload = response.result.value as? [[String: Any]] else {
                FeedManager.notify()
                return
            }
            
            for jsonItem in payload {
                guard let aFeed = Feed(json: jsonItem) else {
                    continue
                }
                feeds.append(aFeed)
            }
            DataManager.sharedInstance.feeds = feeds
            FeedManager.notify()
        })
    }
}
