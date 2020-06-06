//
//  Cards.swift
//  LoginPage_Udemy
//
//  Created by Kas Song on 2020.06.04.
//  Copyright © 2020 Kas Song. All rights reserved.
//

import UIKit

final class Cards: UIButton {
    
    let label = UILabel()
    var isFlipped = false
    let logoIamgeView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let sizeOfFontOnCards: CGFloat = 35
        
        layer.borderWidth = 1.0
        layer.cornerRadius = 10
        backgroundColor = .white
        
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: sizeOfFontOnCards)
        
        addSubview(label)
        label.centerX(inView: self)
        label.centerY(inView: self)
        
        addSubview(logoIamgeView)
        logoIamgeView.centerX(inView: self)
        logoIamgeView.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
