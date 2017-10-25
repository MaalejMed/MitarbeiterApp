//
//  SubMessageView.swift
//  OnBoarding
//
//  Created by mmaalej on 25/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class SubMessageView: UIView {
    
    //MARK:- Properties
    let padding: CGFloat = 10

    let bodyLbl: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var data: (body:String?, isOwner: Bool?)? {
        didSet {
            bodyLbl.text = data?.body
            bodyLbl.backgroundColor = ( data?.isOwner == true) ? .blue : .lightGray
            layout()
        }
    }
    
    var height: CGFloat? {
        return (bodyLbl.text?.height(constraintedWidth: self.frame.width, font: UIFont.systemFont(ofSize: 13)))! + padding
    }
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["body": bodyLbl]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[body]-(5)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[body(\(height!))]-(0)-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(layoutConstraints)
    }
}
