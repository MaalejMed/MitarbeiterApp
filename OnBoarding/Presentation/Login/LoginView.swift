//
//  LoginView.swift
//  OnBoarding
//
//  Created by mmaalej on 08/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    //MARK:- Properties
    let welcomeL: UILabel = {
        let label = UILabel()
        label.text = "Welcome To Cognizant"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let line1IV: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        return imageView
    }()
    
    let iconIV: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Logo")
        return imageView
    }()
    
    let idTF: UITextField = {
        let textField = UITextField ()
        textField.placeholder = "Associate ID"
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(7.0, 0.0, 0.0)
        textField.layer.cornerRadius = 5.0
        return textField
    }()
    
    let passwordTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(7.0, 0.0, 0.0)
        textField.layer.cornerRadius = 5.0
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let remainConnectedL: UILabel = {
        let label = UILabel()
        label.text = "Remain connected"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    let remainConnectedS: UISwitch = {
        let switchButton = UISwitch ()
        switchButton.isOn = true
        switchButton.onTintColor = UIColor.buttonColor
        switchButton.tintColor = .gray
        return switchButton
    }()
    
    let loginB: UIButton = {
        let button = UIButton()
        button.setTitle("Log in", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor.buttonColor
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    let line2IV: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        return imageView
    }()
    
    
    let createPasswordB: UIButton = {
        let button = UIButton()
        button.setTitle("Create a password", for: .normal)
        button.backgroundColor = UIColor.buttonColor
        return button
    }()
    
    let generateIdB: UIButton = {
        let button = UIButton()
        button.setTitle("I do not have an ID yet", for: .normal)
        button.backgroundColor = UIColor.buttonColor
        return button
    }()
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.bgColor
        self.layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["welcome": welcomeL, "line": line1IV, "icon": iconIV, "id": idTF, "password": passwordTF, "remainConntectedLabel": remainConnectedL, "reaminConnectedButton": remainConnectedS, "login": loginB, "line2": line2IV, "createPassword": createPasswordB, "generateID": generateIdB]
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += [
            welcomeL.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            line1IV.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iconIV.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            remainConnectedS.centerYAnchor.constraint(equalTo: remainConnectedL.centerYAnchor),
            line2IV.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ]
    
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[line(100)]", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[id]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[password]-(10)-|", options: [], metrics: nil, views: views)
         layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[remainConntectedLabel]-(>=10)-[reaminConnectedButton]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[login]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[line2(100)]", options: [], metrics: nil, views: views)
         layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[createPassword]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[generateID]-(10)-|", options: [], metrics: nil, views: views)
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(55)-[welcome]-(15)-[line(2)]-(15)-[icon]-(30)-[id(30)]-(10)-[password(30)]-(15)-[remainConntectedLabel]-(15)-[login]-(>=15)-[line2(2)]-(20)-[createPassword]-(15)-[generateID]-(>=20)-|", options: [], metrics: nil, views: views)

        NSLayoutConstraint.activate(layoutConstraints)
    }
}
