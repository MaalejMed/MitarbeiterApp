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
    
    func date() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
    
    func dateTime() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self)
    }
    
    func image() -> UIImage? {
        guard let data = Data.init(base64Encoded: self) else {
            return nil
        }
        return UIImage.init(data: data)
    }
    
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat? {
        let label = UILabel()
        label.text = self
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        let textSize = label.textRect(forBounds: CGRect.init(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude), limitedToNumberOfLines: 0)
        label.frame = CGRect.init(x: 0, y: 0, width: textSize.width, height: textSize.height)
        return textSize.height
    }
}
