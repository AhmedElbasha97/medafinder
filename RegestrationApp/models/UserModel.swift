//
//  UserModel.swift
//  RegestrationApp
//
//  Created by ahmedelbasha on 4/29/20.
//  Copyright © 2020 ahmedelbasha. All rights reserved.
//


import Foundation
import UIKit
import SQLite
struct users: Codable {
    
    let name: String!
    let email: String!
    let password: String!
    let contactNum: String!
    let gender: String!
    let address: String!
    let image: Data!
  
    
}


    

func saveUser(_ user: [users] ) {
    let data = user.map { try? JSONEncoder().encode($0) }
    UserDefaults.standard.set(data, forKey: UserDefaultsKeys.userModel)
}

func loadUser() -> [users] {
    guard let encodedData = UserDefaults.standard.array(forKey: UserDefaultsKeys.userModel) as? [Data] else {
        return []
    }
    
    return encodedData.map { try! JSONDecoder().decode(users.self, from: $0) }
}


