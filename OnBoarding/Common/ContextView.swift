//
//  ContextView.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class ContextView: UIView {
    
    //MARK:- Properties
    lazy var contextBtn: ContextButton = {
        let button = ContextButton(frame: .zero)
        button.addTarget(self, action: #selector(contextBtnTapped), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor.buttonColor
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    private let lineImgV: UIImageView = {
        let line = UIImageView()
        line.backgroundColor =  .gray
        return line
    }()
    
    var contextBtnAction: (()->())?
    
    //MARK:- Init
    init(context: Context) {
        super.init(frame: .zero)
        contextBtn.context = context
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["button": contextBtn, "line": lineImgV]
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += [
            contextBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            lineImgV.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[button(140)]", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[line]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[line(2)]-(10)-[button(50)]-(10)-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    //MARK:- Selectors
    @objc func contextBtnTapped() {
        guard let action = contextBtnAction else {
            return
        }
        action()
    }
}
