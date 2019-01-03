//
//  Array.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira on 27/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import Foundation

public extension Array where Element: Hashable {
    public mutating func unify() {
        self = _undefined()
    }
}
