//
//  AssociateManager.swift
//  OnBoarding
//
//  Created by mmaalej on 28/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class AssociateManager {
    
    //MARK:-
    static func fetchProfileData(associateID: String, completion: ((ServerResponse?) -> ())?) {
        AssociateService.fetchProfileData(associateID: associateID, completion: { response in
            guard response.result.isSuccess == true else {
                completion?(ServerResponse(serverStatus: .serviceUnavailable))
                return
            }
  
            guard let payload = response.result.value as? [String: Any] else {
                completion?(ServerResponse.init(serverStatus: .badRequest))
                return
            }
            
            guard let associate = Associate(json: payload) else {
                completion?(ServerResponse.init(serverStatus: .badRequest))
                return
            }
            DataManager.sharedInstance.associate = associate
            completion?(ServerResponse.init(serverStatus: .success))
        })
    }
    
    //MARK:-
    func updateAssociatePhoto(dic: [String: Any], completion: @escaping ((ServerResponse?)->()) ) {
        AssociateService.changeProfilePhoto(dic: dic, completion: { response in
            guard response.result.isSuccess == true else {
                return completion(ServerResponse(serverStatus: .serviceUnavailable))
            }
            completion(ServerResponse.init(serverStatus: response.result.value as! String))
        })
    }
}
