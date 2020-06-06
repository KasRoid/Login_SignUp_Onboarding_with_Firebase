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
    private var gameBoard = Board()
    static var score: UILabel = {
        let label = UILabel()
        label.text = "0 / \(Board.maxTry)"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.sizeToFit()
        return label
    }()
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
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
        
        
        
        // 여기서부터 복사
        
        
        [gameBoard, HomeViewController.score].forEach { view.addSubview($0) }
        [gameBoard, HomeViewController.score].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            gameBoard.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            gameBoard.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 35),
            gameBoard.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -35),
            gameBoard.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0),
            
            //            score.topAnchor.constraint(equalTo: view.topAnchor, constant: 99),
            HomeViewController.score.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: -(HomeViewController.score.frame.height * 1.4)),
            HomeViewController.score.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
        ])
    }
}
