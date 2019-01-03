//
//  UICollectionView.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira on 22/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
        self.register(T.self, forCellWithReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
    }

}
