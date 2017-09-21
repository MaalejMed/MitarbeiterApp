//
//  TimeInterval+.swift
//  OnBoarding
//
//  Created by mmaalej on 21/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

extension TimeInterval {
    func inMinutes() -> (minutes: Int, seconds: Int) {
        let minutes = self / 60
        let seconds = self.truncatingRemainder(dividingBy: 60)
        return (minutes: Int(minutes), seconds: Int(seconds))
    }
}
