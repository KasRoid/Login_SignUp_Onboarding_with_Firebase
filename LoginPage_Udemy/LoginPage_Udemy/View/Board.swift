//
//  Board.swift
//  LoginPage_Udemy
//
//  Created by Kas Song on 2020.06.04.
//  Copyright © 2020 Kas Song. All rights reserved.
//

import UIKit

final class Board: UIView {
    
    // MARK: - Properties
    let firstLineStack = UIStackView()
    let secondLineStack = UIStackView()
    let thirdLineStack = UIStackView()
    let fourthLineStack = UIStackView()
    lazy var boardInStackView = [firstLineStack, secondLineStack, thirdLineStack, fourthLineStack]
    
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    
    // MARK: - Methods
    func removeAllSubviews() {
        for stack in boardInStackView {
            for view in stack.subviews {
                stack.removeArrangedSubview(view)
            }
        }
    }

    
    // MARK: - Setup UI
    func configureUI() {
        boardInStackView.forEach {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 15
        }
        
        let finalStack = UIStackView(arrangedSubviews: [firstLineStack, secondLineStack, thirdLineStack, fourthLineStack])
        finalStack.axis = .vertical
        finalStack.alignment = .fill
        finalStack.distribution = .fillEqually
        finalStack.spacing = 25
        
        addSubview(finalStack)
        finalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            finalStack.topAnchor.constraint(equalTo: topAnchor),
            finalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            finalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            finalStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
