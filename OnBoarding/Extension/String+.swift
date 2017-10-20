//
//  String+.swift
//  OnBoarding
//
//  Created by mmaalej on 09/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

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
    
    func dateTime() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.date(from: self)
    }
    
    func date() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
    
    func image() -> UIImage? {
        guard let data = Data.init(base64Encoded: self) else {
            return nil
        }
        return UIImage.init(data: data)
    }
}
