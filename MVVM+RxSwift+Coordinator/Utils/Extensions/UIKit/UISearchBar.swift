//
//  UISearchBar.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira on 22/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    func getSearchBarTextField() -> UITextField? {
        return getViewElement(type: UITextField.self)
    }
    
    func setPlaceholderTextColor(color: UIColor) {
        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
}
