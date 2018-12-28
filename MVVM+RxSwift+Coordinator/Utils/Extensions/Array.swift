//
//  Array.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira - VSV on 27/12/18.
//  Copyright © 2018 Vitor Silveira - VSV. All rights reserved.
//

import Foundation

public extension Array where Element: Hashable {
    public mutating func unify() {
        self = _undefined()
    }
}
