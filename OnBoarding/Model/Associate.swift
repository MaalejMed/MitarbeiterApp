//
//  Associate.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

struct Associate {
    var identifier: String?
    var password: String?
    var email: String?
    var name: String?
    var image: UIImage?
    
    init?(json: [String: Any]) {
        guard let name = json["name"], let email = json["email"], let identifier = json["identifier"], let password = json["password"] else {
            return nil
        }
        
        self.identifier = identifier as? String
        self.password = password as? String
        self.email = email as? String
        self.name = name as? String
    }
    
    func profileImage() -> UIImage {
        guard let profileImage = self.image else {
            return UIImage.init(named: "Profile")!
        }
        return profileImage
    }
}
