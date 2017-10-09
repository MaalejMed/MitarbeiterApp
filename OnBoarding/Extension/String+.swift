//
//  String+.swift
//  OnBoarding
//
//  Created by mmaalej on 09/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

extension String {
    func characterAtIndex(index: Int)-> Character? {
        for (ind, character) in self.characters.enumerated() {
            if ind == index {
                return character
            }
        }
        return nil
    }
}
