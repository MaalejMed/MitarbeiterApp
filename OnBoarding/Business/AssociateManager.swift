//
//  AssociateManager.swift
//  OnBoarding
//
//  Created by mmaalej on 28/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation
import Alamofire

class AssociateManager {
    
    //MARK:-
    func selectAssociate(username: String, password: String, completion: @escaping ((ServerResponse?, Associate?)->())) {
        AssociateService.login(username: username, password: password, completion: { response in
            guard response.result.isSuccess == true else {
                let failure = ServerStatus.parse(status: .serviceUnavailable)
                completion(failure, nil)
                return
            }
  
            guard let payload = response.result.value as? [String: Any] else {
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
                let response = ServerStatus.parse(status: status)
                completion(response, nil)
                return
            }
            
            guard let associate = Associate(json: payload) else {
                let failure = ServerStatus.parse(status: .badRequest)
                completion(failure, nil)
                return
            }
            return completion(nil, associate)
        })
    }
    
    //MARK:-
    func updateAssociatePhoto(dic: [String: Any], completion: @escaping ((ServerResponse?)->()) ) {
        AssociateService.changeProfilePhoto(dic: dic, completion: { response in
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
            let response = ServerStatus.parse(status: status)
            completion(response)
        })
    }
}
