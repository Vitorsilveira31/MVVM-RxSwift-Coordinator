//
//  UITextField.swift
//  MVVM+Arch
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
    
    public var isValidEmail: Bool {
        guard let text = text else { return false }
        return text.isValidEmail
    }
    
    public var isValidCPFLength: Bool {
        guard let text = text else { return false }
        return text.isValidCPFLength
    }
    
    public var isValidCPF: Bool {
        guard let text = text else { return false }
        return text.isValidCPF
    }
    
    public var isValidCNPJLength: Bool {
        guard let text = text else { return false }
        return text.isValidCNPJLength
    }
    
    public var isValidCNPJ: Bool {
        guard let text = text else { return false }
        return text.isValidCNPJ
    }
    
    func setBottomBorder(color:UIColor) {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
