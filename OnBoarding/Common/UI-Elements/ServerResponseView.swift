//
//  ServerResponseView.swift
//  OnBoarding
//
//  Created by mmaalej on 18/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class ServerResponseView: UIView {
    
    //MARK:- Properties
    private let iconImgV: UIImageView = {
        let imageView  = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let descriptionLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = .black
        label.sizeToFit()
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
        let views :[String : UIView] = ["description": descriptionLbl, "icon": iconImgV]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += [
            descriptionLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            descriptionLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImgV.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[icon(20)]-(10)-[description]", options:[], metrics: nil, views: views)
       
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    //MARK:-
    func present(serverResponse: ServerResponse) {
        setup(serverResponse: serverResponse)
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leftAnchor.constraint(equalTo: window.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: window.rightAnchor).isActive = true
        self.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: window.topAnchor, constant: 60.0).isActive = true
        self.backgroundColor = UIColor.BgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.removeFromSuperview()
        })
    }
    
    func setup(serverResponse: ServerResponse) {
        switch serverResponse.code {
        case .success:
            self.iconImgV.image = UIImage.init(named: "Done")!
        case .badRequest, .unauthorizedAccess, .unknown, .serviceUnavailable, .notFound:
            self.iconImgV.image = UIImage.init(named: "Failure")!
        }
        descriptionLbl.text = serverResponse.description
    }
}
