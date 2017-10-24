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
            let serverResponse = ServerStatus.parse(status: ServerStatus(rawValue: serverStatus)!)
            completion(serverResponse)
            return
        })
    }
}
