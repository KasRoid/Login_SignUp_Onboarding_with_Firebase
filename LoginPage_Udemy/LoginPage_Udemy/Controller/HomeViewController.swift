//
//  HomeViewController.swift
//  LoginPage_Udemy
//
//  Created by Kas Song on 2020.06.03.
//  Copyright © 2020 Kas Song. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private var cardGameBrain = CardGameBrain()
    private var gameBoard = Board()
    weak var delegate: HomeViewControllerDelegate?
    private lazy var score: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(cardGameBrain.turnsLeft, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        button.addTarget(self, action: #selector(handleScoreButton(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleResetButton(_:)), for: .touchUpInside)
        return button
    }()
    private var turnsLeft: String {
        get {
            return String(cardGameBrain.turnsLeftTillGameOver()) // 유저에게 몇 번의 기회가 남았는지를 돌려준다.
        }
        set {
            print("Setting up Score...", newValue)
            score.titleLabel?.text = newValue // turn 레이블 업데이트
            score.setTitle(newValue, for: .normal)
        }
    }
    private lazy var horizontalNumberOfLinesNeededToPlaceCards = cardGameBrain.numberOfLinesNeedToPlaceCards
    private var currentGameMode: GameModes = .expert // 유저가 선택한 게임모드를 저장
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
        initailizeCardGame()
        configureUI()
    }

    
    // MARK: - Selector
    @objc func handleLogout() {
        let alert = UIAlertController(title: nil, message: "정말 로그아웃하시겠습니까?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            self.logout()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc func handleScoreButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "난이도 변경", message: "원하는 난이도를 선택해주세요", preferredStyle: .actionSheet)
        let easyAlertAction = UIAlertAction(title: "쉬움", style: .default, handler: { _ in self.currentGameMode = .easy; self.restartGame() })
        let hardAlertAction = UIAlertAction(title: "어려움", style: .default, handler: { _ in self.currentGameMode = .hard; self.restartGame() })
        let expertAlertAction = UIAlertAction(title: "매우 어려움", style: .default, handler: { _ in self.currentGameMode = .expert; self.restartGame();})
        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        [expertAlertAction, hardAlertAction, easyAlertAction, cancelAlertAction].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    @objc func handleResetButton(_ sender: UIButton) {
        restartGame()
    }
    
    @objc func cardSelected(_ card: Cards) {
        cardGameBrain.flipCard(card)
        guard cardGameBrain.countSelectedCards() == 2 else { print("Less than two card selected"); return } // 유저가 카드 2장을 오픈했다면...
        var result = false
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.10,
            execute: {
                result = self.cardGameBrain.checkAnswer()
                self.turnsLeft = self.updateTurns()
        })
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.75,
            execute: {
                print("Excute Performed, number of cards: \(self.cardGameBrain.countSelectedCards()), number of images: \(self.cardGameBrain.imagesThatUserHasChosen)")
                
                result ? self.cardGameBrain.removeCardsFromTheBoard(self.gameBoard) : self.cardGameBrain.unflipCard(self.gameBoard)
                self.turnsLeft = self.updateTurns()
        })
    }
    
    
    // MARK: - API
    func logout() {
        do {
            try Auth.auth().signOut()
            self.presentLoginController()
            print("Signed Out...")
        } catch {
            print("Error signing out")
        }
    }
    
    fileprivate func presentLoginController() {
        let controller = LoginController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                self.presentLoginController()
            }
            print("User not logged in...")
        } else {
            print("User is Logged in...")
        }
    }
    
    
    // MARK: - Helpers
    func configureUI() {
        sendDataToBoard()
        configureGradientBackground()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Card Nil"
        
        let image = UIImage(systemName: "arrow.left")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        
        let safeArea = view.safeAreaLayoutGuide
        let navigationBar = navigationController!.navigationBar
        [gameBoard, resetButton].forEach { view.addSubview($0); $0.translatesAutoresizingMaskIntoConstraints = false }
        navigationBar.addSubview(score)
        score.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameBoard.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 55),
            gameBoard.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 35),
            gameBoard.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -35),
            gameBoard.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -85),
            
            score.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -3),
            score.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -25),
            
            resetButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            resetButton.topAnchor.constraint(equalTo: gameBoard.bottomAnchor, constant: 30)
        ])
    }
    
    
    // MARK: - Private Methods
    private func initailizeCardGame() {
        cardGameBrain.generateGameInfo()
        arrangeCardsIntoSubviewsAndAddActions()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { self.unflipAllCards() })
    }
    
    private func arrangeCardsIntoSubviewsAndAddActions() {
        let card = cardGameBrain.inGameCards
        var imageCounter = 0
        var subviewCounter = 0
        for subview in gameBoard.arrayOfStackViews {
            subviewCounter += 1
            if subviewCounter > cardGameBrain.numberOfLinesNeedToPlaceCards {
                break
            }
            while subview.arrangedSubviews.count < 4 {
                subview.addArrangedSubview(card[imageCounter])
                card[imageCounter].addTarget(self, action: #selector(cardSelected(_:)), for: .touchUpInside)
                imageCounter += 1
            }
        }
    }
    
    private func unflipAllCards() {
        let parentStack = gameBoard.arrayOfStackViews
        for childStack in parentStack {
            for view in childStack.subviews {
                guard let card = view as? Cards else { return }
                card.isFlipped = false
            }
        }
    }
    
    private func updateTurns() -> String {
        guard cardGameBrain.gameCleared() == false else {
            let alert = UIAlertController(title: "Game Clear", message: "축하합니다!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "확인",
                style: .cancel,
                handler: {
                    _ in self.restartGame()
            }))
            present(alert, animated: true)
            return cardGameBrain.turnsLeft
        }
        guard cardGameBrain.gameOver() == false else {
            let alert = UIAlertController(title: "Game Over", message: "다음에는 꼭 성공할 수 있을거에요!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "확인",
                style: .cancel,
                handler: {
                    _ in self.restartGame()
            }))
            present(alert, animated: true)
            return cardGameBrain.turnsLeft }
        return cardGameBrain.turnsLeft
    }
    
    private func restartGame() {
        cardGameBrain = CardGameBrain(gameMode: currentGameMode)
        gameBoard = Board()
        configureUI()
        initailizeCardGame()
        turnsLeft = updateTurns()
    }
}


// MARK: - Extension
extension HomeViewController {
    private func sendDataToBoard() {
        self.delegate = gameBoard
        self.delegate?.sendNumberOfLinesNeeded(lines: horizontalNumberOfLinesNeededToPlaceCards)
    }
}


// MARK: - Delegate Protocol
protocol HomeViewControllerDelegate: class {
    func sendNumberOfLinesNeeded(lines: Int)
}
