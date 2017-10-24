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
    var response: [MessageResponse]?
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
}
