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
    let fifthLineStack = UIStackView()
    private var numberOfLinesNeedToCreate = 0
    lazy var arrayOfStackViews = [firstLineStack, secondLineStack, thirdLineStack, fourthLineStack, fifthLineStack]
    let gameBoardStackView = UIStackView()
    
    
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
    
    
    // MARK: - UI
    private func configureUI() {
        arrayOfStackViews.forEach {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 13
        }
        
        arrangeSubviewsToGameBoardStackView()
        gameBoardStackView.axis = .vertical
        gameBoardStackView.alignment = .fill
        gameBoardStackView.distribution = .fillEqually
        gameBoardStackView.spacing = 18
        
        addSubview(gameBoardStackView)
        gameBoardStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameBoardStackView.topAnchor.constraint(equalTo: topAnchor),
            gameBoardStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gameBoardStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gameBoardStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func arrangeSubviewsToGameBoardStackView() {
        for line in 0..<numberOfLinesNeedToCreate {
            gameBoardStackView.addArrangedSubview(arrayOfStackViews[line])
        }
    }
}

extension Board: HomeViewControllerDelegate {
    func sendNumberOfLinesNeeded(lines: Int) {
        numberOfLinesNeedToCreate = lines
    }
}
