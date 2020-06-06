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
    let sizeConfiguration = UIImage.SymbolConfiguration(scale: .large)
    lazy var cardLogo = UIImage(systemName: "tornado", withConfiguration: sizeConfiguration)
    static let maxTry = 30
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
    var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return button
    }()
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
    
    // 카드를 생성하여 array 에 할당
    func generateCards() {
        for _ in 1...numberOfCards / 2 {
            for _ in 1...2 {
                generateCardImage()
                let pairOfCards = Cards()
                pairOfCards.addTarget(self, action: #selector(cardPressed(_:)), for: .touchUpInside)
                pairOfCards.label.text = currentImage
                pairOfCards.logoIamgeView.image = cardLogo
                pairOfCards.tag = buttonTag
                buttonTag += 1
                cardIsNotFlipped(card: pairOfCards)
                arrayOfCards.append(pairOfCards)
            }
        }
    }
    
    func setupStackView() {
        for stack in arrayOfHorizontalStacks {
            for _ in 1...numberOfCards / arrayOfHorizontalStacks.count {
                stack.addArrangedSubview(arrayOfCards[cardNumber])
                cardNumber += 1
            }
        }
    }
    
    func cardIsFlipped(card: Cards) {
        UIView.transition(with: card,
                          duration: 0.4,
                          options: .transitionFlipFromRight,
                          animations: nil,
                          completion: nil)
        card.label.alpha = 1
        card.logoIamgeView.alpha = 0
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
        UIView.transition(with: card,
                          duration: 0.4,
                          options: .transitionFlipFromLeft,
                          animations: nil,
                          completion: nil)
        card.label.alpha = 0
        card.logoIamgeView.alpha = 1
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
    
    func removeSubviews() {
        for stack in arrayOfHorizontalStacks {
            for view in stack.subviews {
                stack.removeArrangedSubview(view)
            }
        }
    }
    
    func gameOver() {
        print("ResetButton Pressed")
        arrayOfCards.removeAll()
        pairOfCardImages = cardImages + cardImages
        cardNumber = 0
        stackCounter = 0
        currentImage = ""
        imageOfFirstCard = ""
        imageOFSecondCard = ""
        flippedCardCounter = 0
        buttonTag = 0
        removeSubviews()
        print("Number of Subviews in Stack \(firstLineStack.subviews.count)")
        generateCards()
        setupStackView()
        for card in arrayOfCards {
            card.alpha = 1
        }
        userTried = 0
        HomeViewController.score.text = "\(userTried) / \(Board.maxTry)"
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "게임오버", message: "다음에는 성공할 수 있을거에요!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "확인",
            style: .cancel))
        let VC = HomeViewController()
        VC.present(alert, animated: true, completion: { print("Alert Alert Alert") })
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
    
    
    // MARK: Button Actions
    @objc func cardPressed(_ sender: Cards) {
        guard flippedCardCounter < 2 else { print("Guard Activated"); return }
        if sender.isFlipped == false { // 카드가 뒤집어져있으면...
            cardIsFlipped(card: sender) // 카드를 뒤집는다.
            flippedCardCounter += 1
        }
        print(flippedCard)
        if flippedCardCounter == 2 {
            userTried += 1
            HomeViewController.score.text = "\(userTried) / \(Board.maxTry)"
            if userTried == Board.maxTry {
                showAlert()
                print("CONDITION: Game Over")
            }
            print("UserTried \(userTried) times")
        }
        checkAnswer()
        if flippedCardCounter == 2 {
            resetMemory()
        }
    }
    
    @objc func resetGame(_ sender: UIButton) {
        print("ResetButton Pressed")
        arrayOfCards.removeAll()
        pairOfCardImages = cardImages + cardImages
        cardNumber = 0
        stackCounter = 0
        currentImage = ""
        imageOfFirstCard = ""
        imageOFSecondCard = ""
        flippedCardCounter = 0
        buttonTag = 0
        removeSubviews()
        print("Number of Subviews in Stack \(firstLineStack.subviews.count)")
        generateCards()
        setupStackView()
        for card in arrayOfCards {
            card.alpha = 1
        }
        userTried = 0
        HomeViewController.score.text = "\(userTried) / \(Board.maxTry)"
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
        
        generateCards()
        setupStackView()
        resetButton.addTarget(self, action: #selector(resetGame(_:)), for: .touchUpInside)
        
        
        // MARK: - AutoLayout
        let finalStack = UIStackView(arrangedSubviews: [firstLineStack, secondLineStack, thirdLineStack, fourthLineStack, resetButton])
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
