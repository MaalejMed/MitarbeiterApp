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
    static let topPadding: CGFloat = 10
    static let bottomPadding: CGFloat = 10
    static let bodyFont = UIFont.systemFont(ofSize: 14)
    static let dateFont = UIFont.boldSystemFont(ofSize: 12)


    let bodyLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = SubMessageView.bodyFont
        return label
    }()
    
    let dateLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = SubMessageView.bodyFont
        return label
    }()
    
    var data: (subMessage:SubMessage?, isOwner: Bool?)? {
        didSet {
            bodyLbl.text = data?.subMessage?.body
            dateLbl.text = data?.subMessage?.date?.simpleHoursFormat()
            self.backgroundColor = ( data?.isOwner == true) ? UIColor.myMessageBgColor : UIColor.BgColor
            layout()
        }
    }
    
    var height: CGFloat? {
        //TODO: 380 to be replaced with the width of the view
        return (bodyLbl.text?.height(constraintedWidth: 380, font: SubMessageView.bodyFont))! + SubMessageView.topPadding + SubMessageView.bottomPadding
    }
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["body": bodyLbl, "date": dateLbl]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[body]-(>=5)-[date]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(SubMessageView.topPadding))-[body]-(\(SubMessageView.bottomPadding))-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(SubMessageView.topPadding))-[date]", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
}
