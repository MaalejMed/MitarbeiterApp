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
    
    func isNumber() -> Bool {
        return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func validateTimeFormat() -> Bool {
        guard self.characters.count == 5 else {
            return false
        }
        return true
    }
    
    
    
}
