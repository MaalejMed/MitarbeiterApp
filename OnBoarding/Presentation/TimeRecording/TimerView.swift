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
    
    let hoursLbl: UILabel = {
        let label = UILabel()
        label.text = "00:"
        return label
    }()
    
    let minutesLbl: UILabel = {
        let label = UILabel()
        label.text = "00:"
        return label
    }()
    
    let secondsLbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        return label
    }()
    
    var timer = Timer()
    var seconds: Int = 0
    var minutes: Int = 0
    var hours: Int = 0
    
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
        let views: [String: UIView] = ["start": startBtn, "stop": stopBtn, "hours": hoursLbl, "minutes": minutesLbl, "seconds": secondsLbl]
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += [
            minutesLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            minutesLbl.centerYAnchor.constraint(equalTo: hoursLbl.centerYAnchor),
            secondsLbl.centerYAnchor.constraint(equalTo: hoursLbl.centerYAnchor)
        ]
        
           layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[hours]-(5)-[minutes]", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[minutes]-(5)-[seconds]", options: [], metrics: nil, views: views)
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[start(100)]-(>=10)-[stop(100)]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[hours]-(20)-[start(100)]-(>=10)-|", options: [], metrics: nil, views: views)
         layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[hours]-(20)-[stop(100)]-(>=10)-|", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    //MARK:- Selectors
    @objc func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
            self.seconds = self.seconds + 1
            if (self.seconds != 60) {
                self.secondsLbl.text = String(self.seconds)
            } else {
                self.seconds = 0
                self.secondsLbl.text = String(self.seconds)
                self.minutes = self.minutes + 1
                if  (self.minutes != 60) {
                    self.minutesLbl.text = String(self.minutes) + ":"
                } else {
                    self.minutes = 0
                    self.minutesLbl.text = String(self.minutes) + ":"
                    self.hours = self.hours + 1
                    self.hoursLbl.text = String(self.hours) + ":"
                }
            }
            
            
        })
        startBtn.isEnabled = false
        startBtn.setTitle("Good luck!", for: UIControlState.disabled)
        startBtn.backgroundColor = .lightGray
    }
    
    @objc func stopTimer() {
        stopBtn.isEnabled = false
        stopBtn.setTitle("Bye!", for: UIControlState.disabled)
        stopBtn.backgroundColor = .lightGray
        timer.invalidate()
    }
}
