//
//  TimeTextField.swift
//  OnBoarding
//
//  Created by mmaalej on 09/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

enum Format {
    case date
    case time
}

protocol TimeTextFieldDelegate: class {
    func didChangeValue(dateTime: Date, key: EntryKey)
}

class TimeTextField: UITextField {
    
    //MARK:- Properties
    var format: Format?
    var key: EntryKey?
    weak var timeTextDelegate: TimeTextFieldDelegate?
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.textAlignment = .right
        self.keyboardType = .decimalPad
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TimeTextField : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // add :
        if  !(textField.text?.contains(":"))!, textField.text?.characters.count == 1 {
            let newString = textField.text! + string + ":"
            self.text = newString
            return false
        }

        return TimeHelper.shoudlChange(timeString: textField.text!, range: range, newString: string)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        guard text.validateTimeFormat() else {
            textField.textColor = .red
            return
        }
        
        guard let dateTime = self.text?.dateTime() else {
            textField.textColor = .red
            return
        }
        timeTextDelegate?.didChangeValue(dateTime: dateTime, key: key!)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .black
    }
}
