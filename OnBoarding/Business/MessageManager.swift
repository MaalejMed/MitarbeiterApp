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
            let failure = ServerStatus.parse(status: .badRequest)
            completion(failure)
            return
        }
        MessageService.submitMessage(dic: dic, completion: { response in
            guard response.result.isSuccess == true else {
                let failure = ServerStatus.parse(status: .serviceUnavailable)
                completion(failure)
                return
            }
            
            guard let serverStatus = response.result.value as? Int else {
                let failure = ServerStatus.parse(status: .unknown)
                completion(failure)
                return
            }
            guard let status = ServerStatus(rawValue: serverStatus) else {
                let failure = ServerStatus.parse(status: .unknown)
                completion(failure)
                return
            }
            
            let serverResponse = ServerStatus.parse(status: status)
            DataManager.sharedInstance.messages.insert(message, at: 0)
            completion(serverResponse)
            return
        })
    }
    
    func insert(subMessage: SubMessage, completion: @escaping ((ServerResponse?)->()) ) {
        guard let dic = subMessage.convertToJson() else {
            let failure = ServerStatus.parse(status: .badRequest)
            completion(failure)
            return
        }
        MessageService.submitSubMessage(dic: dic, completion: { response in
            guard response.result.isSuccess == true else {
                let failure = ServerStatus.parse(status: .serviceUnavailable)
                completion(failure)
                return
            }
            
            guard let serverStatus = response.result.value as? Int else {
                let failure = ServerStatus.parse(status: .unknown)
                completion(failure)
                return
            }
            
            guard let status = ServerStatus(rawValue: serverStatus) else {
                let failure = ServerStatus.parse(status: .unknown)
                completion(failure)
                return
            }
            
            let serverResponse = ServerStatus.parse(status: status)
            completion(serverResponse)
            return
        })
    }
    
    func selectMessagesFor(associateID: String, completion: @escaping ((ServerResponse?, [Message]?)->())) {
        var messages: [Message] = []
        MessageService.fetch(associateID: associateID, completion: { response in
            guard response.result.isSuccess == true else {
                let failure = ServerStatus.parse(status: .serviceUnavailable)
                completion(failure, nil)
                return
            }
            
            guard let payload = response.result.value as? [[String: Any]] else {
                guard let serverStatus = response.result.value as? Int else {
                    let failure = ServerStatus.parse(status: .unknown)
                    completion(failure, nil)
                    return
                }
                
                guard let status = ServerStatus(rawValue: serverStatus) else {
                    let failure = ServerStatus.parse(status: .unknown)
                    completion(failure, nil)
                    return
                }
                
                let failure = ServerStatus.parse(status: status)
                completion(failure, nil)
                return
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
                let failure = ServerStatus.parse(status: .serviceUnavailable)
                completion(failure, nil)
                return
            }
            
            guard let payload = response.result.value as? [[String: Any]] else {
                guard let serverStatus = response.result.value as? Int else {
                    let failure = ServerStatus.parse(status: .unknown)
                    completion(failure, nil)
                    return
                }
                guard let status = ServerStatus(rawValue: serverStatus) else {
                    let failure = ServerStatus.parse(status: .unknown)
                    completion(failure, nil)
                    return
                }
                let failure = ServerStatus.parse(status: status)
                completion(failure, nil)
                return
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
