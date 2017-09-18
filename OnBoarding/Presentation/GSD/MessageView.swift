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
    let messageTxtV: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.sublayerTransform = CATransform3DMakeTranslation(7.0, 0.0, 0.0)
        textView.layer.cornerRadius = 5.0
        return textView
    }()
    
    let sendBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor.buttonColor
        button.layer.cornerRadius = 5.0
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        return button
    }()
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["message": messageTxtV, "send": sendBtn]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[message]-(0)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[send]-(0)-|", options: [], metrics: nil, views: views)
          layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[message(300)]-(20)-[send]", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(layoutConstraints)
    }
}
