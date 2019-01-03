//
//  UILabel.swift
//  MVVM+Arch
//
//  Created by Vitor Silveira on 22/12/18.
//  Copyright © 2018 Vitor Silveira. All rights reserved.
//

import UIKit

public enum FontFamily {
    case italic
    case regular
    case bold
}

extension UILabel {
    convenience init(font: FontFamily = .regular,
                     withSize size: CGFloat = 16.0,
                     withColor textColor: UIColor = .darkGrey,
                     withText text: String? = nil,
                     withTextAlignment textAlignment: NSTextAlignment = .natural,
                     withLines numberLines: Int = 1) {
        self.init()
        self.textColor = .darkGrey
        self.numberOfLines = numberLines
        self.text = text
        self.textAlignment = textAlignment
        switch font {
        case .italic:
            self.font = UIFont.italicSystemFont(ofSize: size)
        case .regular:
            self.font = UIFont.systemFont(ofSize: size)
        case .bold:
            self.font = UIFont.boldSystemFont(ofSize: size)
        }
    }

    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.lineSpacing = lineHeight
            let attributeString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
            self.attributedText = attributeString
        }
    }
}
