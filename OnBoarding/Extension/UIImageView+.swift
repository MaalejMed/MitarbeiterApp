//
//  UIImageView+.swift
//  OnBoarding
//
//  Created by mmaalej on 13/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

extension UIView {
    func rounded() {
        let radius = self.frame.size.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1.0
    }
}
