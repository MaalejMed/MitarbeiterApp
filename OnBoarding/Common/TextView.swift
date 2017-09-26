//
//  TextView.swift
//  
//
//  Created by mmaalej on 26/09/2017.
//

import UIKit

class TextView: UITextView {
    var placeholder: String? {
        didSet {
            guard placeholder != "" else {
                self.textColor = .black
                self.text = ""
                return
            }
            self.textColor = .lightGray
            self.text = placeholder
            self.font = UIFont.systemFont(ofSize: 16.0)
        }
    }
}
