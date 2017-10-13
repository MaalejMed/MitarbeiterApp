//
//  Feed.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

struct Feed {
    var identifier: String?
    var title: String?
    var description: String?
    var details: String?
    var date: Date?
    
    init?(json: [String: Any]) {
        guard let title = json["title"], let description = json["description"], let details = json["details"], let date = json["date"] else {
            return nil
        }
        
        self.title = title as? String
        self.description = description as? String
        self.details = details as? String
        
        if let dateString = date as? String {
            self.date = dateString.date()
        }
    }
}
