//
//  AssociateManager.swift
//  OnBoarding
//
//  Created by mmaalej on 28/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class AssociateManager: Subject {
    
    // MARK:- Properties
    static var observers: [Observer] = []
    
    //MARK:- Subject
    static func register(observer: Observer) {
        observers.append(observer)
    }
    
    static func deregister(observer: Observer) {
        for (index, ob) in observers.enumerated() {
            if ob.identifier == observer.identifier {
                observers.remove(at: index)
            }
        }
    }
    
    static func notify() {
        for observer in observers {
            observer.update(subject: self)
        }
    }
    
    //MARK:-
    static func fetchProfileData(associateID: String, completion: ((ServerResponse?) -> ())?) {
        AssociateService.fetchProfileData(associateID: associateID, completion: { response in
            guard response.result.isSuccess == true else {
                completion?(ServerResponse(serverStatus: .serviceUnavailable))
                notify()
                return
            }
  
            guard let payload = response.result.value as? [String: Any] else {
                completion?(ServerResponse.init(serverStatus: .badRequest))
                notify()
                return
            }
            
            guard let associate = Associate(json: payload) else {
                completion?(ServerResponse.init(serverStatus: .badRequest))
                notify()
                return
            }
            DataManager.sharedInstance.associate = associate
            notify()
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
