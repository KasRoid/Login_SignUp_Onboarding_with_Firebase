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
    let numberOfCards = 16
    let cardImages: [String] = ["😍", "🐸", "🍎", "⚽️", "🍔", "🍟", "👻", "💋"]
    lazy var pairOfCardImages = cardImages + cardImages
    var userTried = 0
    var arrayOfCards: [Cards] = []
    var cardNumber = 0
    var stackCounter = 0
    var currentImage = ""
    var imageOfFirstCard = ""
    var imageOFSecondCard = ""
    var flippedCardCounter = 0
    var buttonTag = 0
    var flippedCard: [Int] = []
    let firstLineStack = UIStackView()
    let secondLineStack = UIStackView()
    let thirdLineStack = UIStackView()
    let fourthLineStack = UIStackView()
    lazy var arrayOfHorizontalStacks = [firstLineStack, secondLineStack, thirdLineStack, fourthLineStack]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    func generateCardImage() {
        guard let cardImage = pairOfCardImages.randomElement() else { return }
        pairOfCardImages.remove(at: pairOfCardImages.firstIndex(of: cardImage)!)
        currentImage = cardImage
    }
    
    func cardIsFlipped(card: Cards) {
        card.label.alpha = 1
        card.backgroundColor = .white
        card.isFlipped = true // 카드의 뒤집힘 상태를 true 로 변경
        flippedCard.append(card.tag) // 뒤집힌 카드를 기억하기 위한 버튼 태그 저장
        print(imageOfFirstCard.isEmpty)
        if imageOfFirstCard.isEmpty {
            print("Image inserted in First card")
            imageOfFirstCard = card.label.text!
        }
        else {
            print("Image inserted in Second card")
            imageOFSecondCard = card.label.text!
        }
    }
    
    func cardIsNotFlipped(card: Cards) {
        card.label.alpha = 0
        card.backgroundColor = .orange
        card.isFlipped = false
    }
    
    func resetMemory() {
        imageOfFirstCard = ""
        imageOFSecondCard = ""
    }
    
    func removeCards(_ card: Cards) {
        card.alpha = 0
    }
    
    func checkAnswer() {
        guard flippedCardCounter < 3 else { print("check answer guard"); return }
        if imageOfFirstCard == imageOFSecondCard { // 같은 카드를 뽑았다면...
            // 카드 사라지기 구현
            print("Correct!!")
            flippedCardCounter = 0
            for tag in flippedCard {
                for card in arrayOfCards {
                    if card.tag == tag {
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + 1.3,
                            execute: {
                                self.removeCards(card)
                                self.flippedCardCounter = 0
                                self.flippedCard.remove(at: self.flippedCard.firstIndex(of: tag)!)
                        })
                    }
                }
            }
        }
        else if flippedCard.count == 2 { // 두장이 다른 카드라면...
            // 카드 뒤집기
            print("Different Cards")
            for tag in flippedCard {
                for card in arrayOfCards {
                    if card.tag == tag {
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + 1.3,
                            execute: {
                                self.cardIsNotFlipped(card: card)
                                self.flippedCardCounter = 0
                                self.flippedCard.remove(at: self.flippedCard.firstIndex(of: tag)!)
                        })
                    }
                }
            }
        }
    }
    
    
    // MARK: Button Action
    @objc func cardPressed(_ sender: Cards) {
        guard flippedCardCounter < 2 else { print("Guard Activated"); return }
        if sender.isFlipped == false { // 카드가 뒤집어져있으면...
            cardIsFlipped(card: sender) // 카드를 뒤집는다.
            flippedCardCounter += 1
        }
        print(flippedCard)
        checkAnswer()
        if flippedCardCounter == 2 {
            userTried += 1
            print("UserTried \(userTried) times")
            resetMemory()
        }
    }
    
    
    // MARK: - Design
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Setup Stacks
        arrayOfHorizontalStacks.forEach {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 15
        }
        
        // 카드를 생성해서 array 에 할당
        for _ in 1...numberOfCards / 2 {
            for _ in 1...2 {
                generateCardImage()
                let pairOfCards = Cards()
                pairOfCards.addTarget(self, action: #selector(cardPressed(_:)), for: .touchUpInside)
                pairOfCards.label.text = currentImage
                pairOfCards.tag = buttonTag
                buttonTag += 1
                cardIsNotFlipped(card: pairOfCards)
                arrayOfCards.append(pairOfCards)
            }
        }
        
        // 생성된 카드를 각 스택뷰에 할당
        for stack in arrayOfHorizontalStacks {
            for _ in 1...numberOfCards / arrayOfHorizontalStacks.count {
                stack.addArrangedSubview(arrayOfCards[cardNumber])
                cardNumber += 1
            }
        }
        
        
        // MARK: - AutoLayout
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
