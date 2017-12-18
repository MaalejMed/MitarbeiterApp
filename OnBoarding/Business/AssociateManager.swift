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
    static func fetchData(associateID: String) {
        AssociateService.fetchData(associateID: associateID, completion: { response in
            guard response.result.isSuccess == true else {
                notify()
                return
            }
  
            guard let payload = response.result.value as? [String: Any] else {
                notify()
                return
            }
            
            guard let associate = Associate(json: payload) else {
                notify()
                return
            }
            DataManager.sharedInstance.associate = associate
            notify()
        })
    }
    
    //MARK:-
    static func updatePhoto(dic: [String: Any], completion: @escaping ((ServerResponse?)->()) ) {
        AssociateService.updatePhoto(dic: dic, completion: { response in
            guard response.result.isSuccess == true else {
                return completion(ServerResponse(serverStatus: .serviceUnavailable))
            }
            completion(ServerResponse.init(serverStatus: response.result.value!))
        })
    }
}
