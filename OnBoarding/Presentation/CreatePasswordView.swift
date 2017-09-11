//
//  CreatePasswordView.swift
//  OnBoarding
//
//  Created by mmaalej on 11/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class CreatePasswordView: UIView {
    
    //MARK: properties
    private let welcomeLbl: UILabel = {
        let label = UILabel()
        label.text = "Welcome To Cognizant"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let line1ImgV: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let iconImgV: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Logo")
        return imageView
    }()
    
    private let passTxtF: UITextField = {
        let textField = UITextField ()
        textField.placeholder = "Enter a password"
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(7.0, 0.0, 0.0)
        textField.layer.cornerRadius = 5.0
        return textField
    }()
    
    private let repatPassTxtF: UITextField = {
        let textField = UITextField ()
        textField.placeholder = "Enter a password"
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(7.0, 0.0, 0.0)
        textField.layer.cornerRadius = 5.0
        return textField
    }()
    
    private let passwordTxtF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Repeat your password"
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(7.0, 0.0, 0.0)
        textField.layer.cornerRadius = 5.0
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Log in", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor.buttonColor
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    //MARK:- init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.bgColor
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["welcome": welcomeLbl, "line": line1ImgV, "logo": iconImgV, "pass": passTxtF, "repeatPass": repatPassTxtF, "login": loginBtn]
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += [
            welcomeLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            line1ImgV.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iconImgV.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(60)-[login]-(60)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[line(100)]", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[pass]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[repeatPass]-(10)-|", options: [], metrics: nil, views: views)

        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(55)-[welcome]-(15)-[line(2)]-(15)-[logo]-(30)-[pass(30)]-(10)-[repeatPass(30)]-(40)-[login]", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
}

