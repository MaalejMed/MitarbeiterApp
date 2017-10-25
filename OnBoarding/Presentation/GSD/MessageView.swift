//
//  MessageView.swift
//  OnBoarding
//
//  Created by mmaalej on 18/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class MessageView: UIView {
    
    let titleTxtFHeight:CGFloat = 40
    let messageTxtVHeight: CGFloat = 300
    
    //MARK:- Properties
    let titleTxtF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Subject"
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(7.0, 0.0, 0.0)
        textField.backgroundColor = UIColor.elementBgColor
        return textField
    }()
    
    private let lineImgV: UIImageView = {
        let line = UIImageView()
        line.backgroundColor =  .gray
        return line
    }()
    
    lazy var messageTxtV: TextView = {
        let textView = TextView()
        textView.placeholder = "Message"
        textView.font = UIFont.systemFont(ofSize: 18.0)
        textView.layer.sublayerTransform = CATransform3DMakeTranslation(3.0, 0.0, 0.0)
        textView.backgroundColor = UIColor.elementBgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTextView))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        textView.addGestureRecognizer(tap)
        return textView
    }()
    
    var height: CGFloat? {
        return titleTxtFHeight + messageTxtVHeight
    }
    
    var data: (subject: String?, body: String?)? {
        didSet {
            titleTxtF.text = data?.subject
            messageTxtV.placeholder = ""
            messageTxtV.text = data?.body
            layout()
        }
    }
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.messageTxtV.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["title": titleTxtF, "line": lineImgV, "message": messageTxtV]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[title]-(0)-|", options: [], metrics: nil, views: views)
         layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[line]-(0)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[message]-(0)-|", options: [], metrics: nil, views: views)
          layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[title(\(titleTxtFHeight))]-(0)-[line(1)]-(0)-[message(\(messageTxtVHeight))]-(10)-|", options: [], metrics: nil, views: views)
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
