//
//  CardGameBrain.swift
//  LoginPage_Udemy
//
//  Created by Kas Song on 2020.06.06.
//  Copyright © 2020 Kas Song. All rights reserved.
//

import Foundation

struct CardGameBrain {
    
    // MARK: - Properties
    private let cardImages: [String] = ["😍", "🐸", "🍎", "⚽️", "🍔", "🍟", "👻", "💋","🐶","🍋","🥑","🥦","🥨","🧀","🍖","🌯","🌮","🥘","🍣","🍱","🏓","🪀","🏹","🛩","🐣","🦄","🔥"]
    private var randomlySelectedImages: Set<String> = [] // 게임에 사용될 이미지를 난이도에 맞게 랜덤으로 할당받을 array
    var inGameCards: [Cards] = [] // 게임에서 사용될 카드들
    var numberOfClearedCards = 0 //
    var difficulty: GameModes
    private lazy var selectedDifficulty: Int = difficulty.chooseGameModes()
    private lazy var numberOfImagesToCreateCards = selectedDifficulty / 2
    lazy var numberOfLinesNeedToPlaceCards = inGameCards.count / 4
    private let gameOverCondition = 20
    private var userHasTried: Int = 0 {
        didSet {
            turnsLeft = "\(userHasTried) / \(gameOverCondition)"
        }
    }
    private var cardNumber = 0
    var imagesThatUserHasChosen: [String] = []
    private var flippedCardNumber: [Int] = []
    lazy var turnsLeft: String = "\(userHasTried) / \(gameOverCondition)"
    
    
    // MARK: - Initailizers
    init() {
        difficulty = .expert
    }
    
    init(gameMode: GameModes) {
        difficulty = gameMode
    }
    
    
    // MARK: - Methods
    mutating func generateGameInfo() {
        generateCardsWithImage()
        print("Number of Images: \(inGameCards.count)")
    }

    
    mutating func flipCard(_ card: Cards) {
        guard flippedCardNumber.count < 2, !card.isFlipped else { print("func flipCard Guard"); return }
        card.isFlipped = true
        saveUsersChoice(card)
    }
    
    mutating func unflipCard(_ board: Board) {
        guard countSelectedCards() == 2 else { print("DEBUG: func unflipCard Guard"); return }
        let firstCardNumber = flippedCardNumber[0]
        let secondCardNumber = flippedCardNumber[1]
        let parentStack = board.arrayOfStackViews
        for childStack in parentStack {
            for view in childStack.subviews {
                guard let card = view as? Cards else { return }
                if card.number == firstCardNumber || card.number == secondCardNumber {
                    card.isFlipped = false
                }
            }
        }
        deleteUsersChoice()
    }
    
    mutating func removeCardsFromTheBoard(_ board: Board) {
        guard countSelectedCards() == 2 else { print("DEBUG: func removeCardsFromTheBoard Guard"); return }
        let firstCardNumber = flippedCardNumber[0]
        let secondCardNumber = flippedCardNumber[1]
        let parentStack = board.arrayOfStackViews
        for childStack in parentStack {
            for view in childStack.subviews {
                guard let card = view as? Cards else { return }
                if card.number == firstCardNumber || card.number == secondCardNumber {
                    card.alpha = 0
                }
            }
        }
        numberOfClearedCards += 1
        deleteUsersChoice()
    }
    
    
    func countSelectedCards() -> Int {
        return flippedCardNumber.count
    }
    
    mutating func checkAnswer() -> Bool {
        guard imagesThatUserHasChosen.count == 2 else { print("DEBUG: Check Answer Guard, Selected card: \(imagesThatUserHasChosen.count)"); return false }
        userHasTried += 1
        let imageInFirstCard = imagesThatUserHasChosen[0]
        let imageInSecondCard = imagesThatUserHasChosen[1]
        return imageInFirstCard == imageInSecondCard
    }
    
    mutating func resetGame() {
        deleteUsersChoice()
        userHasTried = 0
    }
    
    func turnsLeftTillGameOver() -> Int {
        return gameOverCondition - userHasTried
    }
    
    func gameCleared() -> Bool {
        return numberOfClearedCards >= randomlySelectedImages.count
    }
    
    func gameOver() -> Bool {
        return userHasTried >= gameOverCondition
    }
    
    
    // MARK: - Private Methods
    private func checkModes() {
        
    }
    
    private mutating func chooseCardImagesFromImageList() {
        while randomlySelectedImages.count < numberOfImagesToCreateCards {
            randomlySelectedImages.insert(cardImages.randomElement() ?? "")
        }
    }
    
    private mutating func generateCardsWithImage() {
        chooseCardImagesFromImageList()
        var imagesForCards = Array(randomlySelectedImages) + Array(randomlySelectedImages)
        for _ in 1...imagesForCards.count {
            let card = Cards()
            let image = imagesForCards.randomElement() ?? ""
            card.label.text = image
            card.number = cardNumber // 카드 구분을 위한 변수
            card.isHidden = false
            cardNumber += 1
            inGameCards.append(card)
            imagesForCards.remove(at: imagesForCards.firstIndex(of: image) ?? 0)
        }
        cardNumber = 0 // 여러 상황에서 카드가 새롭게 생성되어야 할 때 카드가 다시 0 번부터 생성될 수 있도록 초기화
    }
    
    private mutating func saveUsersChoice(_ card: Cards) {
        flippedCardNumber.append(card.number)
        imagesThatUserHasChosen.append(card.label.text ?? "")
    }
    
    private mutating func deleteUsersChoice() {
        flippedCardNumber.removeAll()
        imagesThatUserHasChosen.removeAll()
    }
}
