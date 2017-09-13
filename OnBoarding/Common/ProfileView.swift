//
//  ProfileView.swift
//  OnBoarding
//
//  Created by mmaalej on 13/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

let imageSize = CGSize(width: 40.0, height: 40.0)

class ProfileView: UIView {
    
    //MARK:- Properties
    var data : (name: String?, profileImage: UIImage?, profileImageAction: (()->())?)? {
        didSet {
            let scaledImage = data?.profileImage?.scale(size: imageSize)
            profileImgV.image = scaledImage
            nameLbl.text = data?.name
            guard let imgAction = data?.profileImageAction else {
                return
            }
            profileImageAction = imgAction
            let gr = UITapGestureRecognizer(target: self, action: #selector(changeImage))
            profileImgV.isUserInteractionEnabled = true
            profileImgV.addGestureRecognizer(gr)
        }
    }
    
    var profileImageAction: (()->())?
    
    private let profileImgV: UIImageView = {
        let imageView  = UIImageView()
        imageView.frame.size = CGSize (width: 40.0, height: 40.0)
        imageView.contentMode = .scaleAspectFit
        imageView.rounded()
        return imageView
    }()
    
    private let nameLbl: UILabel = {
        let label = UILabel()
        return label
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
        let views :[String : UIView] = ["name": nameLbl, "profile": profileImgV]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[profile(40)]-(10)-[name]-(20)-|", options:[], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[profile(40)]-(10)-|", options:[], metrics: nil, views: views)
        layoutConstraints += [
            nameLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    //MARK:- Selectors
    @objc func changeImage() {
        guard let action = profileImageAction else {
            return
        }
        action()
    }
}
