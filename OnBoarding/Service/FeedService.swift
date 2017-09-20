//
//  FeedService.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class FeedService {
    static func updateFeeds() -> [Feed]? {
        var feeds:[Feed] = []
        guard let filePath = Bundle.main.url(forResource: "Feeds", withExtension: "json") else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: filePath, options: []) else {
            return nil
        }
        do {
          let JSONObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: String]]
            guard let FeedsArray = JSONObject else {
                return nil
            }
            for jsonFeed in FeedsArray {
                if let identifier = jsonFeed["identifier"], let title = jsonFeed["title"], let description = jsonFeed["description"], let date = jsonFeed["date"] {
                    let feed = Feed(identifier: identifier, title: title, description: description, date: date)
                    feeds.append(feed)
                }
            }
        } catch {
            return nil
        }
        return feeds
    }
}
