//
//  RequestIDView.swift
//  OnBoarding
//
//  Created by mmaalej on 11/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class RequestIDView: UIView {
    
    //MARK: properties
    var closeButtonAction: (()->())?
    
    private let closeBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"Close"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    
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
    
    private let mailTxtF: UITextField = {
        let textField = UITextField ()
        textField.placeholder = "Enter your E-Mail address"
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(7.0, 0.0, 0.0)
        textField.layer.cornerRadius = 5.0
        return textField
    }()
    
    private let sendRequestBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Send request", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor.buttonColor
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    //Init
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(patternImage: UIImage(named: "Background.png")!)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["close":closeBtn, "welcome": welcomeLbl, "line": line1ImgV, "logo": iconImgV, "mail": mailTxtF, "sendRequest": sendRequestBtn]
        
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
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[close]", options: [], metrics: nil, views: views)

        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[line(150)]", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[mail]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(60)-[sendRequest]-(60)-|", options: [], metrics: nil, views: views)
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(30)-[close]-(25)-[welcome]-(15)-[line(2)]-(15)-[logo]-(30)-[mail(35)]-(40)-[sendRequest]", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    //MARK:- Buttons actions
    @objc func close() {
        guard let action = closeButtonAction else {
            return
        }
        action()
    }
}
