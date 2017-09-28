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
    var loginAction: ((String, String)->())?
    var createPasswordAction: (() -> ())?
    var requestIDAction: (() ->())?
    
    private let welcomeLbl: UILabel = {
        let label = UILabel()
        label.text = "Welcome To Cognizant"
        let font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
        label.font = font
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
    
 let idTxtF: UITextField = {
        let textField = UITextField ()
        textField.placeholder = "Associate ID"
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(7.0, 0.0, 0.0)
        textField.layer.cornerRadius = 5.0
        return textField
    }()
    
     let passwordTxtF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(7.0, 0.0, 0.0)
        textField.layer.cornerRadius = 5.0
        textField.isSecureTextEntry = true
        return textField
    }()
    
     let remainConnectedLbl: UILabel = {
        let label = UILabel()
        label.text = "Remain connected"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private let remainConnectedSwt: UISwitch = {
        let switchButton = UISwitch ()
        switchButton.isOn = true
        switchButton.onTintColor = UIColor.buttonColor
        switchButton.tintColor = .gray
        return switchButton
    }()
    
    private let loginBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Log in", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor.buttonColor
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    
    private let line2ImgV: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        return imageView
    }()
    
    
    private let createPasswordBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Create a password", for: .normal)
        button.backgroundColor = UIColor.buttonColor
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(createPassowrd), for: .touchUpInside)
        return button
    }()
    
    private let requestIdBtn: UIButton = {
        let button = UIButton()
        button.setTitle("I do not have an ID yet", for: .normal)
        button.backgroundColor = UIColor.buttonColor
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(requestID), for: .touchUpInside)
        return button
    }()
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(patternImage: UIImage(named: "Background.png")!)
        self.layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["welcome": welcomeLbl, "line": line1ImgV, "icon": iconImgV, "id": idTxtF, "password": passwordTxtF, "remainConntectedLabel": remainConnectedLbl, "reaminConnectedButton": remainConnectedSwt, "login": loginBtn, "line2": line2ImgV, "createPassword": createPasswordBtn, "requestID": requestIdBtn]
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += [
            welcomeLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            line1ImgV.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iconImgV.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            remainConnectedSwt.centerYAnchor.constraint(equalTo: remainConnectedLbl.centerYAnchor),
            line2ImgV.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ]
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[line(150)]", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[id]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[password]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[remainConntectedLabel]-(>=10)-[reaminConnectedButton]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(60)-[login]-(60)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[line2(100)]", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[createPassword]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[requestID]-(10)-|", options: [], metrics: nil, views: views)
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(79)-[welcome]-(15)-[line(2)]-(15)-[icon]-(30)-[id(35)]-(10)-[password(35)]-(15)-[remainConntectedLabel]-(40)-[login]-(>=15)-[line2(2)]-(20)-[createPassword]-(15)-[requestID]-(>=20)-|", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    //MARK:- Selectors
    @objc func createPassowrd() {
        guard let action = createPasswordAction else {
            return
        }
        action()
    }
    
    @objc func requestID() {
        guard let action = requestIDAction else {
            return
        }
        action()
    }
    
    @objc func login() {
        guard let action = loginAction else {
            return
        }
        guard idTxtF.text != "" , idTxtF.text  != "" else {
            return
        }
        action(self.idTxtF.text!, self.idTxtF.text!)
    }
}
