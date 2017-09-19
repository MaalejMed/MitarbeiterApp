//
//  InfoView.swift
//  OnBoarding
//
//  Created by mmaalej on 13/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

let imageSize = CGSize(width: 40.0, height: 40.0)

class InfoView: UIView {
    
    var action: (()->())?
    
    private let iconImgV: UIImageView = {
        let imageView  = UIImageView()
        imageView.frame.size = CGSize (width: 40.0, height: 40.0)
        imageView.contentMode = .scaleAspectFit
        imageView.rounded()
        return imageView
    }()
    
    private let titleLbl: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var data : (title: String?, icon: UIImage?, action: (()->())?)? {
        didSet {
            let scaledImage = data?.icon?.scale(size: imageSize)
            iconImgV.image = scaledImage
            titleLbl.text = data?.title
            guard let iconAction = data?.action else {
                return
            }
            action = iconAction
            let gr = UITapGestureRecognizer(target: self, action: #selector(changeImage))
            iconImgV.isUserInteractionEnabled = true
            iconImgV.addGestureRecognizer(gr)
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
        let views :[String : UIView] = ["title": titleLbl, "icon": iconImgV]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[icon(40)]-(10)-[title]-(20)-|", options:[], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[icon(40)]-(10)-|", options:[], metrics: nil, views: views)
        layoutConstraints += [
            titleLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]   
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    //MARK:- Selectors
    @objc func changeImage() {
        guard let iconAction = action else {
            return
        }
        iconAction()
    }
}
