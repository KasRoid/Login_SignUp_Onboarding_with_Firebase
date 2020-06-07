//
//  GameModes.swift
//  LoginPage_Udemy
//
//  Created by Kas Song on 2020.06.06.
//  Copyright © 2020 Kas Song. All rights reserved.
//

import Foundation

enum GameModes {
    case easy
    case hard
    case expert
    
    func chooseGameModes() -> Int {
        switch self {
        case .easy:
            return 12
        case .hard:
            return 16
        case .expert:
            return 20
        }
    }
}
