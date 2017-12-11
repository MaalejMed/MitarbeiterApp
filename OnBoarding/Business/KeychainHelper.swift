//
//  KeychainHelper.swift
//  OnBoarding
//
//  Created by mmaalej on 21/11/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation
import Security

enum kcAccounts: String {
    case associate
}

class KeyChainHelper: NSObject {
    
    //MARK: Associate
    static func save(associateID: String) {
        guard let data = associateID.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            return
        }

        let query: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword as String,
            kSecAttrAccount as String : kcAccounts.associate.rawValue,
            kSecValueData as String   : data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        print(status)
    }
    
    static func getAssociateID() -> String? {
        
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : kcAccounts.associate.rawValue,
            kSecReturnData as String  : kCFBooleanTrue,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
        
        var dataTypeRef: AnyObject? = nil
        SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard let  data = dataTypeRef as? Data else {
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    static func delete(associate: Associate) {
        let query: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword as String,
            kSecAttrAccount as String : kcAccounts.associate.rawValue,
        ]
        SecItemDelete(query as CFDictionary)
    }
}
