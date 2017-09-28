//
//  AlertView.swift
//  OnBoarding
//
//  Created by mmaalej on 18/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    //MARK:- Properties
    private let iconImgV: UIImageView = {
        let imageView  = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLbl: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let descriptionLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    var data : (title: String?, description: String?, icon: UIImage?)? {
        didSet {
            iconImgV.image = data?.icon
            titleLbl.text = data?.title
            descriptionLbl.text = data?.description
        }
    }
    
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
        let views :[String : UIView] = ["title": titleLbl, "description": descriptionLbl, "icon": iconImgV]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += [
            titleLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            descriptionLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImgV.centerYAnchor.constraint(equalTo: titleLbl.centerYAnchor)
        ]
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[icon(40)]-(10)-[title]", options:[], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[description]-(10)-|", options:[], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-(10)-[description]", options:[], metrics: nil, views: views)
        NSLayoutConstraint.activate(layoutConstraints)
    }
}
