//
//  DataManager.swift
//  OnBoarding
//
//  Created by mmaalej on 06/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class DataManager {
    
    //MARK:- Properties
    var associate: Associate?
    var timesheet: Timesheet?
    var feeds: [Feed] = []
    var messages: [Message] = []
    
    static let sharedInstance: DataManager = {
        let instance = DataManager()
        return instance
    }()
    
    //MARK:- Setup
    func setupFor(associate: Associate) {
        //associate
        DataManager.sharedInstance.associate = associate
        
        //feeds
        FeedManager.selectFeeds()
        
        //timesheet
        DataManager.sharedInstance.timesheet = Timesheet()
        TimeManager.SelectLastSubmittedDay()
    }
    
    func resetTimesheet(lastSubmittedDay: Date) {
        self.timesheet = Timesheet()
        self.timesheet?.lastSubmittedDay = lastSubmittedDay
    }
    
    //MARK:- Messages
    func updateMessages(associateID: String, completion: @escaping ((ServerResponse?)->()) ) {
        let messageManager = MessageManager()
        messageManager.selectMessagesFor(associateID: associateID ,completion: { failure, messages in
            guard failure == nil, let existingMessages = messages  else {
                return completion(failure)
            }
            DataManager.sharedInstance.messages = existingMessages
            return completion(nil)
        })
    }
    
    func updateSubMessages(messageID: String, completion: @escaping (([SubMessage]? ,ServerResponse?)->()) ) {
        let messageManager = MessageManager()
        messageManager.selectSubMessage(messageID: messageID ,completion: {[weak self] failure, subMessages in
            guard failure == nil, let existingSubMessages = subMessages  else {
                return completion(nil, failure)
            }
            
            guard var messageTuple: (message: Message?, index: Int?) = self?.getMessage(messageID: messageID) else {
                return
            }
            messageTuple.message?.subMessages = existingSubMessages
            
            DataManager.sharedInstance.messages[messageTuple.index!] =  messageTuple.message!
            return completion(existingSubMessages, nil)
        })
    }
    
    func getMessage(messageID: String) -> (Message?, Int?)? {
        for (index, message) in self.messages.enumerated() {
            if message.identifier == messageID {
                return (message, index)
            }
        }
        return nil
    }
}
