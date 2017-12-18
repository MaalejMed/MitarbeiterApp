//
//  AuthenticationManager.swift
//  OnBoarding
//
//  Created by mmaalej on 12/12/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

import Foundation

class AuthenticationManager {
    
    //MARK:-Login
    static func login(username: String, password: String, completion: @escaping ((ServerResponse?) -> ())){
        AuthenticationService.login(username: username, password: password, completion: { response in
            guard response.result.isSuccess == true else {
                let failure = ServerResponse(serverStatus: .serviceUnavailable)
                completion(failure)
                return
            }
            completion(ServerResponse.init(serverStatus: response.result.value!))
        })
    }
    
    //MARK: Keychain
    static func kcSave(assID: String, assPass: String) {
        KeyChainHelper.save(associateID: assID, associatePassword: assPass)
    }
    
    static func kcRetrieveAssociateCredentials() -> (String?, String?) {
        let credentials = KeyChainHelper.getAssociateCredentials()
        guard let assID = credentials.0, let assPass = credentials.1 else {
            return (nil, nil)
        }
        return (assID, assPass)
    }
}
