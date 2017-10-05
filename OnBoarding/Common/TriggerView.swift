//
//  TriggerView.swift
//  OnBoarding
//
//  Created by mmaalej on 05/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class TriggerView: UIView {
    
    //MARK:- Properties
    let activityInd: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        return indicator
    }()
    
    var status: Status? {
        didSet {
            didChangeStatus()
        }
    }
    
    let infoView = InfoView(frame:.zero)
    var data : (title: String?, icon: UIImage?, action: (()->())?)? {
        didSet {
            infoView.data = data
        }
    }
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout(contentView: activityInd)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout(contentView: UIView) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    //MARK:- Context
    func didChangeStatus() {
        switch status! {
        case .idle:
            presentInfoView()
        case .loading:
            presentActivityIndicator()
        }
    }
    
    //MARK:- Acitivity indicator
    func presentActivityIndicator() {
        dismissInfoView()
        layout(contentView: activityInd)
        activityInd.startAnimating()
    }
    
    func dismissActivityIndicator() {
        guard activityInd.superview != nil else {
            return
        }
        activityInd.stopAnimating()
        activityInd.removeFromSuperview()
    }
    
    //MARK:- Info View
    func presentInfoView() {
        dismissActivityIndicator()
        layout(contentView: infoView)
    }
    
    func dismissInfoView() {
        guard infoView.superview != nil else {
            return
        }
        activityInd.removeFromSuperview()
    }
}
