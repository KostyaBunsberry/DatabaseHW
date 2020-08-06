//
//  Persistance.swift
//  hw14
//
//  Created by Kostya Bunsberry on 02.08.2020.
//

import Foundation

class Persistance {
    
    public static var shared = Persistance()
    
    private let kUserNameKey = "Persistance.kUserNameKey"
    private let kUserSurnameKey = "Persistance.kUserSurnameKey"
    
    var userName: String? {
        get { return UserDefaults.standard.string(forKey: kUserNameKey) }
        set { UserDefaults.standard.set(newValue, forKey: kUserNameKey) }
    }
    var userSurname: String? {
        get { return UserDefaults.standard.string(forKey: kUserSurnameKey) }
        set { UserDefaults.standard.set(newValue, forKey: kUserSurnameKey) }
    }
    
}
