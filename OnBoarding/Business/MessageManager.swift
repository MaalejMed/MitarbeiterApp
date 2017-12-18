//
//  MessageManager.swift
//  OnBoarding
//
//  Created by mmaalej on 24/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class MessageManager {
    
    //MARK:- Message
    static func fetchMessages(associateID: String, completion: @escaping (([Message]?)->())) {
        var messages: [Message] = []
        MessageService.fetchMessages(associateID: associateID, completion: { response in
            guard response.result.isSuccess == true else {
                return completion(nil)
            }
            
            guard let payload = response.result.value as? [[String: Any]] else {
                return completion(nil)
            }
            
            for jsonItem in payload {
                guard let aMessage = Message(json: jsonItem) else {
                    continue
                }
                messages.append(aMessage)
            }
            DataManager.sharedInstance.messages = messages
            completion(messages)
        })
    }
    
    static func send(message: Message, completion: @escaping ((ServerResponse?)->()) ) {
        guard let dic = message.convertToJson() else {
            return completion(ServerResponse.init(serverStatus: .badRequest))
        }
        
        MessageService.sendMessage(dic: dic, completion: { response in
            guard response.result.isSuccess == true else {
                return completion(ServerResponse.init(serverStatus: .serviceUnavailable))
            }
            
            let serverResponse = ServerResponse.init(serverStatus: response.result.value!)
            let _ = serverResponse.status == .success ? DataManager.sharedInstance.messages.insert(message, at: 0) : nil
            return completion(serverResponse)
        })
    }
    
    //MARK:- Submessage
    static func fetchSubMessages(messageID: String, completion: @escaping (([SubMessage]?)->())) {
        var messages: [SubMessage] = []
        MessageService.fetchSubMessage(messageID: messageID, completion: { response in
            guard response.result.isSuccess == true else {
                return completion(nil)
            }
            
            guard let payload = response.result.value as? [[String: Any]] else {
                return completion(nil)
            }
            
            for jsonItem in payload {
                guard let aSubMessage = SubMessage(json: jsonItem) else {
                    continue
                }
                messages.append(aSubMessage)
            }
            
            return completion(messages)
        })
    }
    
    static func send(subMessage: SubMessage, completion: @escaping ((ServerResponse?)->()) ) {
        guard let dic = subMessage.convertToJson() else {
            return completion(ServerResponse.init(serverStatus: .badRequest))
        }
        MessageService.submitSubMessage(dic: dic, completion: { response in
            guard response.result.isSuccess == true else {
                return completion(ServerResponse.init(serverStatus: .serviceUnavailable))
            }
            return completion(ServerResponse.init(serverStatus: response.result.value!))
        })
    }
}
