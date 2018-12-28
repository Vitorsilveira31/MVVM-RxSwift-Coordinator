//
//  UIImageView.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira - VSV on 28/12/18.
//  Copyright © 2018 Vitor Silveira - VSV. All rights reserved.
//

import UIKit

extension UIImageView {
    convenience init(image: UIImage? = nil, contentMode: UIView.ContentMode, clipsToBounds: Bool = false) {
        self.init(image: image)
        self.contentMode = contentMode
        self.clipsToBounds = clipsToBounds
    }
}
