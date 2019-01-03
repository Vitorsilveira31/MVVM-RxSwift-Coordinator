//
//  Collection.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira on 27/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import Foundation

public extension Collection where Element: Hashable {
    public func unified() -> [Element] {
        return reduce(into: []) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }
}
