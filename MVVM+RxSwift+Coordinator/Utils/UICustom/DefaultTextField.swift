//
//  DefaultTextField.swift
//  MVVM+RxSwift+Coordinator
//
//  Created by Vitor Silveira - VSV on 11/01/19.
//  Copyright © 2019 Vitor Silveira. All rights reserved.
//

import UIKit

enum DefaultTextFieldStyle {
    case rounded
}

class DefaultTextField: UITextField {
    
    private let textLeftPadding: CGFloat = 10
    private let textRightPadding: CGFloat = 10
    private var style: DefaultTextFieldStyle = .rounded
    
    init(placeholder: String = "", backgroundColor: UIColor = .white,
         style: DefaultTextFieldStyle = .rounded) {
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
        self.style = style
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch style {
        case .rounded:
            self.layer.cornerRadius = bounds.height / 2
            self.layer.borderWidth = 0.5
            self.borderColor = UIColor.gray
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + self.textLeftPadding,
                      y: bounds.origin.y,
                      width: bounds.size.width - self.textLeftPadding - self.textRightPadding,
                      height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
}
