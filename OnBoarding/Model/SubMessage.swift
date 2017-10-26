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
    var messageIdentifier: String?
    var date: Date?
    var owner: Bool?
    
    //MARK:- Init
    
    init(identifier: String, body: String, messageID: String, date: Date, owner: Bool) {
        self.identifier = identifier
        self.body = body
        self.messageIdentifier = messageID
        self.date = date
        self.owner = owner
    }
    
    init?(json: [String: Any]) {
        guard let ident = json["identifier"], let messageID = json["messageID"], let bod = json["body"], let date = json["date"], let owner = json["owner"] else {
            return nil
        }
        
        self.identifier = ident as? String
        self.messageIdentifier = messageID as? String
        self.body = bod as? String
        self.owner = owner as? Bool
        
        if let dateString = date as? String {
            self.date = dateString.date()
        }
    }
    
    //MARK:- JSON
    func convertToJson()-> [String: Any]? {
        guard let ident = identifier, let bod = body , let dat = date, let mainMsgID = messageIdentifier, let owner = owner else {
            return nil
        }
        let dic: [String: Any] = [
            "identifier": ident,
            "body": bod,
            "date": dat.simpleDateFormat(),
            "messageID": mainMsgID,
            "owner": owner
        ]
        return dic
    }
}
