//
//  KeychainHelper.swift
//  OnBoarding
//
//  Created by mmaalej on 21/11/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation
import Security

enum kckeys: String {
    case associateID
    case associatePassword
}

class KeyChainHelper: NSObject {
    
    //MARK: Associate
    static func save(associateID: String, associatePassword: String) {
        guard let assID = associateID.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            return
        }
        
        guard let assPass = associatePassword.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            return
        }

        //save ID
        let queryAssID: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword as String,
            kSecAttrAccount as String : kckeys.associateID.rawValue,
            kSecValueData as String   : assID
        ]
        
        let _ = SecItemAdd(queryAssID as CFDictionary, nil)
        
        //save Password
        let queryAssPass: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword as String,
            kSecAttrAccount as String : kckeys.associatePassword.rawValue,
            kSecValueData as String   : assPass
        ]
        
        let _ = SecItemAdd(queryAssPass as CFDictionary, nil)

    }
    
    static func getAssociateCredentials() -> (String?, String?) {
        
        //read associateID
        let queryAssID = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : kckeys.associateID.rawValue,
            kSecReturnData as String  : kCFBooleanTrue,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
        
        var dataTypeRefAssID: AnyObject? = nil
        SecItemCopyMatching(queryAssID as CFDictionary, &dataTypeRefAssID)
    
        guard let  dataAssID = dataTypeRefAssID as? Data else {
            return (nil, nil)
        }
        
        let associateID = String(data: dataAssID, encoding: String.Encoding.utf8)
        
        //read associatePassword
        
        let queryAssPass = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : kckeys.associatePassword.rawValue,
            kSecReturnData as String  : kCFBooleanTrue,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
        
        var dataTypeRefAssPass: AnyObject? = nil
        SecItemCopyMatching(queryAssPass as CFDictionary, &dataTypeRefAssPass)
        
        guard let  dataAssPass = dataTypeRefAssPass as? Data else {
            return (nil, nil)
        }
        
        let associatePass = String(data: dataAssPass, encoding: String.Encoding.utf8)
        
        return (associateID, associatePass)
    }
    
    static func deleteAssociateCredentials() {
        //delete associateID
        let queryAssID: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword as String,
            kSecAttrAccount as String : kckeys.associateID.rawValue,
        ]
        SecItemDelete(queryAssID as CFDictionary)
        
        //delete associatePass
        let queryAssPass: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword as String,
            kSecAttrAccount as String : kckeys.associatePassword.rawValue,
            ]
        SecItemDelete(queryAssPass as CFDictionary)
    }
}
