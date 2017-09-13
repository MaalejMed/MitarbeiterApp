//
//  HomeView.swift
//  OnBoarding
//
//  Created by mmaalej on 12/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class HomeView: UIView {
    
    //Properties
    let headerLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var contentView:UIView
    
    //MARK: init
    init(header: String, contentView: UIView) {
        self.contentView = contentView
        headerLbl.text = header
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["header": headerLbl, "content": contentView]
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[header]-(20)-|", options:[] , metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[content]-(20)-|", options:[] , metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(30)-[header]-(20)-[content]-(20)-|", options:[] , metrics: nil, views: views)
        NSLayoutConstraint.activate(layoutConstraints)
    }
}
