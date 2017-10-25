//
//  SubMessage.swift
//  OnBoarding
//
//  Created by mmaalej on 26/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

struct SubMessage {
    
    //MARK:- Properties
    var identifier: String?
    var body: String?
    var MessageIdentifier: String?
    var date: Date?
    var owner: Bool?
    
    //MARK:- Init
    init?(json: [String: Any]) {
        guard let ident = json["identifier"], let messageID = json["messageID"], let bod = json["body"], let date = json["date"], let owner = json["owner"] else {
            return nil
        }
        
        self.identifier = ident as? String
        self.MessageIdentifier = messageID as? String
        self.body = bod as? String
        self.owner = owner as? Bool
        
        if let dateString = date as? String {
            self.date = dateString.date()
        }
    }
}
