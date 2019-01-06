//
//  PreferencesService.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira on 28/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import Foundation

public struct Keys {
    public static let Coin = Preferences<Coin>("Coin")
}

public struct Preferences<T: Codable> {
    fileprivate let key: String
    public init(_ key: String) {
        self.key = key
    }
}

class PreferencesService: PreferencesProvider {
    
    public static let shared = PreferencesService()
    
    private let userDefaults = UserDefaults(suiteName: "group.Shared")
    private init() {}
    
    func store<T>(preferences: Preferences<T>, value: T) {
        if !isCodable(T.self) {
            userDefaults?.set(value, forKey: preferences.key)
            userDefaults?.synchronize()
            return
        }
        
        do {
            let encoded = try JSONEncoder().encode(value)
            userDefaults?.set(encoded, forKey: preferences.key)
            userDefaults?.synchronize()
        } catch {
            #if DEBUG
            print(error)
            #endif
        }
    }
    
    func retrieve<T>(key: Preferences<T>) -> T? {
        userDefaults?.synchronize()
        if !isCodable(T.self) {
            return userDefaults?.value(forKey: key.key) as? T
        }
        
        guard let data = userDefaults?.data(forKey: key.key) else {
            return nil
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            #if DEBUG
            print(error)
            #endif
        }
        
        guard let value = userDefaults?.object(forKey: key.key) as? T else { return nil }
        return value
    }
    
    func remove<T>(key: Preferences<T>) {
        UserDefaults.standard.removeObject(forKey: key.key)
        UserDefaults.standard.synchronize()
    }
    
    func has<T>(key: Preferences<T>) -> Bool {
        guard let _ = retrieve(key: key) else { return false }
        return true
    }
    
    func clearUserDefaults() {
        UserDefaults.standard.removePersistentDomain(forName: "group.Shared")
        UserDefaults.standard.synchronize()
    }
    
    private func isCodable<T>(_ type: T.Type) -> Bool {
        switch type {
        case is String.Type, is Bool.Type, is Int.Type, is Float.Type, is Double.Type, is Date.Type:
            return false
        default:
            return true
        }
    }
    
}
