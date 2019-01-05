//
//  UITextField.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira on 22/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import UIKit

extension UITextField {
    
    convenience init(borderStyle: UITextField.BorderStyle = .roundedRect, textAlignment: NSTextAlignment) {
        self.init()
        self.borderStyle = borderStyle
        self.textAlignment = textAlignment
    }
}
