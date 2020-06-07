//
//  Cards.swift
//  LoginPage_Udemy
//
//  Created by Kas Song on 2020.06.04.
//  Copyright © 2020 Kas Song. All rights reserved.
//

import UIKit

final class Cards: UIButton {
    
    // MARK: - Properties
    let label = UILabel()
    let logoIamgeView = UIImageView()
    // 카드 색상조절
    private let frontColor = UIColor.white
    private let backColor = UIColor.orange
    // 카드의 뒤집힘 상태
    var isFlipped = true {
        didSet {
            flipActions()
        }
    }
    var number = 0
    private let sizeConfiguration = UIImage.SymbolConfiguration(scale: .large)
    private lazy var cardBackLogo = UIImage(systemName: "tornado")?.withTintColor(.red, renderingMode: .alwaysOriginal).withConfiguration(sizeConfiguration)
    
    // MARK: - LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        let sizeOfFontOnCards: CGFloat = 35
        
        layer.borderWidth = 1.0
        layer.cornerRadius = 10
        
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: sizeOfFontOnCards)
        
        logoIamgeView.image = cardBackLogo
        
        [label, logoIamgeView].forEach { addSubview($0) }
        label.centerX(inView: self)
        label.centerY(inView: self)
        logoIamgeView.centerX(inView: self)
        logoIamgeView.centerY(inView: self)
        
        flipActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Methods
    private func flipActions() {
        backgroundColor = isFlipped ? frontColor : backColor
        label.alpha = isFlipped ? 1 : 0
        logoIamgeView.alpha = isFlipped ? 0 : 1
        isFlipped ? flipToBack() : flipToFront()
    }
    
    private func flipToFront() {
        UIView.transition(
            with: self,
            duration: 0.4,
            options: .transitionFlipFromLeft,
            animations: nil,
            completion: nil)
    }
    
    private func flipToBack() {
        UIView.transition(
            with: self,
            duration: 0.4,
            options: .transitionFlipFromRight,
            animations: nil,
            completion: nil)
    }
}
