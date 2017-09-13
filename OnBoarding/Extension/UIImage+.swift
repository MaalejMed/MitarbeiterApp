//
//  UIImage+.swift
//  OnBoarding
//
//  Created by mmaalej on 13/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

extension UIImage {
    func scale(size:CGSize) -> UIImage {
        let horizontalRatio = 30.0 / size.width
        let verticalRatio = 30.0 / size.height
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        self.draw(in: CGRect(x:0, y:0, width: newSize.width, height: newSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
