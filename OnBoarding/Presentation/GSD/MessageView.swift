//
//  MessageView.swift
//  OnBoarding
//
//  Created by mmaalej on 18/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class MessageView: UIView {
    
    //MARK:- Properties
    let titleTxtF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Subject"
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(7.0, 0.0, 0.0)
        textField.layer.cornerRadius = 5.0
        return textField
    }()
    
    lazy var messageTxtV: TextView = {
        let textView = TextView()
        textView.placeholder = "Message"
        textView.font = UIFont.systemFont(ofSize: 18.0)
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.sublayerTransform = CATransform3DMakeTranslation(4.0, 0.0, 0.0)
        textView.layer.cornerRadius = 5.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTextView))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        textView.addGestureRecognizer(tap)
        return textView
    }()
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.messageTxtV.delegate = self
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["title": titleTxtF, "message": messageTxtV]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[title]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[message]-(10)-|", options: [], metrics: nil, views: views)
          layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[title(30)]-(10)-[message(300)]-(10)-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    //MARK:- Selectors
    @objc func didTapTextView() {
        messageTxtV.becomeFirstResponder()
        guard messageTxtV.placeholder != "" else {
            return
        }
        messageTxtV.selectedRange = NSMakeRange(0, 0);
    }
}

extension MessageView : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard textView.text == "" else {
            return
        }
        messageTxtV.placeholder = "Message"
        textView.selectedRange = NSMakeRange(0, 0);
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard messageTxtV.placeholder != "" else {
            return true
        }
        guard text == "" else {
            messageTxtV.placeholder = ""
            return true
        }
        return false
    }
}
