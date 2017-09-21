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
    private let startBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.frame.size = CGSize(width: 100.0, height: 100.0)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.sizeToFit()
        button.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor.buttonColor
        button.layer.cornerRadius =  button.frame.width / 2
        button.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        return button
    }()
    
    private let stopBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Stop", for: .normal)
        button.frame.size = CGSize(width: 100.0, height: 100.0)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.sizeToFit()
        button.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor.buttonColor
        button.layer.cornerRadius =  button.frame.width / 2
        button.addTarget(self, action: #selector(stopTimer), for: .touchUpInside)
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
        let views: [String: UIView] = ["start": startBtn, "stop": stopBtn, ]
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[start(100)]-(>=10)-[stop(100)]-(10)-|", options: [], metrics: nil, views: views)
         layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[stop(100)]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[start(100)]-(10)-|", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    //MARK:- Selectors
    @objc func startTimer() {
        startBtn.setTitle("Good luck!", for: UIControlState.disabled)
        startBtn.backgroundColor = .lightGray
    }
    
    @objc func stopTimer() {
        stopBtn.isEnabled = false
        stopBtn.setTitle("Bye!", for: UIControlState.disabled)
        stopBtn.backgroundColor = .lightGray
    }
}
