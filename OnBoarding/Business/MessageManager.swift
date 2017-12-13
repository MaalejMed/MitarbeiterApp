//
//  MessageManager.swift
//  OnBoarding
//
//  Created by mmaalej on 24/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class MessageManager {
    
    //MARK:-
    func insert(message: Message, completion: @escaping ((ServerResponse?)->()) ) {
        guard let dic = message.convertToJson() else {
            return completion(ServerResponse.init(serverStatus: .badRequest))
        }
        
        MessageService.submitMessage(dic: dic, completion: { response in
            guard response.result.isSuccess == true else {
                return completion(ServerResponse.init(serverStatus: .serviceUnavailable))
            }
            
            let serverResponse = ServerResponse.init(serverStatus: response.result.value as! String)
            let _ = serverResponse.status == .success ? DataManager.sharedInstance.messages.insert(message, at: 0) : nil
            return completion(serverResponse)
        })
    }
    
    func insert(subMessage: SubMessage, completion: @escaping ((ServerResponse?)->()) ) {
        guard let dic = subMessage.convertToJson() else {
            return completion(ServerResponse.init(serverStatus: .badRequest))
        }
        MessageService.submitSubMessage(dic: dic, completion: { response in
            guard response.result.isSuccess == true else {
                return completion(ServerResponse.init(serverStatus: .serviceUnavailable))
            }
            return completion(ServerResponse.init(serverStatus: response.result.value as! String))
        })
    }
    
    func selectMessagesFor(associateID: String, completion: @escaping ((ServerResponse?, [Message]?)->())) {
        var messages: [Message] = []
        MessageService.fetch(associateID: associateID, completion: { response in
            guard response.result.isSuccess == true else {
                return completion(ServerResponse.init(serverStatus: .serviceUnavailable), nil)
            }
            
            guard let payload = response.result.value as? [[String: Any]] else {
                return completion(ServerResponse.init(serverStatus: .badRequest), nil)
            }
            
            for jsonItem in payload {
                guard let aMessage = Message(json: jsonItem) else {
                    continue
                }
                messages.append(aMessage)
            }
            
            return completion(nil, messages)
        })
    }
    
    func selectSubMessage(messageID: String, completion: @escaping ((ServerResponse?, [SubMessage]?)->())) {
        var messages: [SubMessage] = []
        MessageService.fetchSubMessage(messageID: messageID, completion: { response in
            guard response.result.isSuccess == true else {
                return completion(ServerResponse.init(serverStatus: .serviceUnavailable), nil)
            }
            
            guard let payload = response.result.value as? [[String: Any]] else {
                return completion(ServerResponse.init(serverStatus: .unknown), nil)
            }
            
            for jsonItem in payload {
                guard let aSubMessage = SubMessage(json: jsonItem) else {
                    continue
                }
                messages.append(aSubMessage)
            }
            
            return completion(nil, messages)
        })
    }
}
