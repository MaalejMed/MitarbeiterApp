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
    var name: String?
    var image: UIImage?
    
    func profileImage() -> UIImage {
        guard let profileImage = self.image else {
            return UIImage.init(named: "Profile")!
        }
        return profileImage
    }
}
