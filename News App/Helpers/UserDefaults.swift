//
//  UserDefaults.swift
//  News App
//
//  Created by Andrii Tymoshchuk on 30.07.2022.
//

import Foundation

enum UserDefaultKeys: String, CaseIterable {
    case saveNews
    case country
}

final class UserDefaultsHelper {
    static func setData<T>(value: T, key: UserDefaultKeys) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key.rawValue)
    }
    
    static func getData<T>(type: T.Type, forKey: UserDefaultKeys) -> T? {
        let defaults = UserDefaults.standard
        let value = defaults.object(forKey: forKey.rawValue) as? T
        return value
    }
    
    static func removeData(key: UserDefaultKeys) {
        let defults = UserDefaults.standard
        defults.removeObject(forKey: key.rawValue)
    }
}

