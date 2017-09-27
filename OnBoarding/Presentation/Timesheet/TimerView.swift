//
//  TimerView.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class TimerView: UIView {
    
    //MARK:-  Properties
    private let lineImgV: UIImageView = {
        let line = UIImageView()
        line.backgroundColor =  .gray
        return line
    }()
    
    lazy var timerBtn: TimerButton = {
        let button = TimerButton()
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.sizeToFit()
        button.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor.buttonColor
        button.layer.cornerRadius =  button.frame.width / 2
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    var timerBtnAction: (()->())?
    
    //MARK:- Init
    init(status: Status) {
        super.init(frame: .zero)
        timerBtn.status = status
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["timer": timerBtn, "line": lineImgV]
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        
        layoutConstraints += [
            timerBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            lineImgV.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[timer(140)]", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[line]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[line(2)]-(10)-[timer(100)]-(10)-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
   
    
    //MARK:- Selectors
    @objc func buttonTapped() {
        guard let action = timerBtnAction else {
            return
        }
        action()
    }
}

