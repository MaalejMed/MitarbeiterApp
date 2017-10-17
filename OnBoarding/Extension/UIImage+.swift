//
//  UIImage+.swift
//  OnBoarding
//
//  Created by mmaalej on 16/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

extension UIImage {
    
    func toString() -> String? {
        let imageData = UIImagePNGRepresentation(self)
        return imageData?.base64EncodedString()

    }
}
