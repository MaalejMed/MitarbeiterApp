//
//  TextView.swift
//  
//
//  Created by mmaalej on 26/09/2017.
//

import UIKit

class TextView: UITextView {
    
    //MARK:- Properites
    var placeholder: String? {
        didSet {
            setPlaceHolder()
        }
    }
    
    func setPlaceHolder() {
        guard placeholder != "" else {
            self.textColor = .black
            self.text = ""
            return
        }
        self.textColor = UIColor.placehoderTextColor
        self.text = placeholder
    }
}
