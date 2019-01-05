//
//  UIImageView.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira on 28/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import UIKit

extension UIImageView {
    convenience init(image: UIImage? = nil, contentMode: UIView.ContentMode, clipsToBounds: Bool = false) {
        self.init(image: image)
        self.contentMode = contentMode
        self.clipsToBounds = clipsToBounds
    }
}
