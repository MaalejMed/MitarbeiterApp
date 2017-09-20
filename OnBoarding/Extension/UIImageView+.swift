//
//  UIImageView+.swift
//  OnBoarding
//
//  Created by mmaalej on 13/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

extension UIImageView {
    func rounded() {
        let radius = self.frame.size.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
