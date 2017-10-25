//
//  Message.swift
//  OnBoarding
//
//  Created by mmaalej on 26/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

struct Message {
    
    //MARK:- Properties
    var identifier: String?
    var associateID: String?
    var title: String?
    var body: String?
    var subMessages: [SubMessage]?
    var date: Date?
    
    //MARK:- JSON
    func convertToJson()-> [String: Any]? {
        guard let assoID = associateID, let ident = identifier, let tit = title, let bod = body , let dat = date else {
            return nil
        }
        let dic: [String: Any] = [
            "associateID": assoID,
            "identifier": ident,
            "title": tit,
            "body": bod,
            "date": dat.simpleDateFormat()
        ]
        return dic
    }
    
    //MARK:- Init
    init?(json: [String: Any]) {
        guard let ident = json["identifier"], let assoID = json["associateID"], let titl = json["title"], let bod = json["body"], let date = json["date"] else {
            return nil
        }
        
        self.identifier = ident as? String
        self.associateID = assoID as? String
        self.title = titl as? String
        self.body = bod as? String
        
        if let dateString = date as? String {
            self.date = dateString.date()
        }
    }
    
    init(identifier: String, associateID: String, title: String, body: String, subMessages: [SubMessage]?, date: Date) {
        self.identifier = identifier
        self.associateID = associateID
        self.title = title
        self.body = body
        self.date = date
        self.subMessages = subMessages
    }
}
