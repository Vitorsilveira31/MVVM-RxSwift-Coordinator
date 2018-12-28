//
//  PreferencesProvider.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira - VSV on 28/12/18.
//  Copyright © 2018 Vitor Silveira - VSV. All rights reserved.
//

import Foundation

protocol PreferencesProvider {
    func store<T>(preferences: Preferences<T>, value: T)
    func retrieve<T>(key: Preferences<T>) -> T?
    func remove<T>(key: Preferences<T>)
    func has<T>(key: Preferences<T>) -> Bool
    func clearUserDefaults()
}
