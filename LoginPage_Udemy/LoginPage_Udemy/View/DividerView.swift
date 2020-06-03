//
//  DividerView.swift
//  LoginPage_Udemy
//
//  Created by Kas Song on 2020.06.03.
//  Copyright © 2020 Kas Song. All rights reserved.
//

import UIKit

class DividerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel()
        label.text = "OR"
        label.textColor = UIColor(white: 1, alpha: 0.87)
        label.font = UIFont.systemFont(ofSize: 14)
        
        addSubview(label)
        label.centerX(inView: self)
        label.centerY(inView: self)
        
        let divider1 = UIView()
        divider1.backgroundColor = UIColor(white: 1, alpha: 0.25)
        addSubview(divider1)
        divider1.centerY(inView: self)
        divider1.anchor(left: leftAnchor, right: label.leftAnchor, paddingLeft: 8, paddingRight: 8, height: 1.0)
        
        let divider2 = UIView()
        divider2.backgroundColor = UIColor(white: 1, alpha: 0.25)
        addSubview(divider2)
        divider2.centerY(inView: self)
        divider2.anchor(left: label.rightAnchor, right: rightAnchor, paddingLeft: 8, paddingRight: 8, height: 1.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
