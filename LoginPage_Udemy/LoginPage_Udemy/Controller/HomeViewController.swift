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
    private lazy var score: UILabel = {
        let label = UILabel()
        label.text = cardGameBrain.turnsLeft
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.sizeToFit()
        return label
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
            return score.text ?? cardGameBrain.turnsLeft
        }
        set {
            score.text = newValue
        }
    }
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
        initailizeCardGame()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    @objc func handleResetButton(_ sender: UIButton) {
        cardGameBrain = CardGameBrain()
        gameBoard = Board()
        configureUI()
        initailizeCardGame()
        turnsLeft = updateTurns()
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
        configureGradientBackground()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Card Nil"
        
        let image = UIImage(systemName: "arrow.left")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        
        [gameBoard, score, resetButton].forEach { view.addSubview($0); $0.translatesAutoresizingMaskIntoConstraints = false }
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            gameBoard.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 55),
            gameBoard.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 35),
            gameBoard.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -35),
            gameBoard.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -85),
            
            score.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: -(score.frame.height * 1.4)),
            score.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            
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
        var counter = 0
        for subview in gameBoard.boardInStackView {
            while subview.arrangedSubviews.count < 4 {
                subview.addArrangedSubview(card[counter])
                card[counter].addTarget(self, action: #selector(cardSelected(_:)), for: .touchUpInside)
                counter += 1
            }
        }
    }
    
    private func unflipAllCards() {
        let parentStack = gameBoard.boardInStackView
        for childStack in parentStack {
            for view in childStack.subviews {
                guard let card = view as? Cards else { return }
                card.isFlipped = false
            }
        }
    }
    
    private func updateTurns() -> String {
        return cardGameBrain.turnsLeft
    }
}
