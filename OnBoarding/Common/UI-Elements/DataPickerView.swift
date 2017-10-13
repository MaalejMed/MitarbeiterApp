//
//  DataPickerView.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class DataPickerView: UIView {
    
    //MARK:- Properties
    let pickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let doneBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor.buttonColor
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(done), for: .touchUpInside)
        return button
    }()
    
    let titleLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private let cancelBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.sizeToFit()
        button.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor.buttonColor
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    
    private let lineImgV: UIImageView = {
        let line = UIImageView()
        line.backgroundColor =  .gray
        return line
    }()
    
    var dataSource: [String]? {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    var doneButtonAction: ((_ selectedItem: String)->())?
    var cancelButtonAction: (()->())?
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        pickerView.delegate = self
        pickerView.dataSource = self
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views:[String: UIView] = ["cancel": cancelBtn, "title": titleLbl, "done": doneBtn, "picker": pickerView, "line": lineImgV]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }

        var layoutConstrainsts: [NSLayoutConstraint] = []
        
        layoutConstrainsts += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[cancel(80)]-(10)-[title]-(10)-[done(80)]-(10)-|", options: [], metrics: nil, views: views)
         layoutConstrainsts += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[line]-(0)-|", options: [], metrics: nil, views: views)
        layoutConstrainsts += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[done]", options: [], metrics: nil, views: views)
        layoutConstrainsts += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[cancel]", options: [], metrics: nil, views: views)
        layoutConstrainsts += [
            titleLbl.centerYAnchor.constraint(equalTo: cancelBtn.centerYAnchor)
        ]
         layoutConstrainsts += NSLayoutConstraint.constraints(withVisualFormat: "V:[cancel]-(10)-[line(2)]-[picker]-(0)-|", options: [], metrics: nil, views: views)
         layoutConstrainsts += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[picker]-(10)-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(layoutConstrainsts)
    }
    
    //MARK:- Selectors
    @objc func done() {
        guard let action = doneButtonAction else {
            return
        }
        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        
        guard let value = dataSource?[selectedIndex] else {
            return
        }
        action(value)
    }
    
    @objc func cancel() {
        guard let action = cancelButtonAction else {
            return
        }
        action()
    }
}

extension DataPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (dataSource?.count != nil) ?  (dataSource?.count)! : 0
    }
}

extension DataPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource?[row]
    }
}
